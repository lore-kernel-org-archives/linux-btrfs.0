From: Sage Weil <sage@newdream.net>
Subject: Re: [PATCH 0/6] Btrfs commit fixes, async subvol operations
Date: Mon, 25 Oct 2010 14:27:16 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.1010251343060.7660@cobra.newdream.net>
References: <1288033662-21464-1-git-send-email-sage@newdream.net>
 <20101025192932.GG18818@think> <Pine.LNX.4.64.1010251239080.7660@cobra.newdream.net>
 <20101025195842.GI18818@think>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101025195842.GI18818@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 25 Oct 2010, Chris Mason wrote:
> Yes, lets duplicate the vfs checks.  Christoph just sat bolt upright in
> whatever ski lift he's currently riding.

:)

This version is based on Goffredo's patch, but requires the 
user_subvol_rm_allowed mount option, and will proceed even if the subvol 
is nonempty.  (I suspect we also want his other rmdir(2) patch at some 
point as well so that users can rmdir an empty subvol and/or 'rm -r'.)

> We should also make sure they do the subvol rm against the root of the
> subvol (if that check isn't already done), none of the magic to resolve
> the subvol based on any file inside it.  I don't want people to
> accidentally think they are deleting a subdir and have it go higher up
> into the directory tree.
> 
> Oh, and it shouldn't work on the root of the FS either ;)

Since the ioctl is based on a name lookup, I added a check that the parent 
inode's root isn't the same as the target root.  That implies the ioctl is 
called the dentry referencing the subvol, and presumably the root doesn't 
have one of those.  Does that cover it?  It isn't possible to have the 
subvol bound to multiple locations in the namespace, right?

$ whoami
sage
$ btrfs sub create a
Create subvolume './a'
$ btrfs sub create a/b
Create subvolume 'a/b'
$ btrfs sub snap a asnap
Create a snapshot of 'a' in './asnap'
$ btrfs sub del asnap/b 
ERROR: 'asnap/b' is not a subvolume
$ btrfs sub del a
Delete subvolume '/mnt/osd27/a/a'
ERROR: cannot delete '/mnt/osd27/a/a'
$ btrfs sub del a/b
Delete subvolume '/mnt/osd27/a/a/b'
$ btrfs sub del a  
Delete subvolume '/mnt/osd27/a/a'
$ btrfs sub del asnap
Delete subvolume '/mnt/osd27/a/asnap'

Sending the patch separately.

Thanks!
sage
