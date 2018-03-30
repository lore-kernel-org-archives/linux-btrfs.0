Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:57962 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752058AbeC3AQj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Mar 2018 20:16:39 -0400
Subject: Re: [PATCH v2 2/7] btrfs: return required error from
 btrfs_check_super_csum
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180329103705.13566-1-anand.jain@oracle.com>
 <20180329103705.13566-3-anand.jain@oracle.com>
 <362e2f2e-f3f1-6cb5-a7fd-90998a428e07@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ec6523b8-921d-e8ba-df7e-12af58d07051@oracle.com>
Date: Fri, 30 Mar 2018 08:11:42 +0800
MIME-Version: 1.0
In-Reply-To: <362e2f2e-f3f1-6cb5-a7fd-90998a428e07@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> @@ -2570,9 +2568,14 @@ int open_ctree(struct super_block *sb,
>>   	 * We want to check superblock checksum, the type is stored inside.
>>   	 * Pass the whole disk block of size BTRFS_SUPER_INFO_SIZE (4k).
>>   	 */
>> -	if (btrfs_check_super_csum(fs_info, bh->b_data)) {
>> -		btrfs_err(fs_info, "superblock checksum mismatch");
>> -		err = -EINVAL;
>> +	err = btrfs_check_super_csum(bh->b_data);
>> +	if (err) {
>> +		if (err == -EINVAL)
>> +			pr_err("BTRFS error (device %pg): unsupported checksum algorithm",
>> +				fs_devices->latest_bdev);
>> +		else
>> +			pr_err("BTRFS error (device %pg): superblock checksum mismatch",
>> +				fs_devices->latest_bdev);
> 
> nit: I think your initial version of specifically checking for EUCLEAN
> was better but I don't have strong preferences.

  Fixed this in v4. Also updated the changelog.

  Thanks for the review.

Anand
