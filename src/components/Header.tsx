import { ShoppingCart, Search, Menu } from 'lucide-react';
import { useCart } from '../context/CartContext';

interface HeaderProps {
  onCartClick: () => void;
  onSearchChange: (value: string) => void;
  searchQuery: string;
}

export default function Header({ onCartClick, onSearchChange, searchQuery }: HeaderProps) {
  const { cartCount } = useCart();

  return (
    <header className="bg-white shadow-sm sticky top-0 z-40">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          <div className="flex items-center space-x-8">
            <div className="flex items-center space-x-2">
              <ShoppingCart className="w-8 h-8 text-emerald-600" />
              <h1 className="text-2xl font-bold text-gray-900">ShopHub</h1>
            </div>

            <nav className="hidden md:flex space-x-6">
              <a href="#" className="text-gray-700 hover:text-emerald-600 font-medium transition-colors">Home</a>
              <a href="#" className="text-gray-700 hover:text-emerald-600 font-medium transition-colors">Products</a>
              <a href="#" className="text-gray-700 hover:text-emerald-600 font-medium transition-colors">Categories</a>
              <a href="#" className="text-gray-700 hover:text-emerald-600 font-medium transition-colors">About</a>
            </nav>
          </div>

          <div className="flex items-center space-x-4">
            <div className="hidden sm:flex items-center bg-gray-100 rounded-lg px-4 py-2 w-64">
              <Search className="w-5 h-5 text-gray-400" />
              <input
                type="text"
                placeholder="Search products..."
                value={searchQuery}
                onChange={(e) => onSearchChange(e.target.value)}
                className="bg-transparent border-none outline-none ml-2 w-full text-sm"
              />
            </div>

            <button
              onClick={onCartClick}
              className="relative p-2 hover:bg-gray-100 rounded-lg transition-colors"
            >
              <ShoppingCart className="w-6 h-6 text-gray-700" />
              {cartCount > 0 && (
                <span className="absolute -top-1 -right-1 bg-emerald-600 text-white text-xs font-bold rounded-full w-5 h-5 flex items-center justify-center">
                  {cartCount}
                </span>
              )}
            </button>

            <button className="md:hidden p-2 hover:bg-gray-100 rounded-lg transition-colors">
              <Menu className="w-6 h-6 text-gray-700" />
            </button>
          </div>
        </div>

        <div className="sm:hidden pb-3">
          <div className="flex items-center bg-gray-100 rounded-lg px-4 py-2">
            <Search className="w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search products..."
              value={searchQuery}
              onChange={(e) => onSearchChange(e.target.value)}
              className="bg-transparent border-none outline-none ml-2 w-full text-sm"
            />
          </div>
        </div>
      </div>
    </header>
  );
}
