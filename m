From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Kernel unaligned access at TPC[10101f18]
 btrfs_csum_final+0x38/0x60
Date: Mon, 8 Feb 2010 16:46:19 -0500
Message-ID: <20100208214619.GB2814@think>
References: <alpine.DEB.2.01.1002052106400.3483@bogon.housecafe.de>
 <20100205.213220.147487541.davem@davemloft.net>
 <alpine.DEB.2.01.1002052226480.3483@bogon.housecafe.de>
 <20100205.224310.06173989.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lists@nerdbynature.de, linux-btrfs@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100205.224310.06173989.davem@davemloft.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 05, 2010 at 10:43:10PM -0800, David Miller wrote:
> From: Christian Kujau <lists@nerdbynature.de>
> Date: Fri, 5 Feb 2010 22:28:47 -0800 (PST)
> 
> > Hm, now it looks like this, but I don't know how it'd reveal more 
> > information:
> > 
> > [  210.707051] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> > [  210.802236] Caller [10101f1c:btrfs_csum_final+0x3c/0x60 [btrfs]]
> > [  210.874620] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> > [  210.969899] Caller [10101f1c:btrfs_csum_final+0x3c/0x60 [btrfs]]
> > [  228.724982] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> > [  228.820220] Caller [10101f1c:btrfs_csum_final+0x3c/0x60 [btrfs]]
> > [  228.892286] Kernel unaligned access at TPC[10101f18] btrfs_csum_final+0x38/0x60 [btrfs]
> > [  228.987851] Caller [10101f1c:btrfs_csum_final+0x3c/0x60 [btrfs]]
> > 
> > I'm open for more patches :-)
> 
> Confusing for me too.  I'll try to think about this some more.

It is probably the directory code.  I switched that to crc32c since
you tried things.

-chris

