Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34069 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbbENMad (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 May 2015 08:30:33 -0400
Received: by wguv19 with SMTP id v19so11589417wgu.1
        for <linux-btrfs@vger.kernel.org>; Thu, 14 May 2015 05:30:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1430614560-4680-1-git-send-email-fdmanana@suse.com>
References: <1430614560-4680-1-git-send-email-fdmanana@suse.com>
Date: Thu, 14 May 2015 14:30:29 +0200
Message-ID: <CAMQ-g0dQSuz+5BGG+gU_Q4btwg3+5O_OhM3c9fOLHZ3qKWfYoA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: incremental send, fix clone operations for
 compressed extents
From: Jan Alexander Steffens <jan.steffens@gmail.com>
To: Filipe Manana <fdmanana@suse.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, marc@merlins.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 3, 2015 at 2:56 AM, Filipe Manana <fdmanana@suse.com> wrote:
> Marc reported a problem where the receiving end of an incremental send
> was performing clone operations that failed with -EINVAL. This happened
> because, unlike for uncompressed extents, we were not checking if the
> source clone offset and length, after summing the data offset, falls
> within the source file's boundaries.
>
> So make sure we do such checks when attempting to issue clone operations
> for compressed extents.
>
> Problem reproducible with the following steps:
>
>   $ mkfs.btrfs -f /dev/sdb
>   $ mount -o compress /dev/sdb /mnt
>   $ mkfs.btrfs -f /dev/sdc
>   $ mount -o compress /dev/sdc /mnt2
>
>   # Create the file with a single extent of 128K. This creates a metadata file
>   # extent item with a data start offset of 0 and a logical length of 128K.
>   $ xfs_io -f -c "pwrite -S 0xaa 64K 128K" -c "fsync" /mnt/foo
>
>   # Now rewrite the range 64K to 112K of our file. This will make the inode's
>   # metadata continue to point to the 128K extent we created before, but now
>   # with an extent item that points to the extent with a data start offset of
>   # 112K and a logical length of 16K.
>   # That metadata file extent item is associated with the logical file offset
>   # at 176K and covers the logical file range 176K to 192K.
>   $ xfs_io -c "pwrite -S 0xbb 64K 112K" -c "fsync" /mnt/foo
>
>   # Now rewrite the range 180K to 12K. This will make the inode's metadata
>   # continue to point the the 128K extent we created earlier, with a single
>   # extent item that points to it with a start offset of 112K and a logical
>   # length of 4K.
>   # That metadata file extent item is associated with the logical file offset
>   # at 176K and covers the logical file range 176K to 180K.
>   $ xfs_io -c "pwrite -S 0xcc 180K 12K" -c "fsync" /mnt/foo
>
>   $ btrfs subvolume snapshot -r /mnt /mnt/snap1
>
>   $ touch /mnt/bar
>   # Calls the btrfs clone ioctl.
>   $ ~/xfstests/src/cloner -s $((176 * 1024)) -d $((176 * 1024)) \
>     -l $((4 * 1024)) /mnt/foo /mnt/bar
>
>   $ btrfs subvolume snapshot -r /mnt /mnt/snap2
>
>   $ btrfs send /mnt/snap1 | btrfs receive /mnt2
>   At subvol /mnt/snap1
>   At subvol snap1
>
>   $ btrfs send -p /mnt/snap1 /mnt/snap2 | btrfs receive /mnt2
>   At subvol /mnt/snap2
>   At snapshot snap2
>   ERROR: failed to clone extents to bar
>   Invalid argument
>
> A test case for fstests follows soon.
>
> Reported-by: Marc MERLIN <marc@merlins.org>
> Tested-by: Marc MERLIN <marc@merlins.org>
> Signed-off-by: Filipe Manana <fdmanana@suse.com>

Tested-by: Jan Alexander Steffens (heftig) <jan.steffens@gmail.com>
