Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f195.google.com ([209.85.217.195]:34141 "EHLO
	mail-lb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbcAENlo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 08:41:44 -0500
Received: by mail-lb0-f195.google.com with SMTP id jk7so14527402lbc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jan 2016 05:41:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <568B2304.8090205@cn.fujitsu.com>
References: <20160104170553.GA4975@localhost>
	<568B2304.8090205@cn.fujitsu.com>
Date: Tue, 5 Jan 2016 13:41:42 +0000
Message-ID: <CAP-bSRYB4mH1TK9uQnHQaMazxOnMcmCYkhF9xXmrVHPbveZLQQ@mail.gmail.com>
Subject: Re: Crash, boot mount failure: "corrupt leaf, slot offset bad"
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 5 January 2016 at 01:57, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>> Data, single: total=106.79GiB, used=82.01GiB
>> System, single: total=4.00MiB, used=16.00KiB
>> Metadata, single: total=2.01GiB, used=1.51GiB
>> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> That's the btrfs fi df misleading output confusing you.
>
> In fact, your metadata is already used up without available space.
> GlobalReserve should also be counted as Metadata *used* space.

Thanks for the explanation - the FAQ[1] misleads when it describes
GlobalReserve as "The block reserve is only virtual and is not stored
on the devices." - which sounds like the reserve is literally not
stored on the drive.

The FAQ[2] also suggests that the free space in metadata can be less
than the block reserve total:

"If the free space in metadata is less than or equal to the block
reserve value (typically 512 MiB, but might be something else on a
particularly small or large filesystem), then it's close to full."

But what you are saying is that this is wrong and the free space in
metadata can never be less than the block reserve, because the block
reserve includes the metadata free space?

[1] https://btrfs.wiki.kernel.org/index.php/FAQ#What_is_the_GlobalReserve_and_why_does_.27btrfs_fi_df.27_show_it_as_single_even_on_RAID_filesystems.3F
[2] https://btrfs.wiki.kernel.org/index.php/FAQ#if_your_device_is_large_.28.3E16GiB.29

> Good, 5GiB freed space, it can be allocated for metadata to slightly reduce
> the metadata pressure.
>
> But not for long.
> The root resolve will be, add more space into this btrfs.

Yes but this is a 128GB SSD and metadata could have been reallocated
from some of the 25GB of free space allocated to data. Even with a
bigger drive, it is possible that chunks could be allocated to data,
and then later operations requiring more metadata will still run out
(running out of metadata space seems to be a reasonably common
occurrence judging by the number of "why is btrfs reporting no space
when I have space free" questions). The file system shouldn't be
corrupted when that happens.
