Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54175 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752415AbbBQO4C (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Feb 2015 09:56:02 -0500
Date: Tue, 17 Feb 2015 09:55:53 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v3] Btrfs: fix BUG_ON in btrfs_orphan_add() when delete
 unused block group
To: Forrest Liu <forrestl@synology.com>
CC: <linux-btrfs@vger.kernel.org>
Message-ID: <1424184953.18101.1@mail.thefacebook.com>
In-Reply-To: <1423635852-23258-1-git-send-email-forrestl@synology.com>
References: <1423635852-23258-1-git-send-email-forrestl@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 11, 2015 at 1:24 AM, Forrest Liu <forrestl@synology.com> 
wrote:
> Removing large amount of block group in a transaction may encounters
> BUG_ON() in btrfs_orphan_add(). That is because 
> btrfs_orphan_reserve_metadata()
> will grab metadata reservation from transaction handle, and
> btrfs_delete_unused_bgs() didn't reserve metadata for trnasaction 
> handle when
> delete unused block group.
> 
> The problem can be reproduce by following script
> 
>     mntpath=/btrfs
>     loopdev=/dev/loop0
>     filepath=/home/forrest/image
> 
>     umount $mntpath
>     losetup -d $loopdev
>     truncate --size 1000g $filepath
>     losetup $loopdev $filepath
>     mkfs.btrfs -f $loopdev
>     mount $loopdev $mntpath
> 
>     for j in `seq 1 1 1000`; do
>         fallocate -l 1g $mntpath/$j
>     done
>     # wait cleaner thread remove unused block group
>     sleep 300
> 
> The call trace that results from the BUG_ON() is:
> 
> [  613.093084] ------------[ cut here ]------------
> [  613.097928] kernel BUG at fs/btrfs/inode.c:3142!

This should fix a hard to trigger bug we've seen in production here.  I 
was on a different (wrong) track for explaining it, so your timing is 
excellent.

Thanks.

-chris



