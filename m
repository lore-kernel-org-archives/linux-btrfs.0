Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46839 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751561AbdJ3NSE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 30 Oct 2017 09:18:04 -0400
Date: Mon, 30 Oct 2017 14:16:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Gu Jinxiang <gujx@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH v2] btrfs: Fix bug for misused dev_t when lookup in dev
 state hash table.
Message-ID: <20171030131613.GS3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1508377767-61647-1-git-send-email-gujx@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1508377767-61647-1-git-send-email-gujx@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 19, 2017 at 09:49:27AM +0800, Gu Jinxiang wrote:
> From: Gu JinXiang <gujx@cn.fujitsu.com>
> 
> Fix bug of commit 74d46992e0d9
> ("block: replace bi_bdev with a gendisk pointer and partitions index").
> 
> In this modify, use bio_dev(bio) to find dev state in function
> __btrfsic_submit_bio. But when dev_state added to hashtable, it is using
> dev_t of block_device.
> 
> bio_dev(bio) returns a dev_t of part0 which is different from dev_t in
> block_device(bd_dev). bd_dev in block_device represents the exact
> partition.
> block_device.bd_dev = 
> 	bio->bi_partno (same as block_device.bd_partno) + bio_dev(bio).
> 
> When add a dev_state into hashtable it is using the exact partition's dev_t.
> So when lookup it, it should also use the exact partition's dev_t.
> 
> Reproduce of this bug:
> Use MOUNT_OPTIONS="-o check_int" when run btrfs/001 in xfstest.
> Then there will be WARNING like below.
> WARNING:
> btrfs: attempt to write superblock which references block M @29523968 (sda7     /1111654400/2) which is never written!
> 
> changelog:
> v1->v2: Add explanation that bio_dev(bio) is different with block_device(bd_dev).
> 
> Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>

Reviewed-by: David Sterba <dsterba@suse.com>
