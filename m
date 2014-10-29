Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9029 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932388AbaJ2MUG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 08:20:06 -0400
Date: Wed, 29 Oct 2014 08:19:58 -0400
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v4] Btrfs: fix snapshot inconsistency after a file write
 followed by truncate
To: Filipe Manana <fdmanana@suse.com>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Message-ID: <1414585198.2166.6@mail.thefacebook.com>
In-Reply-To: <1414583879-10913-1-git-send-email-fdmanana@suse.com>
References: <1413886363-12442-1-git-send-email-fdmanana@suse.com>
	<1414583879-10913-1-git-send-email-fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On Wed, Oct 29, 2014 at 7:57 AM, Filipe Manana <fdmanana@suse.com> 
wrote:
> If right after starting the snapshot creation ioctl we perform a 
> write against a
> file followed by a truncate, with both operations increasing the 
> file's size, we
> can get a snapshot tree that reflects a state of the source 
> subvolume's tree where
> the file truncation happened but the write operation didn't. This 
> leaves a gap
> between 2 file extent items of the inode, which makes btrfs' fsck 
> complain about it.
> 
> For example, if we perform the following file operations:
> 
>     $ mkfs.btrfs -f /dev/vdd
>     $ mount /dev/vdd /mnt
>     $ xfs_io -f \
>           -c "pwrite -S 0xaa -b 32K 0 32K" \
>           -c "fsync" \
>           -c "pwrite -S 0xbb -b 32770 16K 32770" \
>           -c "truncate 90123" \
>           /mnt/foobar
> 
> and the snapshot creation ioctl was just called before the second 
> write, we often
> can get the following inode items in the snapshot's btree:
> 
>         item 120 key (257 INODE_ITEM 0) itemoff 7987 itemsize 160
>                 inode generation 146 transid 7 size 90123 block group 
> 0 mode 100600 links 1 uid 0 gid 0 rdev 0 flags 0x0
>         item 121 key (257 INODE_REF 256) itemoff 7967 itemsize 20
>                 inode ref index 282 namelen 10 name: foobar
>         item 122 key (257 EXTENT_DATA 0) itemoff 7914 itemsize 53
>                 extent data disk byte 1104855040 nr 32768
>                 extent data offset 0 nr 32768 ram 32768
>                 extent compression 0
>         item 123 key (257 EXTENT_DATA 53248) itemoff 7861 itemsize 53
>                 extent data disk byte 0 nr 0
>                 extent data offset 0 nr 40960 ram 40960
>                 extent compression 0
> 
> There's a file range, corresponding to the interval [32K; ALIGN(16K + 
> 32770, 4096)[
> for which there's no file extent item covering it. This is because 
> the file write
> and file truncate operations happened both right after the snapshot 
> creation ioctl
> called btrfs_start_delalloc_inodes(), which means we didn't start and 
> wait for the
> ordered extent that matches the write and, in btrfs_setsize(), we 
> were able to call
> btrfs_cont_expand() before being able to commit the current 
> transaction in the
> snapshot creation ioctl. So this made it possibe to insert the hole 
> file extent
> item in the source subvolume (which represents the region added by 
> the truncate)
> right before the transaction commit from the snapshot creation ioctl.
> 
> Btrfs' fsck tool complains about such cases with a message like the 
> following:
> 
>     "root 331 inode 257 errors 100, file extent discount"
> 
> From a user perspective, the expectation when a snapshot is created 
> while those
> file operations are being performed is that the snapshot will have a 
> file that
> either:
> 
> 1) is empty
> 2) only the first write was captured
> 3) only the 2 writes were captured
> 4) both writes and the truncation were captured
> 
> But never capture a state where only the first write and the 
> truncation were
> captured (since the second write was performed before the truncation).
> 
> A test case for xfstests follows.
> 
> Signed-off-by: Filipe Manana <fdmanana@suse.com>
> ---
> 
> V2: Use different approach to solve the problem. Don't start and wait 
> for all
>     dellaloc to finish after every expanding truncate, instead add an 
> additional
>     flush at transaction commit time if we're doing a transaction 
> commit that
>     creates snapshots.
> 
> V3: Removed useless test condition in 
> +wait_pending_snapshot_roots_delalloc().
> 
> V4: Use another approach that doesn't imply starting delalloc work 
> and wait
>     for it to finish at transaction commit time.

I like this one better ;)  Taking it for a spin here.

-chris


