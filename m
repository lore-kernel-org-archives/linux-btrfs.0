Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5679 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754140AbaDKJH0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Apr 2014 05:07:26 -0400
Message-ID: <5347B10C.1080708@cn.fujitsu.com>
Date: Fri, 11 Apr 2014 17:08:28 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: Add device management related paragraph.
References: <1397184233-18535-1-git-send-email-quwenruo@cn.fujitsu.com> <20140411061048.GD7322@merlins.org>
In-Reply-To: <20140411061048.GD7322@merlins.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 1/2] btrfs-progs: Add device management related 
paragraph.
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年04月11日 14:10
> On Fri, Apr 11, 2014 at 10:43:52AM +0800, Qu Wenruo wrote:
>> Add device management related paragraph to better explain btrfs device
>> management.
> Thank you for these updates.
>   
>> Cc: Marc MERLIN <marc@merlins.org>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> (comments below)
>
>> ---
>>   Documentation/btrfs-balance.txt |  3 +++
>>   Documentation/btrfs-device.txt  | 42 +++++++++++++++++++++++++++++++++++++++++
>>   Documentation/btrfs-replace.txt |  4 ++++
>>   3 files changed, 49 insertions(+)
>>
>> diff --git a/Documentation/btrfs-balance.txt b/Documentation/btrfs-balance.txt
>> index 2289fdf..1b1861c 100644
>> --- a/Documentation/btrfs-balance.txt
>> +++ b/Documentation/btrfs-balance.txt
>> @@ -14,6 +14,8 @@ DESCRIPTION
>>   'btrfs balance' is used to balance chunks in a btrfs filesystem across
>>   multiple or even single device.
>>   
>> +See `btrfs-device`(8) for more details about the effect on device management.
>> +
>>   SUBCOMMAND
>>   ----------
>>   <path>::
>> @@ -75,3 +77,4 @@ further details.
>>   SEE ALSO
>>   --------
>>   `mkfs.btrfs`(8),
>> +`btrfs-device`(8)
>> diff --git a/Documentation/btrfs-device.txt b/Documentation/btrfs-device.txt
>> index 20d7bcd..474d411 100644
>> --- a/Documentation/btrfs-device.txt
>> +++ b/Documentation/btrfs-device.txt
>> @@ -14,6 +14,46 @@ DESCRIPTION
>>   'btrfs device' is used to control the btrfs devices, since btrfs can be used
>>   across several devices, 'btrfs device' is used for multiple device management.
>>   
>> +DEVICE MANAGEMENT
>> +-----------------
>> +Btrfs filesystem is capable to manage multiple devices.
>> +
>> +Btrfs filesystem use different profiles to manage different RAID level, and
>> +use balance to rebuild chunks, also devices can be added/removed/replace
>> +online.
>> +
>> +Profile::
>> +Btrfs filesystem use data/metadata profiles to manage allocation/duplication
>> +mechanism. Profiles like RAID level can be assigned to data and metadata separately.
>> ++
>> +See `mkfs.btrfs`(8) for more details.
>> +
>> +RAID level::
>> +Btrfs filesystem supports most of the standard RAID level: 0/1/5/6/10.
>> +RAID levels can be assigned at mkfs time or online.
>> ++
>> +See `mkfs.btrfs`(8) for mkfs time RAID level assign and `btrfs-balance`(8) for
>> +online RAID level assign.
>> +
>> +Balance::
>> +`btrfs-balance`(8) subcommand can be used to balance or rebuild chunks to the
>> +desired profile.
>> ++
>> +Due to the fact that balance can rebuild/recovery chunks according to its RAID
>> +duplication if possible, so when using RAID1/5/6/10 with some devices failed
>> +and you just added a new device to btrfs using `btrfs-device`(8), you should
>> +run `btrfs-balance`(8) to rebuild the chunks.
>> ++
>> +See `btrfs-balance`(8) for more details.
>> +
>> +Device add/remove/replace::
>> +Device can be added/removed using `btrfs-replace`(8) subcommand and replaced
>> +using `btrfs-replace`(8).
> I'm not sure I understand this sentence exactly.
Sorry for my poor English, I'll try to change it to a better expression.
>
>> +When device is removed or replaced, btrfs will do the chunk rebuild if needed.
>> ++
>> +See `btrfs-replace`(8) and this man page for more details.
>> +
>>   SUBCOMMAND
>>   ----------
>>   'add' [-Kf] <dev> [<dev>...] <path>::
>> @@ -73,3 +113,5 @@ further details.
>>   SEE ALSO
>>   --------
>>   `mkfs.btrfs`(8),
>> +`btrfs-replace`(8),
>> +`btrfs-balance`(8)
>> diff --git a/Documentation/btrfs-replace.txt b/Documentation/btrfs-replace.txt
>> index 8c5dcc4..15a46c2 100644
>> --- a/Documentation/btrfs-replace.txt
>> +++ b/Documentation/btrfs-replace.txt
>> @@ -13,6 +13,9 @@ DESCRIPTION
>>   -----------
>>   'btrfs replace' is used to replace btrfs managed devices with other device.
> I would add a quick line here saying that it's not currently supported for
> RAID5/6, and to see btrfs-device for add/delete to get around the replace
> missing problem.
>
> I've explained that in more details on
> https://btrfs.wiki.kernel.org/index.php/FAQ#Can_I_use_RAID.5B56.5D_on_my_Btrfs_filesystem.3F
> but it may not be a great page to link to.
> Ok, I just made a new nice page for you:
> https://btrfs.wiki.kernel.org/index.php/RAID56
>
> Do you think it would be ok to link to
> https://btrfs.wiki.kernel.org/index.php/RAID56#Parity_Rebuilds_and_Advanced_Disk_Replacement
> in the btrfs replace man page?
That's very nice for you making a new wiki page.
IMO it's OK to link to the URL.

Thanks,
Qu
>    
>> +It is recommended to see `btrfs-device`(8) for more details about btrfs device
>> +management.
>> +
>>   SUBCOMMAND
>>   ----------
>>   'start' [-Bfr] <srcdev>|<devid> <targetdev> <path>::
>> @@ -74,3 +77,4 @@ further details.
>>   SEE ALSO
>>   --------
>>   `mkfs.btrfs`(8),
>> +`btrfs-device`(8),
>> -- 
>> 1.9.2
> The rest looks good.
>
> Thank you,
> Marc

