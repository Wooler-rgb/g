import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  // Allow cross-origin access from local network in development
  // (e.g. when accessing from 26.28.19.x or any LAN device)
  allowedDevOrigins: [
    '26.28.19.191',
    '26.28.19.*',
    '192.168.*.*',
    '10.*.*.*',
    '172.16.*.*',
  ],
};

export default nextConfig;
