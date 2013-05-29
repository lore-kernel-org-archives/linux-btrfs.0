Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:25859 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933784Ab3E2Ic5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 May 2013 04:32:57 -0400
Message-ID: <51A5BD76.40504@cn.fujitsu.com>
Date: Wed, 29 May 2013 16:33:58 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: Kyle Gates <kylegates@hotmail.com>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: nocow 'C' flag ignored after balance
References: <CADn-QaPQ0aH1rb3rG3bE87Ka3XaLzHHeA6nwNLbQJsbB_BiXkw@mail.gmail.com> <h1rh5a-1lg.ln1@hurikhan.ath.cx> <CADn-QaNEdWiyKaniOhzAmaGb6p=PuZ4=FxPPPiVLZZJ3zB7xpQ@mail.gmail.com> <BAY172-DS142AB5E40D200CC3946388B0A40@phx.gbl> <20130510051500.GB5615@liubo.jp.oracle.com> <BAY172-DS77BDBEADA4D3971B47F29B0A50@phx.gbl> <BAY172-DS3707AF83BC83C3B48502DB0A30@phx.gbl> <20130517070443.GN20202@liubo.jp.oracle.com> <BAY172-DS16C3FC74BB7793F893E2B0B0970@phx.gbl> <20130529015510.GA6571@liubo>
In-Reply-To: <20130529015510.GA6571@liubo>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On wed, 29 May 2013 10:55:11 +0900, Liu Bo wrote:
> On Tue, May 28, 2013 at 09:22:11AM -0500, Kyle Gates wrote:
>>> From: Liu Bo <bo.li.liu@oracle.com>
>>>
>>> Subject: [PATCH] Btrfs: fix broken nocow after a normal balance
>>>
>> [...]
>>
>> Sorry for the long wait in replying.
>> This patch was unsuccessful in fixing the problem (on my 3.8 Ubuntu
>> Raring kernel). I can probably try again on a newer version if you
>> think it will help.
>> This was my first kernel compile so I patched by hand and waited (10
>> hours on my old 32 bit single core machine).
>>
>> I did move some of the files off and back on to the filesystem to
>> start fresh and compare but all seem to exhibit the same behavior
>> after a balance.
>>
> 
> Thanks for testing the patch although it didn't help you.
> Actually I tested it to be sure that it fixed the problems in my reproducer.
> 
> So anyway can you please apply this debug patch in order to nail it down?

Your patch can not fix the above problem is because we may update ->last_snapshot
after we relocate the file data extent.

For example, there are two block groups which will be relocated, One is data block
group, the other is metadata block group. Then we relocate the data block group firstly,
and set the new generation for the file data extent item/the relative extent item and
set (new_generation - 1) for ->last_snapshot. After the relocation of this block group,
we will end the transaction and drop the relocation tree. If we end the space balance now,
we won't break the nocow rule because ->last_snapshot is less than the generation of the file
data extent item/the relative extent item. But there is still one block group which will be
relocated, when relocating the second block group, we will also start a new transaction,
and update ->last_snapshot if need. So, ->last_snapshot is greater than the generation of the file
data extent item we set before. And the nocow rule is broken.

Back to this above problem. I don't think it is a serious problem, we only do COW once after
the relocation, then we will still honour the nocow rule. The behaviour is similar to snapshot.
So maybe it needn't be fixed.

If we must fix this problem, I think the only way is that get the generation at the beginning
of the space balance, and then set it to ->last_snapshot if ->last_snapshot is less than it,
don't use (current_generation - 1) to update the ->last_snapshot. Besides that, don't forget
to store the generation into btrfs_balance_item, or the problem will happen after we resume the
balance.

Thanks
Miao

> 
> thanks,
> liubo
> 
>  
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index df472ab..c12a11c 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -2857,8 +2857,12 @@ static noinline int check_committed_ref(struct btrfs_trans_handle *trans,
>  		goto out;
>  
>  	if (btrfs_extent_generation(leaf, ei) <=
> -	    btrfs_root_last_snapshot(&root->root_item))
> +	    btrfs_root_last_snapshot(&root->root_item)) {
> +		printk("extent gen %llu last_snap %llu\n",
> +			btrfs_extent_generation(leaf, ei),
> +			btrfs_root_last_snapshot(&root->root_item));
>  		goto out;
> +	}
>  
>  	iref = (struct btrfs_extent_inline_ref *)(ei + 1);
>  	if (btrfs_extent_inline_ref_type(leaf, iref) !=
> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 23c596c..8cad6ee 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -1317,16 +1317,24 @@ next_slot:
>  				goto out_check;
>  			if (btrfs_file_extent_compression(leaf, fi) ||
>  			    btrfs_file_extent_encryption(leaf, fi) ||
> -			    btrfs_file_extent_other_encoding(leaf, fi))
> +			    btrfs_file_extent_other_encoding(leaf, fi)) {
> +				printk("special encoding\n");
>  				goto out_check;
> -			if (extent_type == BTRFS_FILE_EXTENT_REG && !force)
> +			}
> +			if (extent_type == BTRFS_FILE_EXTENT_REG && !force) {
> +				printk("BTRFS_FILE_EXTENT_REF\n");
>  				goto out_check;
> -			if (btrfs_extent_readonly(root, disk_bytenr))
> +			}
> +			if (btrfs_extent_readonly(root, disk_bytenr)) {
> +				printk("ro\n");
>  				goto out_check;
> +			}
>  			if (btrfs_cross_ref_exist(trans, root, ino,
>  						  found_key.offset -
> -						  extent_offset, disk_bytenr))
> +						  extent_offset, disk_bytenr)) {
> +				printk("cross ref\n");
>  				goto out_check;
> +			}
>  			disk_bytenr += extent_offset;
>  			disk_bytenr += cur_offset - found_key.offset;
>  			num_bytes = min(end + 1, extent_end) - cur_offset;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

