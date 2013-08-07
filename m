Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756864Ab3HGDEh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 23:04:37 -0400
Message-ID: <5201B942.7050605@redhat.com>
Date: Tue, 06 Aug 2013 22:04:34 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Filipe David Borba Manana <fdmanana@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] Btrfs: add support for persistent mount options
References: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
In-Reply-To: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/6/13 1:27 PM, Filipe David Borba Manana wrote:
> This change allows for most mount options to be persisted in
> the filesystem, and be applied when the filesystem is mounted.
> If the same options are specified at mount time, the persisted
> values for those options are ignored.

I thought the plan was to make commandline mount options
override persistent ones, but that doesn't seem to be the case,
at least in this example:

# ./btrfstune -o compress,discard,ssd /dev/sdb1
New persistent options:      compress,discard,ssd
# mount -o nossd /dev/sdb1 /mnt/test
# dmesg | tail
[  995.657233] btrfs: use ssd allocation scheme
[  995.661501] btrfs: disk space caching is enabled

and /proc/mounts is similarly confused, showing both options:

# grep sdb1 /proc/mounts
/dev/sdb1 /mnt/test btrfs rw,seclabel,relatime,compress=zlib,nossd,ssd,discard,space_cache 0 0

(This is the trail of woe I was talking about from ext4-land) ;)

> The only options not supported are: subvol, subvolid, subvolrootid,
> device and thread_pool. This limitation is due to how this feature
> is implemented: basically there's an optional value (of type
> struct btrfs_dir_item) in the tree of tree roots used to store the
> list of options in the same format as they are passed to btrfs_mount().
> This means any mount option that takes effect before the tree of tree
> roots is setup is not supported.

Just FWIW, vfs-level mount options are also not supported; i.e. "noatime"
or "ro" won't work either, because the code is already past the VFS
option parsing:

# ./btrfstune -o compress,discard,ro /dev/sdb1
Current persistent options:  compress,discard
New persistent options:      compress,discard,ro
# mount /dev/sdb1 /mnt/test
mount: wrong fs type, bad option, bad superblock on /dev/sdb1, ...
# dmesg | tail
[  817.681417] btrfs: unrecognized mount option 'ro'
[  817.694689] btrfs: open_ctree failed

> To set these options, the user space tool btrfstune was modified
> to persist the list of options into an unmounted filesystem's
> tree of tree roots.

If this goes forward, you'd want an easy way to display
them, not just set them, I suppose.

Thanks,
-Eric
 
> NOTE: Like the corresponding btrfs-progs patch, this is a WIP with
> the goal o gathering feedback.
> 
> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>


