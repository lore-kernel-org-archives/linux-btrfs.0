Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail2.jellyfishnet.co.uk ([93.91.20.10]:55360 "EHLO
	mail2.jellyfishnet.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab3DVOoI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Apr 2013 10:44:08 -0400
From: Mark Ridley <mark@backupsystems.co.uk>
To: Harald Glatt <mail@hachre.de>
CC: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Mon, 22 Apr 2013 15:44:07 +0100
Subject: Re: BTRFS 3.8.7 Kernel Crash Report
Message-ID: <CD9B0B1A.38625%mark@backupsystems.co.uk>
In-Reply-To: <CAFWF=anKL2ZJG77+iKruHC9qSTDjTLRMyJzbZjv+nLdxVUm9tw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

For me anyway, I hope the fedora team don't take too long to make it
available.

Thanks for all your help today.

On 22/04/2013 15:41, "Harald Glatt" <mail@hachre.de> wrote:

>I heard it's coming out next week.
>
>On Mon, Apr 22, 2013 at 4:40 PM, Mark Ridley <mark@backupsystems.co.uk>
>wrote:
>> Any idea when the 3.9 kernel will be out.
>>
>> I see there are lots of btrfs fixes going into it.
>>
>> I'm currently running FC18 on 3.8.7, although 10 minutes ago it got
>> updated to 3.8.8.
>>
>> On 22/04/2013 15:28, "Harald Glatt" <mail@hachre.de> wrote:
>>
>>>I think it won't... That would just be the goal eventually. If scrub
>>>sees no errors all the data should be in tact and your best bet to get
>>>things working perfectly again is to create a new filesystem and
>>>transfer the data into it.
>>>
>>>I'm not a dev and I can't say if a btrfs-image for debugging purposes
>>>would be helpful in this case or not, maybe this kind of corrution has
>>>been fixed a long time ago and wouldn't happen again in up-to-date
>>>versions of btrfs anyway.
>>>
>>>On Mon, Apr 22, 2013 at 4:24 PM, Mark Ridley <mark@backupsystems.co.uk>
>>>wrote:
>>>> Thanks for getting back to me.
>>>>
>>>> Do you think remount fixes the keys reverted problem?
>>>>
>>>> On 22/04/2013 15:18, "Harald Glatt" <mail@hachre.de> wrote:
>>>>
>>>>>Only data errors (from CRC checks), maybe also some structure errors -
>>>>>I'm not sure. A remount should fix all errors. If it doesn't I think
>>>>>it's considered a bug - ultimately the goal is that no --repair should
>>>>>ever be required... Scrub is generally safe though, unlike btrfsck
>>>>>--repair.
>>>>>
>>>>>On Mon, Apr 22, 2013 at 4:16 PM, Mark Ridley
>>>>><mark@backupsystems.co.uk>
>>>>>wrote:
>>>>>> What does btrfs scrub do?
>>>>>>
>>>>>> Is that meant to detect and fix problems?
>>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>> Mark
>>>>>>
>>>>>> On 22/04/2013 15:13, "Harald Glatt" <mail@hachre.de> wrote:
>>>>>>
>>>>>>>Yeah, --repair is not recommended as of now. Maybe posting the
>>>>>>>btrfsck
>>>>>>>output just from checking would be helpful in this case.
>>>>>>>
>>>>>>>On Mon, Apr 22, 2013 at 4:04 PM, Mark Ridley
>>>>>>><mark@backupsystems.co.uk>
>>>>>>>wrote:
>>>>>>>> No.
>>>>>>>>
>>>>>>>> Without --repair pointed out some problems, but whats the point of
>>>>>>>>knowing
>>>>>>>> about the problems if they can't be fixed so I ran with --repair
>>>>>>>>and
>>>>>>>>it
>>>>>>>> broke the volume.
>>>>>>>>
>>>>>>>> On 22/04/2013 15:02, "Harald Glatt" <mail@hachre.de> wrote:
>>>>>>>>
>>>>>>>>>On Mon, Apr 22, 2013 at 4:01 PM, Mark Ridley
>>>>>>>>><mark@backupsystems.co.uk>
>>>>>>>>>wrote:
>>>>>>>>>> Thanks, David.
>>>>>>>>>>
>>>>>>>>>> What causes this corruption and how can I fix it?
>>>>>>>>>>
>>>>>>>>>> I'm very worried about running btrfs.fsck as last time it made a
>>>>>>>>>>slight
>>>>>>>>>> corruption like this worse and the whole volume had to be
>>>>>>>>>>trashed.
>>>>>>>>>>
>>>>>>>>>> After fsck the "available space" on df ended up being negative
>>>>>>>>>>so
>>>>>>>>>>nothing
>>>>>>>>>> could be written to the volume.
>>>>>>>>>>
>>>>>>>>>> Mark
>>>>>>>>>>
>>>>>>>>>> On 22/04/2013 14:42, "David Sterba" <dsterba@suse.cz> wrote:
>>>>>>>>>>
>>>>>>>>>>>On Mon, Apr 22, 2013 at 01:19:41PM +0000, Mark Ridley wrote:
>>>>>>>>>>>> If I then use rsync --inplace to update the images, I get a
>>>>>>>>>>>>btrfs
>>>>>>>>>>>>stack
>>>>>>>>>>>>trace
>>>>>>>>>>>> and btrfs hangs:
>>>>>>>>>>>>
>>>>>>>>>>>> This happens every night.
>>>>>>>>>>>
>>>>>>>>>>>> [<ffffffffa00bd5c1>] btrfs_set_item_key_safe+0x141/0x150
>>>>>>>>>>>>[btrfs]
>>>>>>>>>>>
>>>>>>>>>>>The check fails because it finds keys in reverted order. Given
>>>>>>>>>>>the
>>>>>>>>>>>conditions under which it happens I think it's an on-disk
>>>>>>>>>>>corruption
>>>>>>>>>>>and
>>>>>>>>>>>fsck should be able to at least detect it.
>>>>>>>>>>>
>>>>>>>>>>>david
>>>>>>>>>>
>>>>>>>>>> --
>>>>>>>>>> To unsubscribe from this list: send the line "unsubscribe
>>>>>>>>>>linux-btrfs"
>>>>>>>>>>in
>>>>>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>>>>>> More majordomo info at
>>>>>>>>>>http://vger.kernel.org/majordomo-info.html
>>>>>>>>>
>>>>>>>>>This happened without --repair?
>>>>>>>>
>>>>>>
>>>>
>>

