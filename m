Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5427CC43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 10EB92070C
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 07:54:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="LHPH0UrB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbfACHye (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 02:54:34 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:34988 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbfACHye (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jan 2019 02:54:34 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x037nAVu114270;
        Thu, 3 Jan 2019 07:54:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=YclNq9uCDPLWuP0IqpVG0nSFPgBqu17mV49sX76Kq0A=;
 b=LHPH0UrBKae8Kxk0eGEGQy41X2M/GqDiSmI/lOCcPfQmyuftEQycnc/NPZEfJaW1BIeA
 R/vCm4E1XDad2jmiC6M72r2z4UKOOGweUbiRhMoIhNUk/JlM6nRy98S7o0SJ9QxQgwzH
 kB3ZJhzSUGYdXIpX67J0cH0I4NwbewbBE9myLlbsWg8wDg0fEOz7Yr7SIfYV1apaMcEP
 OPtoUUKiSUFwdVAkH5hdtwZ/6V/RT9yF2jpvGcWJL4jjLXrgczuGQXTEfwcGVdstPnOz
 zFqRxAs+reB5nhE/VHFlsfQLh3rYob+MfIrBw8ZzhrySW8PVg8746y4JLXLSsoyBBYhA wA== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pp1jr5mf9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jan 2019 07:54:29 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x037sTRt013133
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Jan 2019 07:54:29 GMT
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x037sSTF007214;
        Thu, 3 Jan 2019 07:54:29 GMT
Received: from [10.190.142.77] (/192.188.170.109)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 02 Jan 2019 23:54:28 -0800
Subject: Re: [PATCH RESEND v12] btrfs: introduce feature to forget a btrfs
 device
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <1546408172-5193-1-git-send-email-anand.jain@oracle.com>
 <1546408172-5193-2-git-send-email-anand.jain@oracle.com>
 <20190102160022.GW23615@twin.jikos.cz>
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <ac8541d7-53e8-74c7-1c45-1cbbf86b8710@oracle.com>
Date:   Thu, 3 Jan 2019 15:54:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190102160022.GW23615@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9124 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901030071
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/03/2019 12:00 AM, David Sterba wrote:
> On Wed, Jan 02, 2019 at 01:49:31PM +0800, Anand Jain wrote:
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
>> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
>> ---
>> v11->v12: fix coding style add spacing before after ":".
>> v1->v11: Pls ref to the cover-letter. (sorry about that).
>>
>>   fs/btrfs/super.c           | 3 +++
>>   fs/btrfs/volumes.c         | 9 +++++++++
>>   fs/btrfs/volumes.h         | 1 +
>>   include/uapi/linux/btrfs.h | 2 ++
>>   4 files changed, 15 insertions(+)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index d3c6bbc0aa3a..eba2966913ae 100644
>> --- a/fs/btrfs/super.c
>> +++ b/fs/btrfs/super.c
>> @@ -2247,6 +2247,9 @@ static long btrfs_control_ioctl(struct file *file, unsigned int cmd,
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
>> index 8e36cbb355df..48415a9edd46 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1397,6 +1397,15 @@ static int btrfs_read_disk_super(struct block_device *bdev, u64 bytenr,
>>   	return 0;
>>   }
>>   
>> +int btrfs_forget_devices(const char *path)
>> +{
>> +	mutex_lock(&uuid_mutex);
>> +	btrfs_free_stale_devices(strlen(path) ? path : NULL, NULL);
>> +	mutex_unlock(&uuid_mutex);
>> +
>> +	return 0;
> 
> I think this should reflect the status of the operation. The ioctl
> caller has no information about success/error. Eg. an invalid device
> path passed could return -ENOENT, 0 if it was released and 1 if not.
> 
> In case of all devices, it's probably ok to return 0.


OK. v13 will return error if the given device is not found,
and I find ENXIO is more suitable (instead of ENOENT).
If you disagree pls can you make the changes as in [1]
when integrating. I have tested with both.

--------
[1]
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 2ab42bfe5d3c..e04784c64a98 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -763,7 +763,7 @@ static int btrfs_free_stale_devices(const char *path,
         int ret;

         if (path)
-               ret = -ENXIO;
+               ret = -ENOENT;
         else
                 ret = 0;
----------------

Thanks, Anand
