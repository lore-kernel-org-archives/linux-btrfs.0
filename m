From: Chris Mason <chris.mason@oracle.com>
Subject: Re: brtfs on top of dmcrypt with SSD. No corruption iff write cache
 off?
Date: Wed, 1 Feb 2012 12:56:24 -0500
Message-ID: <20120201175624.GE16796@shiny>
References: <20120130003754.GD4380@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120130003754.GD4380@merlins.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 29, 2012 at 04:37:54PM -0800, Marc MERLIN wrote:
> Howdy,
> 
> I'm considering using brtfs for my new laptop install.
> 
> Encryption is however a requirement, and ecryptfs doesn't quite cut it for
> me, so that leaves me with dmcrypt which is what I've been using with
> ext3/ext4 for years.
> 
> https://btrfs.wiki.kernel.org/articles/g/o/t/Gotchas.html 
> still states that 
> 'dm-crypt block devices require write-caching to be turned off on the
> underlying HDD'
> While the report was for 2.6.33, I'll assume it's still true.
> 
> 
> I was considering migrating to a recent 256GB SSD and 3.2.x kernel.
> 
> First, I'd like to check if the 'turn off write cache' comment is still
> accurate and if it does apply to SSDs too.
> 
> Second, I was wondering if anyone is running btrfs over dmcrypt on an SSD
> and what the performance is like with write cache turned off (I'm actually
> not too sure what the impact is for SSDs considering that writing to flash
> can actually be slower than writing to a hard drive).

Performance without the cache on is going to vary wildly from one SSD to
another.  Some really need it to give them nice fat writes while others
do better on smaller writes.  It's best to just test yours and see.

With a 3.2 kernel (it really must be 3.2 or higher), both btrfs and dm
are doing the right thing for barriers.

-chris

