Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sentry-two.sandia.gov ([132.175.109.14]:46980 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab2LKQdd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Dec 2012 11:33:33 -0500
Message-ID: <50C7604B.7070203@sandia.gov>
Date: Tue, 11 Dec 2012 09:33:15 -0700
From: "Jim Schutt" <jaschut@sandia.gov>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
Subject: Re: 3.7.0-rc8 btrfs locking issue
References: <50BF7129.90602@sandia.gov>
 <20121209140442.GA14309@liubo.jp.oracle.com>
In-Reply-To: <20121209140442.GA14309@liubo.jp.oracle.com>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/2012 07:04 AM, Liu Bo wrote:
> On Wed, Dec 05, 2012 at 09:07:05AM -0700, Jim Schutt wrote:
>> > Hi,
>> > 
>> > I'm hitting a btrfs locking issue with 3.7.0-rc8.
>> > 
>> > The btrfs filesystem in question is backing a Ceph OSD
>> > under a heavy write load from many cephfs clients.
>> > 
>> > I reported this issue a while ago:
>> >   http://www.spinics.net/lists/linux-btrfs/msg19370.html
>> > when I was testing what I thought might be part of the
>> > 3.7 btrfs patch queue, using Josef Bacik's btrfs-next tree.
>> > 
>> > I spent some time attempting to bisect the btrfs patch queue
>> > just before it was merged for 3.7, but got nowhere due to
>> > false negatives.
>> > 
>> > I've just been able to get back to testing 3.7-rc, and found
>> > that I can still trigger the issue.
> Hi Jim,
> 
> Could you please apply the following patch to test if it works?

Hi,

So far, with your patch applied I've been unable to reproduce
the recursive deadlock.  Thanks a lot for this patch!
This issue has been troubling me for a while.

I've been trying to learn more about btrfs internals -
if you have the time to answer a couple questions about
your patch, I'd really appreciate it.

> 
> (It's against 3.7-rc8.)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 3d3e2c1..100289b 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -3346,7 +3346,8 @@ u64 btrfs_get_alloc_profile(struct btrfs_root
> *root, int data)
>  
>  	if (data)
>  		flags = BTRFS_BLOCK_GROUP_DATA;
> -	else if (root == root->fs_info->chunk_root)
> +	else if (root == root->fs_info->chunk_root ||
> +		 root == root->fs_info->dev_root)
>  		flags = BTRFS_BLOCK_GROUP_SYSTEM;
>  	else
>  		flags = BTRFS_BLOCK_GROUP_METADATA;
> @@ -3535,6 +3536,7 @@ static u64 get_system_chunk_thresh(struct
> btrfs_root *root, u64 type)
>  		num_dev = 1;	/* DUP or single */
>  
>  	/* metadata for updaing devices and chunk tree */
> +	num_dev = num_dev << 1

AFAICS this is doubling the size of the reserve, which
reduces the chance of a recursive do_chunk_alloc(), right?

>  	return btrfs_calc_trans_metadata_size(root, num_dev + 1);

btrfs_calc_trans_metadata_size(root, num_items) multiplies its
num_items argument by another factor of three - do you know if
there is there some rationale behind that number, or is it
perhaps also an empirically determined factor?

What I'm wondering about is that if the size of the reserve is
empirically determined, will it need to be increased again
later when machines are more capable, and can handle a higher
load?

Do you think it's feasible to modify the locking for
do_chunk_alloc to allow it to recurse without deadlock?

Thanks -- Jim


>  }
>  
> @@ -4351,7 +4353,7 @@ static void init_global_block_rsv(struct
> btrfs_fs_info *fs_info)
>  
>  	fs_info->extent_root->block_rsv = &fs_info->global_block_rsv;
>  	fs_info->csum_root->block_rsv = &fs_info->global_block_rsv;
> -	fs_info->dev_root->block_rsv = &fs_info->global_block_rsv;
> +	fs_info->dev_root->block_rsv = &fs_info->chunk_block_rsv;
>  	fs_info->tree_root->block_rsv = &fs_info->global_block_rsv;
>  	fs_info->chunk_root->block_rsv = &fs_info->chunk_block_rsv;
>  
> 
> thanks,
> liubo
> 
> 


