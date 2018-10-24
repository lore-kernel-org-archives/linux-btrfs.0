Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2630DC67863
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 04:31:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDC3A20652
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 04:31:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="S9QTc9OB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDC3A20652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726577AbeJXM55 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 08:57:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43120 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbeJXM55 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 08:57:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w9O4TG4K152682;
        Wed, 24 Oct 2018 04:31:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=qI/jh/hfkqg/l8zugtSUwfi6rr+7eZI/hQYzzbMeaXs=;
 b=S9QTc9OB4qXFWmdJeD4fxARPJMN5+vDQTZcyykcT750cQQj/0zdAqAED+JEn6VYtJ1GO
 ap5ndss3B0KqLQOZbIu2JZAcnKaKoWSOz9Lv3tMALJKy581809HSv1onTvF7i0ZmF14C
 DGT84pG2UBkKAqjMqoqy1ikyXye8x+D8yNAaRWs2JMIFLpdsVKhAXUXmHTMZy8RRmo5E
 AoW/rS5p7Q78yiJliWRvxRQTlW3xOWg2dJC5kwDXhYsfe7BbOwIdwsa87bq+vtVRWJ/h
 Fqmd3pUl8o9nigpBeYsqugL6aUdwzNymJU2xKsyT6/pIlMauMsSJmibzmxXR69r9mfdE Ew== 
Received: from aserv0022.oracle.com (aserv0022.oracle.com [141.146.126.234])
        by userp2120.oracle.com with ESMTP id 2n7w0qs0ck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Oct 2018 04:31:31 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w9O4VP4S008112
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Oct 2018 04:31:25 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w9O4VPBd006673;
        Wed, 24 Oct 2018 04:31:25 GMT
Received: from [10.190.205.83] (/192.188.170.107)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Oct 2018 21:31:25 -0700
Subject: Re: [PATCH] btrfs: introduce feature to forget a btrfs device
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <1539317191-9265-1-git-send-email-anand.jain@oracle.com>
 <1539317191-9265-2-git-send-email-anand.jain@oracle.com>
 <286b1a54-1cd4-2e70-781a-a6ea4255572d@suse.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <e9fd58a1-ba7c-6c7f-bb19-0ae8f3dcf12a@oracle.com>
Date:   Wed, 24 Oct 2018 12:31:17 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <286b1a54-1cd4-2e70-781a-a6ea4255572d@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9055 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1807170000 definitions=main-1810240039
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 10/12/2018 04:48 PM, Nikolay Borisov wrote:
> 
> 
> On 12.10.2018 07:06, Anand Jain wrote:
>> Support for a new command 'btrfs dev forget [dev]' is proposed here
>> to undo the effects of 'btrfs dev scan [dev]'. For this purpose
>> this patch proposes to use ioctl #5 as it was empty.
>> 	IOW(BTRFS_IOCTL_MAGIC, 5, ..)
>> This patch adds new ioctl BTRFS_IOC_FORGET_DEV which can be sent from
>> the /dev/btrfs-control to forget one or all devices, (devices which are
>> not mounted) from the btrfs kernel.
>>
>> The argument it takes is struct btrfs_ioctl_vol_args, and ::name can be
>> set to specify the device path. And all unmounted devices can be removed
>> from the kernel if no device path is provided.
>>
>> Again, the devices are removed only if the relevant fsid aren't mounted.
>>
>> This new cli can provide..
>>   . Release of unwanted btrfs_fs_devices and btrfs_devices memory if the
>>     device is not going to be mounted.
>>   . Ability to mount the device in degraded mode when one of the other
>>     device is corrupted like in split brain raid1.
>>   . Running test cases which requires btrfs.ko-reload if the rootfs
>>     is btrfs.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>   fs/btrfs/super.c           | 3 +++
>>   fs/btrfs/volumes.c         | 9 +++++++++
>>   fs/btrfs/volumes.h         | 1 +
>>   include/uapi/linux/btrfs.h | 2 ++
>>   4 files changed, 15 insertions(+)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 6601c9aa5e35..f14610ef1c66 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -2244,6 +2244,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>>   		ret = PTR_ERR_OR_ZERO(device);
>>   		mutex_unlock(&uuid_mutex);
>>   		break;
>> +	case BTRFS_IOC_FORGET_DEV:
>> +		ret = btrfs_forget_devices(vol->name);
>> +		break;
>>   	case BTRFS_IOC_DEVICES_READY:
>>   		mutex_lock(&uuid_mutex);
>>   		device = btrfs_scan_one_device(vol->name, FMODE_READ,
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index f4405e430da6..e2ab203d9c1d 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1208,6 +1208,15 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>>   	return 0;
>>   }
>>   
>> +int btrfs_forget_devices(const char *path)
>> +{
>> +	mutex_lock(&uuid_mutex);
>> +	btrfs_free_stale_devices(strlen(path) ? path:NULL, NULL);
> 
> Checking the len of path is redundant since userspace will pass a zeroed
> struct which will be NULL in any case. Additionally in
> btrfs_free_stalce_devices there is existing check whether path is set or
> not.

That won't work. btrfs_free_stalce_devices() expects the pointer to be 
NULL. User space has zeroed the name which is char array and its pointer 
is not NULL.

Thanks, Anand

>> +	mutex_unlock(&uuid_mutex);
>> +
>> +	return 0;
>> +}
>> +
>>   /*
>>    * Look for a btrfs signature on a device. This may be called out of the mount path
>>    * and we are not allowed to call set_blocksize during the scan. The superblock
>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>> index 23e9285d88de..394079d5d08d 100644
>> --- a/fs/btrfs/volumes.h
>> +++ b/fs/btrfs/volumes.h
>> @@ -406,6 +406,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>>   		       fmode_t flags, void *holder);
>>   struct btrfs_device *btrfs_scan_one_device(const char *path,
>>   					   fmode_t flags, void *holder);
>> +int btrfs_forget_devices(const char *path);
>>   int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>>   void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
>>   void btrfs_assign_next_active_device(struct btrfs_device *device,
>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>> index 5ca1d21fc4a7..b1be7f828cb4 100644
>> --- a/include/uapi/linux/btrfs.h
>> +++ b/include/uapi/linux/btrfs.h
>> @@ -836,6 +836,8 @@ enum btrfs_err_code {
>>   				   struct btrfs_ioctl_vol_args)
>>   #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>>   				   struct btrfs_ioctl_vol_args)
>> +#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
>> +				   struct btrfs_ioctl_vol_args)
>>   /* trans start and trans end are dangerous, and only for
>>    * use by applications that know how to avoid the
>>    * resulting deadlocks
>>
