import React from 'react';
import { useAuth } from '../context/AuthContext';
import { LogOut } from 'lucide-react';

const Home: React.FC = () => {
  const { profile, signOut } = useAuth();

  const handleSignOut = async () => {
    try {
      await signOut();
    } catch (error) {
      console.error('Error signing out:', error);
    }
  };

  return (
    <div className="min-h-screen bg-gray-100">
      <header className="bg-white shadow">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4 flex justify-between items-center">
          <h1 className="text-2xl font-bold text-gray-900">Welcome to Our App</h1>
          <button
            onClick={handleSignOut}
            className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-md text-white bg-red-600 hover:bg-red-700"
          >
            <LogOut className="h-4 w-4 mr-2" />
            Sign out
          </button>
        </div>
      </header>
      <main className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="bg-white shadow rounded-lg p-6">
          <h2 className="text-xl font-semibold mb-4">Your Profile</h2>
          {profile ? (
            <div>
              <p className="mb-2">
                <span className="font-medium">Nickname:</span> {profile.nickname}
              </p>
              <p className="mb-2">
                <span className="font-medium">Role:</span> {profile.is_admin ? 'Admin' : 'User'}
              </p>
              <p>
                <span className="font-medium">Joined:</span>{' '}
                {new Date(profile.created_at).toLocaleDateString()}
              </p>
            </div>
          ) : (
            <p>Loading profile information...</p>
          )}
        </div>
      </main>
    </div>
  );
};

export default Home;