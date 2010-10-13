From: Gerhard Kulzer <gerhard@kulzer.net>
Subject: Re: system crash at mounting of btrfs
Date: Wed, 13 Oct 2010 06:42:07 +0000 (UTC)
Message-ID: <loom.20101013T084018-202@post.gmane.org>
References: <loom.20101007T155351-932@post.gmane.org> <20101008171635.GS4804@think> <loom.20101009T073143-310@post.gmane.org> <loom.20101009T150327-437@post.gmane.org> <20101011235525.GK22691@think> <loom.20101012T083638-169@post.gmane.org> <20101013004915.GM22691@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason <at> oracle.com> writes:


> > Its a single device Intel X25-M G2 Postville 80GB
> 
> Ok, if you can confirm this is the very first oops you see:
> 
> kernel BUG at /build/buildd/linux-2.6.35/fs/btrfs/tree-log.c:813!
> 
> I've got a utility that will wipe the log and get you mountable again.
> The intel drive should definitely support barriers, are you doing
> anything with LVM or raid or dm-crypt on top of it?
> 
I think somebody replied in my place...

I don't use any lvm or raid or dm_crypt, just 1 straight partition formatted as
btrfs.

Gerhard




