Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym02.jp.fujitsu.com ([211.128.242.41]:37438 "EHLO
        mgwym02.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753154AbdJQBqN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 21:46:13 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 56E42AC0543
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Oct 2017 10:46:07 +0900 (JST)
Subject: Re: [PATCH v3 2/2] btrfs-progs: doc: add description of missing and
 example of device remove
To: Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7dcb7f01-ce39-18a6-9a16-9230b76baf77@jp.fujitsu.com>
 <d5e0465d-9606-1881-84a7-86c0d43e0033@jp.fujitsu.com>
 <98ad3fcf-dc1c-babd-2876-c26953105a03@suse.com>
From: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
CC: Duncan <1i5t5.duncan@cox.net>
Message-ID: <bffa9bb9-bd2b-90b7-9517-f728bbbeb543@jp.fujitsu.com>
Date: Tue, 17 Oct 2017 10:45:58 +0900
MIME-Version: 1.0
In-Reply-To: <98ad3fcf-dc1c-babd-2876-c26953105a03@suse.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017/10/16 18:22, Nikolay Borisov wrote:
> 
> 
> On 16.10.2017 07:56, Misono, Tomohiro wrote:
>> This patch updates help/document of "btrfs device remove" in two points:
>>
>> 1. Add explanation of 'missing' for 'device remove'. This is only
>> written in wikipage currently.
>> (https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices)
>>
>> 2. Add example of device removal in the man document. This is because
>> that explanation of "remove" says "See the example section below", but
>> there is no example of removal currently.
>>
>> Signed-off-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>
>> Reviewed-by: Satoru Takeuchi <satoru.takeuchi@gmail.com>
>> ---
>>  Documentation/btrfs-device.asciidoc | 19 ++++++++++++++++++-
>>  cmds-device.c                       |  8 ++++++++
>>  2 files changed, 26 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/btrfs-device.asciidoc b/Documentation/btrfs-device.asciidoc
>> index 88822ec..dd60415 100644
>> --- a/Documentation/btrfs-device.asciidoc
>> +++ b/Documentation/btrfs-device.asciidoc
>> @@ -68,13 +68,17 @@ Remove device(s) from a filesystem identified by <path>
>>  Device removal must satisfy the profile constraints, otherwise the command
>>  fails. The filesystem must be converted to profile(s) that would allow the
>>  removal. This can typically happen when going down from 2 devices to 1 and
>> -using the RAID1 profile. See the example section below.
>> +using the RAID1 profile. See the *TYPICAL USECASES* section below.
>>  +
>>  The operation can take long as it needs to move all data from the device.
>>  +
>>  It is possible to delete the device that was used to mount the filesystem. The
>>  device entry in mount table will be replaced by another device name with the
>>  lowest device id.
>> ++
>> +If device is mounted as degraded mode (-o degraded), special term "missing"
> 	^ filesystem	^ in
>> +can be used for <device>. In that case, the first device that is described by> +the filesystem metadata, but not preseted at the mount time will be
> removed.
> 					^ present
> 
> Also, what happens if there are 2 or more devices missing, will those be
> deleted as well or just the first device? If all missing devices are
> handled then this needs to be reflected in the documentation.
> 

If there are 2 or more devices missing, only one device will be removed.
However, that case is rare. Previous discussion is in this thread: 
https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg68734.html

I copied these lines from wiki[1], but it seems this needs more explanations.
How about adding a note in the end?:
===
 If filesystem is mounted in degraded mode (-o degraded), special term "missing"
 can be used for <device>. In that case, the first device that is described by
 the filesystem metadata, but not present at the mount time will be removed.

 NOTE: In most cases, there is only one missing device in degraded mode, otherwise
 mount fails. If there are two or more devices missing (e.g. possible in RAID 6),
 you need specify "missing" as many times as the number of missing devices to 
 remove all of them.
===

Please let me know if there is more appropriate explanation.

Thanks,
Tomohiro

[1] https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices

