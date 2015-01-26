Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:43249 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854AbbAZJis (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Jan 2015 04:38:48 -0500
Message-ID: <54C60C74.7000500@oracle.com>
Date: Mon, 26 Jan 2015 17:44:20 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Gui Hecheng <guihc.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 2/2 RESEND] btrfs: introduce shrinker for rb_tree that
 keeps valid btrfs_devices
References: <1421311988-11976-1-git-send-email-guihc.fnst@cn.fujitsu.com> <1421311988-11976-2-git-send-email-guihc.fnst@cn.fujitsu.com> <20150123181001.GT13289@twin.jikos.cz>
In-Reply-To: <20150123181001.GT13289@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



I think we won't need this patch. the coming sysfs changes will
have entry point to handle missing devices/FSID. (inspired by md).
That will be much cleaner to trigger the clean up based on the
device FS changes.
The proposed fix in this Patch, can it handle things like when
customer decides to overwrite btrfs device with ext FS. ? would
that still leave some stale fs_devices. ?

Thanks, Anand.


On 01/24/2015 02:10 AM, David Sterba wrote:
> On Thu, Jan 15, 2015 at 04:53:08PM +0800, Gui Hecheng wrote:
>> The following patch:
>> 	btrfs: remove empty fs_devices to prevent memory runout
>>
>> introduces @valid_dev_root aiming at recording @btrfs_device objects that
>> have corresponding block devices with btrfs.
>> But if a block device is broken or unplugged, no one tells the
>> @valid_dev_root to cleanup the "dead" objects.
>>
>> To recycle the memory occuppied by those "dead"s, we could rely on
>> the shrinker. The shrinker's scan function will traverse the
>> @valid_dev_root and trys to open the devices one by one, if it fails
>> or encounters a non-btrfs it will remove the "dead" @btrfs_device.
>
> I don't see why shrinker is used here.
>
> linux.git/linux/shrinker.h:
>
> "A callback you can register to apply pressure to ageable caches."
>
> How is guaranteed that it will take action at the right time?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
