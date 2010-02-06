From: David Miller <davem@davemloft.net>
Subject: Re: Kernel unaligned access at TPC[10101f18]
 btrfs_csum_final+0x38/0x60
Date: Fri, 05 Feb 2010 22:43:10 -0800 (PST)
Message-ID: <20100205.224310.06173989.davem@davemloft.net>
References: <alpine.DEB.2.01.1002052106400.3483@bogon.housecafe.de>
	<20100205.213220.147487541.davem@davemloft.net>
	<alpine.DEB.2.01.1002052226480.3483@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: lists@nerdbynature.de
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.1002052226480.3483@bogon.housecafe.de>
List-ID: <linux-btrfs.vger.kernel.org>

From: Christian Kujau <lists@nerdbynature.de>
Date: Fri, 5 Feb 2010 22:28:47 -0800 (PST)

> Hm, now it looks like this, but I don't know how it'd reveal more 
> information:
> 
> [  210.707051] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> [  210.802236] Caller [10101f1c:btrfs_csum_final+0x3c/0x60 [btrfs]]
> [  210.874620] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> [  210.969899] Caller [10101f1c:btrfs_csum_final+0x3c/0x60 [btrfs]]
> [  228.724982] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> [  228.820220] Caller [10101f1c:btrfs_csum_final+0x3c/0x60 [btrfs]]
> [  228.892286] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> [  228.987851] Caller [10101f1c:btrfs_csum_final+0x3c/0x60 [btrfs]]
> 
> I'm open for more patches :-)

Confusing for me too.  I'll try to think about this some more.
