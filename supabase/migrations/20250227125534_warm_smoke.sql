/*
  # Initial schema setup

  1. New Tables
    - `profiles`
      - `id` (uuid, primary key, references auth.users)
      - `nickname` (text, not null)
      - `created_at` (timestamp with time zone)
      - `updated_at` (timestamp with time zone)
    - `roles`
      - `id` (uuid, primary key)
      - `name` (text, not null)
      - `created_at` (timestamp with time zone)
  
  2. Security
    - Enable RLS on `profiles` table
    - Add policies for authenticated users to read their own data
    - Add policies for admin users to read all profiles
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
  nickname TEXT NOT NULL,
  is_admin BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can read own profile"
  ON profiles
  FOR SELECT
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles
  FOR UPDATE
  TO authenticated
  USING (auth.uid() = id);

CREATE POLICY "Admin users can read all profiles"
  ON profiles
  FOR SELECT
  TO authenticated
  USING (is_admin = TRUE);

CREATE POLICY "Admin users can update all profiles"
  ON profiles
  FOR UPDATE
  TO authenticated
  USING (is_admin = TRUE);

-- Create function to handle new user signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, nickname)
  VALUES (new.id, new.email);
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();