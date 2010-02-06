From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Kernel unaligned access at TPC[10101f18]
 btrfs_csum_final+0x38/0x60
Date: Fri, 5 Feb 2010 21:13:00 -0800 (PST)
Message-ID: <alpine.DEB.2.01.1002052106400.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1002051020020.3483@bogon.housecafe.de> <20100205.120151.128582331.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Miller <davem@davemloft.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100205.120151.128582331.davem@davemloft.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 5 Feb 2010 at 12:01, David Miller wrote:
> Can you rerun your test with the following patch applied?
> It will obtain more information for the btrfs developers.

Thanks, David! Here it is:

[ 1861.965178] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
[ 1862.060546] Caller [100a6044:crc32c+0x44/0x80 [libcrc32c]]
[ 1862.126652] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
[ 1862.221928] Caller [100a6044:crc32c+0x44/0x80 [libcrc32c]]

It's always libcrc32c and the numbers stay the same too. Full dmesg here:
http://nerdbynature.de/bits/2.6.33-rc6/btrfs/

HTH,
Christian.
-- 
BOFH excuse #37:

heavy gravity fluctuation, move computer to floor rapidly
