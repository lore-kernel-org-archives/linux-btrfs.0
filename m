From: Chris Mason <chris.mason@oracle.com>
Subject: Re: system crash at mounting of btrfs
Date: Tue, 12 Oct 2010 20:49:15 -0400
Message-ID: <20101013004915.GM22691@think>
References: <loom.20101007T155351-932@post.gmane.org>
 <20101008171635.GS4804@think>
 <loom.20101009T073143-310@post.gmane.org>
 <loom.20101009T150327-437@post.gmane.org>
 <20101011235525.GK22691@think>
 <loom.20101012T083638-169@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Gerhard Kulzer <gerhard@kulzer.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20101012T083638-169@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 12, 2010 at 06:44:13AM +0000, Gerhard Kulzer wrote:
> Chris Mason <chris.mason <at> oracle.com> writes:
> 
> 
> > 
> > Ok, so tell me more about the SSD with the btrfs-of-death.  Is it a
> > multi-device SSD?
> > 
> > -chris
> > 
> Its a single device Intel X25-M G2 Postville 80GB

Ok, if you can confirm this is the very first oops you see:

[    7.923556] kernel BUG at /build/buildd/linux-2.6.35/fs/btrfs/tree-log.c:813!

I've got a utility that will wipe the log and get you mountable again.
The intel drive should definitely support barriers, are you doing
anything with LVM or raid or dm-crypt on top of it?

-chris
