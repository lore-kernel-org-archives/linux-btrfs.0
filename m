Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:50640 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbeCUC72 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Mar 2018 22:59:28 -0400
Subject: Re: [PATCH 2/3] btrfs: return required error from
 btrfs_check_super_csum
From: Anand Jain <anand.jain@oracle.com>
To: Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20180320095310.6355-1-anand.jain@oracle.com>
 <20180320095310.6355-3-anand.jain@oracle.com>
 <fc5778d9-1674-395b-c010-571d96b0228a@suse.com>
 <c8b924ff-e864-d4dd-6482-f0d62e8e6039@oracle.com>
Message-ID: <59e240bf-20d8-4b4a-dbea-20fa269f77f7@oracle.com>
Date: Wed, 21 Mar 2018 11:01:15 +0800
MIME-Version: 1.0
In-Reply-To: <c8b924ff-e864-d4dd-6482-f0d62e8e6039@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/21/2018 10:37 AM, Anand Jain wrote:
> 
> 
>>> @@ -418,8 +418,10 @@ static int btrfs_check_super_csum(struct 
>>> btrfs_fs_info *fs_info,
>>>                     crc, BTRFS_SUPER_INFO_SIZE - BTRFS_CSUM_SIZE);
>>>       btrfs_csum_final(crc, result);
>>> -    if (memcmp(raw_disk_sb, result, sizeof(result)))
>>> -        return 1;
>>> +    if (memcmp(raw_disk_sb, result, sizeof(result))) {
>>> +        btrfs_err(fs_info, "superblock checksum mismatch");
>>> +        return -EINVAL;
>>
>> Don't we want EUCLEAN here, since an error in the checksum indicates
>> corruption?
> 
>   With the v2 patch sentout here is the error str that is seen on the cli.
> 
>    mount: mount /dev/sdb on /btrfs failed: Structure needs cleaning

  And since we return -EINVAL for the error csum_type not found we get..

  mount: wrong fs type, bad option, bad superblock on /dev/sdb,
        missing codepage or helper program, or other error

        In some cases useful info is found in syslog - try
        dmesg | tail or so.

  Looks like mount syscall interprets -EINVAL error.

> I am ok. However would have much better if it says checksum error.

  Also we may need an error code to say incompatible disk format/version.

> Do you/anyone suggest I should update the errno.h?

Thanks, Anand

> 
> Thanks, Anand
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
