From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs: fix dip leak
Date: Thu, 10 Mar 2011 10:54:26 +0800
Message-ID: <4D783D62.2010709@cn.fujitsu.com>
References: <AANLkTikDN-v4C4rt-uTFQ35uoaoJ_9LRHSmAQUN4+uVD@mail.gmail.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Ito <t-itoh@jp.fujitsu.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikDN-v4C4rt-uTFQ35uoaoJ_9LRHSmAQUN4+uVD@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 	thu, 10 Mar 2011 00:46:42 +0800, Daniel J Blueman wrote:
> 2010/11/22 Miao Xie <miaox@cn.fujitsu.com>:
>> bio_endio() will free dip and dip->csums, so dip and dip->csums twice will
>> be freed twice. Fix it.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/inode.c |    9 +++------
>>  1 files changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index 558cac2..5a5edc7 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -5731,7 +5731,7 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
>>
>>        ret = btrfs_bio_wq_end_io(root->fs_info, bio, 0);
>>        if (ret)
>> -               goto out_err;
>> +               goto free_ordered;
>>
>>        if (write && !skip_sum) {
>>                ret = btrfs_wq_submit_bio(BTRFS_I(inode)->root->fs_info,
>> @@ -5740,7 +5740,7 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
>>                                   __btrfs_submit_bio_start_direct_io,
>>                                   __btrfs_submit_bio_done);
>>                if (ret)
>> -                       goto out_err;
>> +                       goto free_ordered;
>>                return;
>>        } else if (!skip_sum)
>>                btrfs_lookup_bio_sums_dio(root, inode, bio,
>> @@ -5748,11 +5748,8 @@ static void btrfs_submit_direct(int rw, struct bio *bio, struct inode *inode,
>>
>>        ret = btrfs_map_bio(root, rw, bio, 0, 1);
>>        if (ret)
>> -               goto out_err;
>> +               goto free_ordered;
>>        return;
>> -out_err:
>> -       kfree(dip->csums);
>> -       kfree(dip);
>>  free_ordered:
>>        /*
>>         * If this is a write, we need to clean up the reserved space and kill
> 
> The previous patch is broken and leaks dip when dip->csums allocation
> fails; bio->bi_end_io isn't set at the point where the free_ordered
> branch is consequently taken, thus bio_endio doesn't call the function
> which would free it in the normal case. Fix.
> 
> Signed-off-by: Daniel J Blueman <daniel.blueman@gmail.com>
> 
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 0efdb65..53f4c8e 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -6056,6 +6056,7 @@ static void btrfs_submit_direct(int rw, struct
> bio *bio, struct inode *inode,
>  	if (!skip_sum) {
>  		dip->csums = kmalloc(sizeof(u32) * bio->bi_vcnt, GFP_NOFS);
>  		if (!dip->csums) {
> +			kfree(dip);
>  			ret = -ENOMEM;
>  			goto free_ordered;
>  		}

Acked-by: Miao Xie <miaox@cn.fujitsu.com>

BTW: This bug had existed before applying my patch, so you should cc this mail
to the people who brought it, I think. He can do final check.
