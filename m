From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Kernel unaligned access at TPC[10101f18]
 btrfs_csum_final+0x38/0x60
Date: Fri, 5 Feb 2010 22:28:47 -0800 (PST)
Message-ID: <alpine.DEB.2.01.1002052226480.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1002051020020.3483@bogon.housecafe.de> <20100205.120151.128582331.davem@davemloft.net> <alpine.DEB.2.01.1002052106400.3483@bogon.housecafe.de> <20100205.213220.147487541.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Miller <davem@davemloft.net>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100205.213220.147487541.davem@davemloft.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 5 Feb 2010 at 21:32, David Miller wrote:
> My debugging patch didn't work correctly.
> Can you try using this one instead?

Hm, now it looks like this, but I don't know how it'd reveal more 
information:

[  210.707051] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
[  210.802236] Caller [10101f1c:btrfs_csum_final+0x3c/0x60 [btrfs]]
[  210.874620] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
[  210.969899] Caller [10101f1c:btrfs_csum_final+0x3c/0x60 [btrfs]]
[  228.724982] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
[  228.820220] Caller [10101f1c:btrfs_csum_final+0x3c/0x60 [btrfs]]
[  228.892286] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
[  228.987851] Caller [10101f1c:btrfs_csum_final+0x3c/0x60 [btrfs]]

I'm open for more patches :-)

Christian.
-- 
BOFH excuse #277:

Your Flux Capacitor has gone bad.
