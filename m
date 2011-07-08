From: Yi Yang <yi.y.yang@intel.com>
Subject: How to get the default subvolume?
Date: Fri, 8 Jul 2011 17:58:02 +0800
Message-ID: <20110708095802.GA11513@yangyi-dev.bj.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: yi.y.yang@intel.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I know I can set the default subvolume for a btrfs fs using

sudo btrfs subvolume set-default 256 /btrfs/mnt

But after that, how can get the default subvolume name? In my opinion,
btrfs-progs should provide "btrfs subvolume get-default /btrfs/mnm" to get
the default subvolume id and name, I think it is very easy to do this in
btrfs-progs and btrfs kernel space.

