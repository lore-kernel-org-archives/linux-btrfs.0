Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:40516 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab3JOSyu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 14:54:50 -0400
Message-ID: <525D8F79.80708@jan-o-sch.net>
Date: Tue, 15 Oct 2013 20:54:49 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: Don't allocate inode that is already in use
References: <71e7d4e789d0d2d0cc9f1138cb4411a1d0ec5125.1381860425.git.sbehrens@giantdisaster.de>
In-Reply-To: <71e7d4e789d0d2d0cc9f1138cb4411a1d0ec5125.1381860425.git.sbehrens@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, October 15, 2013 at 20:08 (+0200), Stefan Behrens wrote:
> Due to an off-by-one error, it is possible to reproduce a bug
> when the inode cache is used.
> 
> The same inode number is assigned twice, the second time this
> leads to an EEXIST in btrfs_insert_empty_items().
> 
> The issue can happen when a file is removed right after a subvolume
> is created and then a new inode number is created before the
> inodes in free_inode_pinned are processed.
> unlink() calls btrfs_return_ino() which calls start_caching() in this
> case which adds [highest_ino + 1, BTRFS_LAST_FREE_OBJECTID] by
> searching for the highest inode (which already cannot find the
> unlinked one anymore in btrfs_find_free_objectid()). So if this
> unlinked inode's number is equal to the highest_ino + 1 (or >= this value
> instead of > this value which was the off-by-one error), we mustn't add
> the inode number to free_ino_pinned (caching_thread() does it right).
> In this case we need to try directly to add the number to the inode_cache
> which will fail in this case.
> 
> When this inode number is allocated while it is still in free_ino_pinned,
> it is allocated and still added to the free inode cache when the
> pinned inodes are processed, thus one of the following inode number
> allocations will get an inode that is already in use and fail with EEXIST
> in btrfs_insert_empty_items().
> 
> One example which was created with the reproducer below:
> Create a snapshot, work in the newly created snapshot for the rest.
> In unlink(inode 34284) call btrfs_return_ino() which calls start_caching().
> start_caching() calls add_free_space [34284, 18446744073709517077].
> In btrfs_return_ino(), call start_caching pinned [34284, 1] which is wrong.
> mkdir() call btrfs_find_ino_for_alloc() which returns the number 34284.
> btrfs_unpin_free_ino calls add_free_space [34284, 1].
> mkdir() call btrfs_find_ino_for_alloc() which returns the number 34284.
> EEXIST when the new inode is inserted.
> 
> One possible reproducer is this one:
>  #!/bin/sh
>  # preparation
> TEST_DEV=/dev/sdc1
> TEST_MNT=/mnt
> umount ${TEST_MNT} 2>/dev/null || true
> mkfs.btrfs -f ${TEST_DEV}
> mount ${TEST_DEV} ${TEST_MNT} -o \
>  rw,relatime,compress=lzo,space_cache,inode_cache
> btrfs subv create ${TEST_MNT}/s1
> for i in `seq 34027`; do touch ${TEST_MNT}/s1/${i}; done
> btrfs subv snap ${TEST_MNT}/s1 ${TEST_MNT}/s2
> FILENAME=`find ${TEST_MNT}/s1/ -inum 4085 | sed 's|^.*/\([^/]*\)$|\1|'`
> rm ${TEST_MNT}/s2/$FILENAME
> touch ${TEST_MNT}/s2/$FILENAME
>  # the following steps can be repeated to reproduce the issue again and again
> [ -e ${TEST_MNT}/s3 ] && btrfs subv del ${TEST_MNT}/s3
> btrfs subv snap ${TEST_MNT}/s2 ${TEST_MNT}/s3
> rm ${TEST_MNT}/s3/$FILENAME
> touch ${TEST_MNT}/s3/$FILENAME
> ls -alFi ${TEST_MNT}/s?/$FILENAME
> touch ${TEST_MNT}/s3/_1 || logger FAILED
> ls -alFi ${TEST_MNT}/s?/_1
> touch ${TEST_MNT}/s3/_2 || logger FAILED
> ls -alFi ${TEST_MNT}/s?/_2
> touch ${TEST_MNT}/s3/__1 || logger FAILED
> ls -alFi ${TEST_MNT}/s?/__1
> touch ${TEST_MNT}/s3/__2 || logger FAILED
> ls -alFi ${TEST_MNT}/s?/__2
>  # if the above is not enough, add the following loop:
> for i in `seq 3 9`; do touch ${TEST_MNT}/s3/__${i} || logger FAILED; done
>  #for i in `seq 3 34027`; do touch ${TEST_MNT}/s3/__${i} || logger FAILED; done
>  # one of the touch(1) calls in s3 fail due to EEXIST because the inode is
>  # already in use that btrfs_find_ino_for_alloc() returns.

Probably a bit too obscure to turn this into  an xfstest? At least nobody
complained so far, and this reproducer takes me 1m57 to run, so nothing I want
in each xfstest cycle.

If we ever introduce a similar problem, this reproducer probably won't find it
(at least if it's really dependent on the exact number of files and the exact
inode number), unless we're effectively reversing this patch. So no real use for
a regression test in my opinion, I'm okay with just fixing it.

> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
> ---
>  fs/btrfs/inode-map.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/inode-map.c b/fs/btrfs/inode-map.c
> index 014de49..ec08004 100644
> --- a/fs/btrfs/inode-map.c
> +++ b/fs/btrfs/inode-map.c
> @@ -237,7 +237,7 @@ again:
>  		start_caching(root);
>  
>  		if (objectid <= root->cache_progress ||
> -		    objectid > root->highest_objectid)
> +		    objectid >= root->highest_objectid)
>  			__btrfs_add_free_space(ctl, objectid, 1);
>  		else
>  			__btrfs_add_free_space(pinned, objectid, 1);
> 

Reviewed-by: Jan Schmidt <list.btrfs@jan-o-sch.net>

... although this is not the most beautiful commit message I've ever seen ;-)

-Jan
