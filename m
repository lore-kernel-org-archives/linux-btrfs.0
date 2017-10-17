Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39817 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752477AbdJQNfu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 09:35:50 -0400
Subject: Re: [PATCH] btrfs: Fix bug for misused dev_t when lookup in dev state
 hash table.
To: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org, hch@lst.de
References: <1508240087-36513-1-git-send-email-gujx@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <8db5f416-920d-bc72-d206-e879d359f4d9@suse.com>
Date: Tue, 17 Oct 2017 16:35:48 +0300
MIME-Version: 1.0
In-Reply-To: <1508240087-36513-1-git-send-email-gujx@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 17.10.2017 14:34, Gu Jinxiang wrote:
> From: Gu JinXiang <gujx@cn.fujitsu.com>
> 
> Fix bug of commit 74d46992e0d9
> ("block: replace bi_bdev with a gendisk pointer and partitions index").
> 
> In this modify, use bio_dev(bio) to find dev state in function
> __btrfsic_submit_bio. But when dev_state added to hashtable, it is using
> dev_t of block_device.

This is rather incomprehensible. So bio_dev(bio) actually returns the
dev_t of the device to which this bio is submitted and the same dev_t
should be used when btrfsic_dev_state_hashtable_add is called? What am I
missing in here?


> 
> Reproduce of this bug:
> Use MOUNT_OPTIONS="-o check_int" when run btrfs/001 in xfstest.
> Then there will be WARNING like below.
> WARNING:
> btrfs: attempt to write superblock which references block M @29523968 (sda7     /1111654400/2) which is never written!
> 
> Signed-off-by: Gu JinXiang <gujx@cn.fujitsu.com>
> ---
>  fs/btrfs/check-integrity.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
> index fb07e3c22b9a..02f9eb83173f 100644
> --- a/fs/btrfs/check-integrity.c
> +++ b/fs/btrfs/check-integrity.c
> @@ -2803,7 +2803,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
>  	mutex_lock(&btrfsic_mutex);
>  	/* since btrfsic_submit_bio() is also called before
>  	 * btrfsic_mount(), this might return NULL */
> -	dev_state = btrfsic_dev_state_lookup(bio_dev(bio));
> +	dev_state = btrfsic_dev_state_lookup(bio_dev(bio) + bio->bi_partno);

So this function looks up in btrfsic_dev_state_hashtable. And stuff in
this hashtable ias added via btrfsic_dev_state_hashtable_add function
which seems to be only using the dev_t (after your other patch is applied):

static void btrfsic_dev_state_hashtable_add(

                struct btrfsic_dev_state *ds,

                struct btrfsic_dev_state_hashtable *h)

{

        const unsigned int hashval =

            (((unsigned int)((uintptr_t)ds->bdev->bd_dev)) &

             (BTRFSIC_DEV2STATE_HASHTABLE_SIZE - 1));



        list_add(&ds->collision_resolving_node, h->table + hashval);

}


So how come your change is correct since you are passing the dev_t +
partition number?

>  	if (NULL != dev_state &&
>  	    (bio_op(bio) == REQ_OP_WRITE) && bio_has_data(bio)) {
>  		unsigned int i = 0;
> 
