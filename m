Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:34154 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbbE3I6o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 May 2015 04:58:44 -0400
Received: by pdbki1 with SMTP id ki1so70603715pdb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 30 May 2015 01:58:42 -0700 (PDT)
Date: Sat, 30 May 2015 01:58:40 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Markus Schauler <mschauler@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS issue: deleting default snapshot causes kernel oops
Message-ID: <20150530085840.GA24210@mew>
References: <CAB8YbStYrFTnY6Jt03b=etgJ73pWO_xSN0SMingNtOOnMbjTvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB8YbStYrFTnY6Jt03b=etgJ73pWO_xSN0SMingNtOOnMbjTvg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 29, 2015 at 11:14:13PM +0200, Markus Schauler wrote:
> Hi,
> 
> I'm having an issue with Btrfs on an opensuse Tumbleweed system using
> kernel 4.0.4-1
> 
> Here's what happened:
> I use the snapper tool to create periodic snapshots of the root FS
> After having problems with an update, I rolled back my system by
> seting the default subvolume for / to snapshot 398 (the last good
> snapshot)
> After rebooting, everything was fine.
> 
> Some days later, snapper decided to delete the old snapshot 398 (that
> was mounted as /)
> Then, the system stopped with this error:
[snipped]

Oh, this is kind of amusing. I couldn't reproduce the oops, but I did
get some buggy behavior.

In my test setup, snap1 on /dev/vda1 is the default subvolume and
mounted as root.

# mount -osubvol=/ /dev/vda1 /mnt
# btrfs subvol del /mnt/snap1
Delete subvolume (no-commit): '/mnt/snap1'
ERROR: cannot delete '/mnt/snap1' - Operation not permitted
# ls /
bin  boot  dev  etc  home  lib  lib64  mnt  mnt2  opt  proc  root  run sbin  srv  sys  tmp  usr  var

Okay, looks fine so far. Let's double check the mounted filesystems...

# findmnt
findmnt: can't read /proc/mounts: No such file or directory

Huh?

# ls /proc
# ls /dev
# ls /sys
#

Nothing. The problem is clear looking at btrfs_ioctl_snap_destroy():

	d_invalidate(dentry);

	down_write(&root->fs_info->subvol_sem);

	err = may_destroy_subvol(dest);
	if (err)
		goto out_up_write;

And d_invalidate():

 * d_invalidate - detach submounts, prune dcache, and drop

So /proc and friends all got unmounted BEFORE we backed out and realized
that this was a bad idea, which explains what I saw. My wild guess is
that the crash you saw was a side effect of the root dentry being
dropped :)

This happens because d_invalidate() doesn't fail for a mounted subvolume
anymore (the same thing that made it possible to delete mounted
subvolumes in general). The fix should be simple enough: don't
d_invalidate() until after we check may_destroy_subvol(). I'll send in a
patch.

-- 
Omar
