Return-Path: <SRS0=RNif=PM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 359E0C43387
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 05:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F28972070D
	for <linux-btrfs@archiver.kernel.org>; Fri,  4 Jan 2019 05:26:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YnICo6o1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbfADF06 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 4 Jan 2019 00:26:58 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:38406 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfADF05 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jan 2019 00:26:57 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x045O56X096505;
        Fri, 4 Jan 2019 05:26:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : cc : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=jKEK0bZAFmdFcwCsYhdJ5xqsTAvTlsLWSgsJwx79uNY=;
 b=YnICo6o1sR9EA2LglAOYFDy+GJQAFgulNsUHHtUKgfbCj+hh1xv51SrgMbEeHZF6SECk
 ppUx4hDccVlXErM5jbYeSPrlZ1cg3J7x7lnxdOvudmrev8DRHOC84rSu9v9bjMINfgrW
 sWwBkFwj0UP9e345iqPv17Gj2bkp+iud2zZf1DYomsFhvB6yo2+U9m2uQtIAhH+tbAzd
 4Ni1u9Yfx1eTp4+RLT25mdqBENYDxuAG5eHxYQ8ROYDPqRr6ulD+7L69MSWWGj/GQbS+
 hkCCuOsECPv2re/O8q/EbOy1Oqe6zzQx5TP/SYo9Eer3AhfqA4gpOnDmYmEo/NGf+zQx /w== 
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pp1jrabvm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jan 2019 05:26:53 +0000
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x045QrWs008740
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Jan 2019 05:26:53 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x045Qqhj006849;
        Fri, 4 Jan 2019 05:26:53 GMT
Received: from [192.168.1.145] (/116.87.143.221)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Jan 2019 21:26:52 -0800
Subject: Re: [PATCH v13] btrfs: introduce feature to forget a btrfs device
To:     dsterba@suse.cz
References: <1546502498-28070-1-git-send-email-anand.jain@oracle.com>
 <1546502498-28070-2-git-send-email-anand.jain@oracle.com>
 <20190103152426.GI23615@twin.jikos.cz>
Cc:     linux-btrfs@vger.kernel.org
From:   Anand Jain <anand.jain@oracle.com>
Message-ID: <1fb23edf-d63d-a060-be99-2f93ef946d06@oracle.com>
Date:   Fri, 4 Jan 2019 13:26:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190103152426.GI23615@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9125 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1901040047
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 01/03/2019 11:24 PM, David Sterba wrote:
> On Thu, Jan 03, 2019 at 04:01:37PM +0800, Anand Jain wrote:
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
>> v12->v13:
>>    btrfs.ko returns error on failing to find the given device.
>>    For no argument (btrfs device scan --forget) if there is
>>    no device to forget then it shall just return success.
>> v11->v12: fix coding style add spacing before after ":".
>> v1->v11: Pls ref to the cover-letter. (sorry about that).
>>
>>   fs/btrfs/super.c           |  3 +++
>>   fs/btrfs/volumes.c         | 55 +++++++++++++++++++++++++++++++++++-----------
>>   fs/btrfs/volumes.h         |  1 +
>>   include/uapi/linux/btrfs.h |  2 ++
>>   4 files changed, 48 insertions(+), 13 deletions(-)
>>
>> diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
>> index 33cc9aba9c94..a4e8beec0fc5 100644
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
>> index 2576b1a379c9..2ab42bfe5d3c 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -734,6 +734,19 @@ static void pending_bios_fn(struct btrfs_work *work)
>>   	run_scheduled_bios(device);
>>   }
>>   
>> +static bool device_path_matched(const char *path, struct btrfs_device *device)
>> +{
>> +	int found;
>> +
>> +	rcu_read_lock();
>> +	found = strcmp(rcu_str_deref(device->name), path);
>> +	rcu_read_unlock();
>> +
>> +	if (!found)
>> +		return true;
>> +	return false;
>> +}
>> +
>>   /*
>>    *  Search and remove all stale (devices which are not mounted) devices.
>>    *  When both inputs are NULL, it will search and release all stale devices.
>> @@ -742,44 +755,47 @@ static void pending_bios_fn(struct btrfs_work *work)
>>    *  skip_dev:	Optional. Will skip this device when searching for the stale
>>    *		devices.
>>    */
>> -static void btrfs_free_stale_devices(const char *path,
>> +static int btrfs_free_stale_devices(const char *path,
>>   				     struct btrfs_device *skip_device)
>>   {
>>   	struct btrfs_fs_devices *fs_devices, *tmp_fs_devices;
>>   	struct btrfs_device *device, *tmp_device;
>> +	int ret;
>> +
>> +	if (path)
>> +		ret = -ENXIO;
>> +	else
>> +		ret = 0;
> 
> Can you please split this change to another patch? It's a preparatory
> work for the new ioctl. The return value meaning should be also
> documented in the function comment.
> 

Pls find v14. I have also use -ENOENT instead of -ENXIO and documented 
the return value in the function header.

