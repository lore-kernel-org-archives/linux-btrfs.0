Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:55700 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbeCTWV5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 18:21:57 -0400
Subject: Re: [PATCH 2/3] btrfs: return required error from
 btrfs_check_super_csum
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180320095310.6355-1-anand.jain@oracle.com>
 <20180320095310.6355-3-anand.jain@oracle.com>
 <fc5778d9-1674-395b-c010-571d96b0228a@suse.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <0b136c95-50cd-12e3-f312-6e5a3528e3bf@oracle.com>
Date: Wed, 21 Mar 2018 06:23:10 +0800
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

  yeah, I struggled with it before.
  Strangely there isn't an error code for the csum error
  when csum being widely used in the computer systems.

  Our closest are:

#define	EFAULT		14	/* Bad address */
#define	EUCLEAN		135	/* Structure needs cleaning */

  Will use the suggested EUCLEAN.

Thanks, Anand
