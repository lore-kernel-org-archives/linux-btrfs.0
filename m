Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:37008 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752462AbdFURac (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 13:30:32 -0400
Received: by mail-it0-f45.google.com with SMTP id m47so7281846iti.0
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Jun 2017 10:30:31 -0700 (PDT)
Subject: Re: Exactly what is wrong with RAID5/6
To: Andrei Borzenkov <arvidjaar@gmail.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1f5a4702-d264-51c6-aadd-d2cf521a45eb@dirtcellar.net>
 <60421001-5d74-2fb4-d916-7a397f246f20@cn.fujitsu.com>
 <1498049001.6359.4.camel@scientia.net>
 <dc5044a4-d052-70c4-0f3f-ed72c7c95731@gmail.com>
 <69992a11-bf68-9c0b-8b23-fef48ba80907@gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <76da9e45-a833-2552-f546-d71d9c2b371b@gmail.com>
Date: Wed, 21 Jun 2017 13:30:21 -0400
MIME-Version: 1.0
In-Reply-To: <69992a11-bf68-9c0b-8b23-fef48ba80907@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-06-21 13:20, Andrei Borzenkov wrote:
> 21.06.2017 16:41, Austin S. Hemmelgarn пишет:
>> On 2017-06-21 08:43, Christoph Anton Mitterer wrote:
>>> On Wed, 2017-06-21 at 16:45 +0800, Qu Wenruo wrote:
>>>> Btrfs is always using device ID to build up its device mapping.
>>>> And for any multi-device implementation (LVM,mdadam) it's never a
>>>> good
>>>> idea to use device path.
>>>
>>> Isn't it rather the other way round? Using the ID is bad? Don't you
>>> remember our discussion about using leaked UUIDs (or accidental
>>> collisions) for all kinds of attacks?
>> Both are bad for different reasons.  For the particular case of sanely
>> handling transient storage failures (device disappears then reappears),
>> you can't do it with a path in /dev (which is what most people mean when
>> they say device path), and depending on how the hardware failed and the
>> specifics of the firmware, you may not be able to do it with a
>> hardware-level device path, but you can do it with a device ID assuming
>> you sanely verify the ID.  Right now, BTRFS is not sanely checking the
>> ID (it only verifies the UUID's in the FS itself, it should also be
>> checking hardware-level identifiers like WWN).
> 
> Which is not enough too; if device dropped off array and reappeared
> later we need to be able to declare it stale, even if it has exactly the
> same UUID and WWN and whatever hardware identifier is used. So we need
> some generation number to be able to do it. Incidentally MD does have
> them and compares generation numbers to decide whether device can be
> assimilated.
> 
I was not disputing that aspect, just the method verifying the device 
that reappeared is the same one that disappeared.  Outside of the 
requirement to properly re-sync (we would also need to do some kind of 
sanity check on the generation number too, otherwise we end up with the 
possibility of a partial write there nuking the whole FS when the device 
reconnects), verifying some level of hardware identification covers the 
security and data safety issues that Christoph is referring to 
sufficiently for the common cases (with the biggest being USB attached 
devices with BTRFS volumes on them).
