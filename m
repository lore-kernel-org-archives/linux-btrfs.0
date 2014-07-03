Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38659 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbaGCAtR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Jul 2014 20:49:17 -0400
Message-ID: <53B4A886.70106@fb.com>
Date: Wed, 2 Jul 2014 20:49:10 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Eric Sandeen <sandeen@redhat.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: fix nossd and ssd_spread mount option regression
References: <1404274747-20036-1-git-send-email-quwenruo@cn.fujitsu.com> <53B42F8B.8090600@redhat.com> <53B4A2AD.2010506@cn.fujitsu.com>
In-Reply-To: <53B4A2AD.2010506@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/02/2014 08:24 PM, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: Re: [PATCH v2] btrfs: fix nossd and ssd_spread mount option
> regression
> From: Eric Sandeen <sandeen@redhat.com>
> To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
> Date: 2014年07月03日 00:12
>> On 7/1/14, 11:19 PM, Qu Wenruo wrote:
>>> From: Eric Sandeen <sandeen@redhat.com>
>>>
>>> The commit
>>>
>>> 0780253 btrfs: Cleanup the btrfs_parse_options for remount.
>>>
>>> broke ssd options quite badly; it stopped making ssd_spread
>>> imply ssd, and it made "nossd" unsettable.
>>>
>>> Put things back at least as well as they were before
>>> (though ssd mount option handling is still pretty odd:
>>>
>>> Reported-by: Roman Mamedov <rm@romanrm.net>
>>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> ---
>>> v2(By Qu):
>>>    Make nossd disable ssd and ssd_spread.
>>>    Add notes in Documentation/btrfs.txt
>> Ok, thanks for fixing up a little bit more.
>>
>> But option handling is still strange even with your changes:
>>
>> # mount -o ssd /dev/sdc3 /mnt/test; grep sdc3 /proc/mounts
>> /dev/sdc3 /mnt/test btrfs rw,seclabel,relatime,ssd,space_cache 0 0
>>
>> # mount -o remount,nossd /dev/sdc3 /mnt/test; grep sdc3 /proc/mounts
>> /dev/sdc3 /mnt/test btrfs rw,seclabel,relatime,nossd,space_cache 0 0
>>
>> # mount -o remount,ssd_spread /dev/sdc3 /mnt/test; grep sdc3 /proc/mounts
>> /dev/sdc3 /mnt/test btrfs
>> rw,seclabel,relatime,nossd,ssd_spread,space_cache 0 0
>>
>> # mount -o remount,ssd /dev/sdc3 /mnt/test; grep sdc3 /proc/mounts
>> /dev/sdc3 /mnt/test btrfs
>> rw,seclabel,relatime,nossd,ssd_spread,space_cache 0 0
>>
>> I'd rather just commit my first patch to fix the regression ASAP, and
>> fix the ssd option mess with a second patch which has received careful
>> testing.
>>
>> -Eric
> OK, please merge the v1 patch only.
> I'll fix the ssd dependency things later.

The v1 patch is already queued ;)

-chris
