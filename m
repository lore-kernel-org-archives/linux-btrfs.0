Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:57522 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbaATCak (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 Jan 2014 21:30:40 -0500
Message-ID: <52DC8AAF.3000002@cn.fujitsu.com>
Date: Mon, 20 Jan 2014 10:32:15 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Vladi Gergov <vladi@aresgate.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: 2 year old raid1 issue chunk-recovery help
References: <20140115194008.GA5425@gypsyops.denof.sin> <52D73F9F.6030909@cn.fujitsu.com> <20140116182042.GB5425@gypsyops.denof.sin> <52D894F8.1040300@cn.fujitsu.com> <20140117165254.GA32526@gypsyops.denof.sin>
In-Reply-To: <20140117165254.GA32526@gypsyops.denof.sin>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On fri, 17 Jan 2014 08:52:55 -0800, Vladi Gergov wrote:
> Not sure if my previous email was received as I sent it from my phone. I
> had to dd the disk off and then losetup mount the image. What do you
> mean by erase the data on loop7? I have tried to mount separately without
> success.

When we mount a btrfs filesystem, the kernel will find out all the devices that
belongs to the filesystem by searching all the devices and comparing fs uuid in
the super block. So I think you can erase the super block data in loop7 to prevent
it being found since it broken the mount. But I made a mistake, actually you needn't
erase the data on loop7, just detach it.

BTW, I have tried the method I said below on my box, and the device was replaced
successfully.
 # mkfs.btrfs -d raid1 -m raid1 <dev1> <dev2>
 # mount <dev1> <mnt>
 # dd if=<in> of=<mnt>/<out> bs=1M count=1024
 # umount <mnt>
 # unplug <dev2>
 # mount <dev1> -o degraded <mnt>
 # btrfs replace start missing <new_dev>

Thanks
Miao

> 
> On Friday, 17.01.14 at 10:27, Miao Xie wrote:
>> On Thu, 16 Jan 2014 10:20:42 -0800, Vladi Gergov wrote:
>>> Thanks Miao,
>>>
>>> I have tried to mount it with -o degraded and -o recovery here is the
>>> outputs:
>>>
>>> [216094.269443] btrfs: device label das4 devid 2 transid 107954
>>> /dev/loop7
>>> [216094.281965] btrfs: device label das1 devid 7 transid 1168964
>>> /dev/sdi
>>> [216094.313419] btrfs: device label das4 devid 3 transid 107954 /dev/sdj
>>> [216113.887503] btrfs: device label das4 devid 2 transid 107954
>>> /dev/loop7
>>> [216113.888690] btrfs: allowing degraded mounts
>>> [216113.889440] btrfs: failed to read chunk root on loop7
>>> [216113.905742] btrfs: open_ctree failed
>>> [216135.144739] btrfs: device label das4 devid 2 transid 107954
>>> /dev/loop7
>>> [216135.145996] btrfs: enabling auto recovery
>>> [216135.146783] btrfs: failed to read chunk root on loop7
>>> [216135.155985] btrfs: open_ctree failed
>>>
>>> any other suggestions? Thanks again.
>>
>> Is loop7 used to instead of the bad device /dev/sdi? If so, I think
>> we should erase the data in the loop7, and then
>>
>>>>  # mount <dev> -o degraded <mnt>
>>>>  # btrfs replace start missing <new_dev>
>>
>> Thanks
>> Miao
>>
>>>
>>> On Thursday, 16.01.14 at 10:10, Miao Xie wrote:
>>>> On wed, 15 Jan 2014 11:40:09 -0800, Vladi Gergov wrote:
>>>>> Hi, in 2010 i had an issue with my raid1 when one drive failed and i
>>>>> added another drive to the array and tried to rebuild. Here is what bug
>>>>> I hit according to Chris Mason
>>>>> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg06868.html
>>>>>
>>>>> I have since updated to lastes btrfs-tools 3.12 + kernel 3.13-rc7 and
>>>>> attempted an chunk recovery which failed with this
>>>>> http://bpaste.net/show/168445/
>>>>>
>>>>> If anyone can help me get at least some of the data off this bad boy it
>>>>> would be great! I am cc'ing Miao since his name was thrown under the bus
>>>>> in irc :). Thanks in advance!
>>>>>
>>>>
>>>> Chunk recover command can only recover the case that the devices are good, only
>>>> the chunk tree is corrupted. So it is not suitable to fix your issue.
>>>>
>>>> I think you can try the replace function if you can mount the device successfully,
>>>> just like:
>>>>  # mount <dev> -o degraded <mnt>
>>>>  # btrfs replace start missing <new_dev>
>>>>
>>>> Thanks
>>>> Miao
>>>>
>>>
>>
> 

