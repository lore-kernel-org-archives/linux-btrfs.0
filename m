From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BUG at fs/buffer.c:2933 during umount
Date: Tue, 05 May 2009 15:31:38 -0400
Message-ID: <1241551898.7244.99.camel@think.oraclecorp.com>
References: <alpine.DEB.2.01.0905051212210.6162@bogon.housecafe.de>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Christian Kujau <lists@nerdbynature.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.01.0905051212210.6162@bogon.housecafe.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-05-05 at 12:23 -0700, Christian Kujau wrote:
> Hi,
> 
> I could not find this anywhere else reported, so here we go:
> creating a new btrfs filesystem (btrfs-progs-unstable from git) and 
> mounting it succeeds, unmounting however fails with the kernel messages 
> attached to this mail. After that, I can still read and write to the 
> btrfs mount, but e.g. /bin/sync never finishes, sysrq-s never reports 
> "Sync complete".
> 
> I'm using a vanilla kernel, yesterday's git version 
> and I *think* I remember having creating btrfs filesystems before (2.6.29, 
> IIRC) and being able to umount them without problems. But I don't know for 
> sure...yet.

Somehow xen is turning a barrier request into an IO error.  That's
really quite strange, but you can mount -o nobarrier.

-chris



