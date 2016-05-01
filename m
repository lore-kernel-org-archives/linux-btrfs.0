Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24040 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbcEAXMm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 May 2016 19:12:42 -0400
Subject: Re: [PATCH] btrfs: fix lock dep warning, move scratch dev out of
 device_list_mutex and uuid_mutex
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        yauhen.kharuzhy@zavadatar.com
References: <1460969483-7500-1-git-send-email-anand.jain@oracle.com>
 <20160425150908.GB29353@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <57268D67.9010200@oracle.com>
Date: Mon, 2 May 2016 07:12:39 +0800
MIME-Version: 1.0
In-Reply-To: <20160425150908.GB29353@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/25/2016 11:09 PM, David Sterba wrote:
> On Mon, Apr 18, 2016 at 04:51:23PM +0800, Anand Jain wrote:
>> When the replace target fails, the target device will be taken
>> out of fs device list, scratch + update_dev_time and freed. However
>> we could do the scratch  + update_dev_time and free part after the
>> device has been taken out of device list, so that we don't have to
>> hold the device_list_mutex and uuid_mutex locks.
>>
>> Reported issue:
> [...]
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> Reported-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
>
> Reviewed-by: David Sterba <dsterba@suse.com>

Thanks.
Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
