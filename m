Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:55080 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbeCUCfu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 22:35:50 -0400
Subject: Re: [PATCH 2/3] btrfs: return required error from
 btrfs_check_super_csum
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180320095310.6355-1-anand.jain@oracle.com>
 <20180320095310.6355-3-anand.jain@oracle.com>
 <fc5778d9-1674-395b-c010-571d96b0228a@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <c8b924ff-e864-d4dd-6482-f0d62e8e6039@oracle.com>
Date: Wed, 21 Mar 2018 10:37:37 +0800
MIME-Version: 1.0
In-Reply-To: <fc5778d9-1674-395b-c010-571d96b0228a@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> @@ -418,8 +418,10 @@ static int btrfs_check_super_csum(struct btrfs_fs_info *fs_info,
>>   			      crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
>>   	btrfs_csum_final(crc, result);
>>   
>> -	if (memcmp(raw_disk_sb, result, sizeof(result)))
>> -		return 1;
>> +	if (memcmp(raw_disk_sb, result, sizeof(result))) {
>> +		btrfs_err(fs_info, "superblock checksum mismatch");
>> +		return -EINVAL;
> 
> Don't we want EUCLEAN here, since an error in the checksum indicates
> corruption?

  With the v2 patch sentout here is the error str that is seen on the cli.

   mount: mount /dev/sdb on /btrfs failed: Structure needs cleaning

I am ok. However would have much better if it says checksum error.

Do you/anyone suggest I should update the errno.h?

Thanks, Anand
