Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59926 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3EARhd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 13:37:33 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9006A7C0691
	for <linux-btrfs@vger.kernel.org>; Wed,  1 May 2013 11:37:33 -0600 (MDT)
Date: Wed, 1 May 2013 13:37:29 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH v3 0/2] Online data deduplication
Message-ID: <20130501173729.GJ2580@localhost.localdomain>
References: <1367425659-10803-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1367425659-10803-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 01, 2013 at 10:27:36AM -0600, Liu Bo wrote:
> NOTE: This leads to a FORMAT CHANGE, DO NOT use it on real data!
> 
> Data deduplication is a specialized data compression technique for eliminating
> duplicate copies of repeating data.[1]
> 
> This patch set is also related to "Content based storage" in project ideas[2].
> 
> PATCH 1 is a hang fix when deduplication is on, but it's also useful with no
> deduplication in practice use.
> 
> For more implementation details, please refer to PATCH 2.
> 
> TODO:
> * a bit-to-bit comparison callback.
> 
> All comments are welcome!
> 
> [1]: http://en.wikipedia.org/wiki/Data_deduplication
> [2]: https://btrfs.wiki.kernel.org/index.php/Project_ideas#Content_based_storage
> 
> 
> v3:
>   * add COMPRESS support
>   * add a real ioctl to enable dedup feature
>   * change the maximum allowed dedup blocksize to 128k because of compressed
>     range limit
> v2:
>   * To avoid enlarging the file extent item's size, add another index key used
>     for freeing dedup extent.
>   * Freeing dedup extent is now like how we delete checksum.
>   * Add support for alternative deduplicatin blocksize larger than PAGESIZE.
>   * Add a mount option to set deduplication blocksize.
>   * Add support for those writes that are smaller than deduplication blocksize.
> 
> =====================
> HOW To turn deduplication on:
> 
> There are 2 steps you need to do before using it,
> 1) mount /dev/disk /mnt_of_your_btrfs -o dedup
>    (or mount /dev/disk /mnt_of_your_btrfs -o dedup_bs=128K)
> 2) btrfs filesystem dedup-register /mnt_of_your_btrfs
> =====================
> 

You didn't use an INCOPMAT option for this so you need to deal with a user
mounting the file system with an older kernel or even forgetting to use mount -o
dedup.  Otherwise your dedup tree will become out of date and you could corrupt
peoples data.  So if you aren't going to use an INCOMPAT flag you need to at
least use a COMPAT flag so we know the option has been used at all and then you
need to have a mechanism to know if you need to invalidate the hash tree.

Users are also going to make the mistake of thinking dedup will make their
workload awesome, and when it doesn't they need a way to turn it off.  If you do
an INCOMPAT option then you need to have a way to delete the hash tree and unset
the INCOMPAT flag.  If you do the COMPAT route then you get this for free since
the user just needs to stop using -o dedup, but you'll probably also want to
provide a mechanism to delete the tree to free up space.  Thanks,

Josef
