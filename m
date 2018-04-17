Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:40544 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751927AbeDQJDr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Apr 2018 05:03:47 -0400
Subject: Re: [PATCH] btrfs: Do super block verification before writing it to
 disk
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180417014719.3799-1-wqu@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <1be75939-0ae0-9485-fe27-f3f5a92358c9@oracle.com>
Date: Tue, 17 Apr 2018 17:05:47 +0800
MIME-Version: 1.0
In-Reply-To: <20180417014719.3799-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> v3:
>    Update commit message to show the corruption in details.
>    Modify the kernel error message to show corruption is detected before
>    transaction commitment.
  Nice. Thanks. more below.

> @@ -3310,6 +3311,27 @@ static int write_dev_supers(struct btrfs_device *device,
>   
>   		btrfs_set_super_bytenr(sb, bytenr);
>   
> +		/* check the validation of the primary sb before writing */
> +		if (i == 0) {
> +			ret = btrfs_check_super_valid(device->fs_info, sb);
> +			if (ret) {
> +				btrfs_err(device->fs_info,
> +"superblock corruption detected before transaction commitment for device %llu",
> +					  device->devid);
> +				return -EUCLEAN;
> +			}

  Why not move this entire check further below, after we have the ready
  crc and use btrfs_check_super_csum(), instead of
  btrfs_check_super_valid()? so that we verify only what is known to be
  corrupted that is ..

btrfs_super_block {
::
         __le64 incompat_flags;
         __le16 csum_type;
::
}

  And also can you dump contents of incompat_flags and csum_type at both
    fs_info->super_copy
  and
    fs_info->super_for_commit

  Because at each commit transaction we

btrfs_commit_transaction()
{
   ::
         memcpy(fs_info->super_for_commit, fs_info->super_copy,
                sizeof(*fs_info->super_copy));
   ::
         ret = write_all_supers(fs_info, 0);

}

  And also the sync log can write the

btrfs_sync_log()
{
::
         ret = write_all_supers(fs_info, 1);


  Finally locks between these two threads needs a review as well.

Thanks, Anand
