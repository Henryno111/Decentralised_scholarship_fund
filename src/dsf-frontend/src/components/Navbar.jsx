// eslint-disable-next-line no-unused-vars
import React, { useState } from 'react';
import { Menu, X, Wallet } from 'lucide-react';
// import './index.css';

const Navbar = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [isConnected, setIsConnected] = useState(false);

  const toggleMenu = () => setIsOpen(!isOpen);

  const handleConnect = () => {
    // Placeholder for wallet connection logic
    setIsConnected(!isConnected);
  };

  return (
    <nav className="bg-gray-900 fixed w-full top-0 left-0 z-50">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <div className="flex-shrink-0">
            <span className="text-white text-xl font-bold">Scholarship Fund</span>
          </div>

          {/* Desktop Menu */}
          <div className="hidden md:block">
            <div className="ml-10 flex items-center space-x-8">
              <a href="#" className="text-gray-300 hover:text-white px-3 py-2 rounded-md text-sm font-medium">
                Home
              </a>
              <a href="#" className="text-gray-300 hover:text-white px-3 py-2 rounded-md text-sm font-medium">
                Schools
              </a>
              <a href="#" className="text-gray-300 hover:text-white px-3 py-2 rounded-md text-sm font-medium">
                Apply
              </a>
              <a href="#" className="text-gray-300 hover:text-white px-3 py-2 rounded-md text-sm font-medium">
                DAO
              </a>
            </div>
          </div>

          {/* Connect Wallet Button */}
          <div className="hidden md:block">
            <button
              onClick={handleConnect}
              className="flex items-center px-4 py-2 rounded-lg bg-blue-600 hover:bg-blue-700 text-white font-medium transition-colors"
            >
              <Wallet className="w-4 h-4 mr-2" />
              {isConnected ? 'Connected' : 'Connect Wallet'}
            </button>
          </div>

          {/* Mobile menu button */}
          <div className="md:hidden flex items-center">
            <button
              onClick={toggleMenu}
              className="inline-flex items-center justify-center p-2 rounded-md text-gray-400 hover:text-white hover:bg-gray-700 focus:outline-none"
            >
              {isOpen ? <X className="h-6 w-6" /> : <Menu className="h-6 w-6" />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile menu */}
      {isOpen && (
        <div className="md:hidden bg-gray-900 shadow-lg">
          <div className="px-2 pt-2 pb-3 space-y-1">
            <a href="#" className="text-gray-300 hover:text-white block px-3 py-2 rounded-md text-base font-medium">
              Home
            </a>
            <a href="#" className="text-gray-300 hover:text-white block px-3 py-2 rounded-md text-base font-medium">
              Marketplace
            </a>
            <a href="#" className="text-gray-300 hover:text-white block px-3 py-2 rounded-md text-base font-medium">
              Staking
            </a>
            <a href="#" className="text-gray-300 hover:text-white block px-3 py-2 rounded-md text-base font-medium">
              DAO
            </a>
            <button
              onClick={handleConnect}
              className="flex items-center w-full px-4 py-2 rounded-lg bg-blue-600 hover:bg-blue-700 text-white font-medium transition-colors"
            >
              <Wallet className="w-4 h-4 mr-2" />
              {isConnected ? 'Connected' : 'Connect Wallet'}
            </button>
          </div>
        </div>
      )}
    </nav>
  );
};

export default Navbar;