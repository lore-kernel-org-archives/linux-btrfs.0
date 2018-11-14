Return-Path: <SRS0=6ez2=NZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFE37C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:35:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D198208E7
	for <linux-btrfs@archiver.kernel.org>; Wed, 14 Nov 2018 13:35:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="DvgUA1ti"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D198208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=oracle.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbeKNXiX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 14 Nov 2018 18:38:23 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49006 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726823AbeKNXiW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 14 Nov 2018 18:38:22 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id wAEDY3FC170944;
        Wed, 14 Nov 2018 13:35:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=3JtDtGgTptuBKW2DoUcXpfs0mHaa743jSSLB30ht8ZA=;
 b=DvgUA1tiq45UVYXlMZGBT3eOAhfsFUflBAJz/6vaOthBIKUW32E9IGSZCKn2coBbBju/
 s+XDEK2HYZCVyB4+ZH4HZBOmRDcLWiGAcxZFnLhL3EL9CVpW5GrPWeKwAgEUOiAO4bQJ
 DH/q1si3OfZudjAcloZGuskXJhhOBwf7tUQwKFyLkEhf01JmW4CY14O9s8hubEB+mQzS
 37BqM+tIKkzm/p5IW1WEXbKErr2Upd8jgrkyOGdmA4cmRvh/vk2KOn2O5CCPGuneAVRY
 mc47Cn6MjYI5PaNt9lAhOddq9rc8MKPUTXsnXRVsdd8fzHnLjaT5vL/iodLU7BTGAylj ow== 
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2nr7cs3eey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Nov 2018 13:35:03 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id wAEDZ3tv018981
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Nov 2018 13:35:03 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id wAEDZ2Jg011948;
        Wed, 14 Nov 2018 13:35:03 GMT
Received: from [192.168.0.120] (/202.156.138.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Nov 2018 05:35:02 -0800
Subject: Re: [PATCH] btrfs: introduce feature to forget a btrfs device
To:     fdmanana@gmail.com
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
References: <1542186768-22956-1-git-send-email-anand.jain@oracle.com>
 <1542186768-22956-2-git-send-email-anand.jain@oracle.com>
 <CAL3q7H5TuOHx+=-S+ieMBo7TKTUdHVjcjeo3u7SeicwfKnJp+w@mail.gmail.com>
 <CAL3q7H7UYwz8GKqQ2DVXhZOG19Vq67QTMZrrWg1=gA+FeBNhcg@mail.gmail.com>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <573f0660-33b3-892b-499a-43421c41067d@oracle.com>
Date:   Wed, 14 Nov 2018 21:35:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7UYwz8GKqQ2DVXhZOG19Vq67QTMZrrWg1=gA+FeBNhcg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9076 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1811140123
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 11/14/2018 07:28 PM, Filipe Manana wrote:
> On Wed, Nov 14, 2018 at 11:15 AM Filipe Manana <fdmanana@gmail.com> wrote:
>>
>> On Wed, Nov 14, 2018 at 9:14 AM Anand Jain <anand.jain@oracle.com> wrote:
>>>
>>> Support for a new command 'btrfs dev forget [dev]' is proposed here
>>> to undo the effects of 'btrfs dev scan [dev]'. For this purpose
>>> this patch proposes to use ioctl #5 as it was empty.
>>>          IOW(BTRFS_IOCTL_MAGIC, 5, ..)
>>> This patch adds new ioctl BTRFS_IOC_FORGET_DEV which can be sent from
>>> the /dev/btrfs-control to forget one or all devices, (devices which are
>>> not mounted) from the btrfs kernel.
>>>
>>> The argument it takes is struct btrfs_ioctl_vol_args, and ::name can be
>>> set to specify the device path. And all unmounted devices can be removed
>>> from the kernel if no device path is provided.
>>>
>>> Again, the devices are removed only if the relevant fsid aren't mounted.
>>>
>>> This new cli can provide..
>>>   . Release of unwanted btrfs_fs_devices and btrfs_devices memory if the
>>>     device is not going to be mounted.
>>>   . Ability to mount the device in degraded mode when one of the other
>>>     device is corrupted like in split brain raid1.
>>>   . Running test cases which requires btrfs.ko-reload if the rootfs
>>>     is btrfs.
>>>
>>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>>> ---
>>>   fs/btrfs/super.c           | 3 +++
>>>   fs/btrfs/volumes.c         | 9 +++++++++
>>>   fs/btrfs/volumes.h         | 1 +
>>>   include/uapi/linux/btrfs.h | 2 ++
>>>   4 files changed, 15 insertions(+)
>>>
>>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>>> index 345c64d810d4..f99db6899004 100644
>>> --- a/fs/btrfs/super.c
>>> +++ b/fs/btrfs/super.c
>>> @@ -2246,6 +2246,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
>>>                  ret = PTR_ERR_OR_ZERO(device);
>>>                  mutex_unlock(&uuid_mutex);
>>>                  break;
>>> +       case BTRFS_IOC_FORGET_DEV:
>>> +               ret = btrfs_forget_devices(vol->name);
>>> +               break;
>>>          case BTRFS_IOC_DEVICES_READY:
>>>                  mutex_lock(&uuid_mutex);
>>>                  device = btrfs_scan_one_device(vol->name, FMODE_READ,
>>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>>> index f435d397019e..e1365a122657 100644
>>> --- a/fs/btrfs/volumes.c
>>> +++ b/fs/btrfs/volumes.c
>>> @@ -1208,6 +1208,15 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>>>          return 0;
>>>   }
>>>
>>> +int btrfs_forget_devices(const char *path)
>>> +{
>>> +       mutex_lock(&uuid_mutex);
>>> +       btrfs_free_stale_devices(strlen(path) ? path:NULL, NULL);
>>
>> One space before : and another one after it please.
>>
>> Now the more important: don't use strlen, use strnlen. Some malicious
>> or sloppy user might have passed a non-null terminated string, you
>> don't want strlen to go past the limits of btrfs_ioctl_vol_args for
>> obvious reasons.
> 
> In fact that's a problem for the entire use of vol->name in
> btrfs_control_ioctl. The name's last byte should be set to '\0' to
> avoid issues.
> I'll send a fix for that, so if David fixes the white spaces on commit
> there's no need for a v12.

   Ok. Thanks.

   David, wonder if white spaces can be fixed when integrating?

Thanks, Anand

>>
>> Also, please, not just to make a maintainer's life easier, but current
>> and future reviewers, add the patch version to each patch's subject
>> and not just the cover letter. Also list (after ---) what changes
>> between each patch version in the patch itself and not the cover
>> letter.
>>
>> V12, here we go.
>>
>>> +       mutex_unlock(&uuid_mutex);
>>> +
>>> +       return 0;
>>> +}
>>> +
>>>   /*
>>>    * Look for a btrfs signature on a device. This may be called out of the mount path
>>>    * and we are not allowed to call set_blocksize during the scan. The superblock
>>> diff --git a/fs/btrfs/volumes.h b/fs/btrfs/volumes.h
>>> index aefce895e994..180297d04938 100644
>>> --- a/fs/btrfs/volumes.h
>>> +++ b/fs/btrfs/volumes.h
>>> @@ -406,6 +406,7 @@ int btrfs_open_devices(struct btrfs_fs_devices *fs_devices,
>>>                         fmode_t flags, void *holder);
>>>   struct btrfs_device *btrfs_scan_one_device(const char *path,
>>>                                             fmode_t flags, void *holder);
>>> +int btrfs_forget_devices(const char *path);
>>>   int btrfs_close_devices(struct btrfs_fs_devices *fs_devices);
>>>   void btrfs_free_extra_devids(struct btrfs_fs_devices *fs_devices, int step);
>>>   void btrfs_assign_next_active_device(struct btrfs_device *device,
>>> diff --git a/include/uapi/linux/btrfs.h b/include/uapi/linux/btrfs.h
>>> index 5ca1d21fc4a7..b1be7f828cb4 100644
>>> --- a/include/uapi/linux/btrfs.h
>>> +++ b/include/uapi/linux/btrfs.h
>>> @@ -836,6 +836,8 @@ enum btrfs_err_code {
>>>                                     struct btrfs_ioctl_vol_args)
>>>   #define BTRFS_IOC_SCAN_DEV _IOW(BTRFS_IOCTL_MAGIC, 4, \
>>>                                     struct btrfs_ioctl_vol_args)
>>> +#define BTRFS_IOC_FORGET_DEV _IOW(BTRFS_IOCTL_MAGIC, 5, \
>>> +                                  struct btrfs_ioctl_vol_args)
>>>   /* trans start and trans end are dangerous, and only for
>>>    * use by applications that know how to avoid the
>>>    * resulting deadlocks
>>> --
>>> 1.8.3.1
>>>
>>
>>
>> --
>> Filipe David Manana,
>>
>> “Whether you think you can, or you think you can't — you're right.”
> 
> 
> 
