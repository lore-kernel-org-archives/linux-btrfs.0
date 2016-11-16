Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from virtualmin.buehlmann.net ([185.95.218.216]:46796 "EHLO
        virtualmin.buehlmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932347AbcKPUcr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Nov 2016 15:32:47 -0500
Received: from [192.168.10.74] (46-126-153-42.dynamic.hispeed.ch [46.126.153.42])
        by virtualmin.buehlmann.net (Postfix) with ESMTPSA id 7F3521627F5
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Nov 2016 21:32:43 +0100 (CET)
Subject: Re: Send/receive snapshot from/between backup
References: <a58d070d-30f8-9abe-04cd-4cb4ba88697b@buehlmann.net>
 <7bc4c937-fbe6-2e0f-8f2c-471d6b9481ad@siedziba.pl>
From: =?UTF-8?B?UmVuw6kgQsO8aGxtYW5u?= <rene@buehlmann.net>
To: linux-btrfs@vger.kernel.org
Message-ID: <b7fae3c7-848e-f09b-4acd-1b9ce824ce99@buehlmann.net>
Date: Wed, 16 Nov 2016 21:32:42 +0100
MIME-Version: 1.0
In-Reply-To: <7bc4c937-fbe6-2e0f-8f2c-471d6b9481ad@siedziba.pl>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/02/2016 05:13 PM, Piotr Pawłow wrote:
> On 02.11.2016 15:23, René Bühlmann wrote:
>> Origin: S2 S3
>>
>> USB: S1 S2
>>
>> SSH: S1
>>
>> Transferring S3 to USB is no problem as S2 is on both btrfs drives. But
>> how can I transfer S3 to SSH?
> If I understand correctly how send / receive works, for the incremental
> receive to work there must be a subvolume on the destination which has
> "received uuid" equal to the uuid of parent choosen for the incremental
> send.
>
>> I tried to transfer...
>>
>> 1. S3 from Origin to SSH -> does not work as there is no common snapshot.
>>
>> 2. S2 from USB to SSH -> did not work.
> The "received uuid" of S1 on SSH is the uuid S1 had on Origin. The uuid
> of S1 on USB is different, so when choosen as parent for the incremental
> send it doesn't match.
>
>> 3. S1 from USB to Origin (such that there is a common snapshot with SSH)
>> -> did not work.
> There are no previously received subvolumes on Origin at all, so it
> isn't going to work.
>
>> Is it correct that 1. would work if a common snapshot is present on
>> Origin and SSH?
> If there was a snapshot received from Origin that still exists on
> Origin, then yes, you could use it as a clone source for incremental send.
>
>> Is it expected that 2. and 3. do not work?
>>
>> Is there some other way to achieve it?
> I doubt you can do it without some "hacking" to fool btrfs receive.
>
> You would need a tool that can issue BTRFS_IOC_SET_RECEIVED_SUBVOL ioctl
> to change the received uuid. Then you could:
>
> 1. Change received uuid of S1 on SSH to match S1 uuid on USB.
> 2. Send incremental S1-S2 from USB to SSH.
> 3. Change received uuid of S2 on SSH to match S2 on Origin.
> 4. Send incremental S2-S3 from Origin to SSH.
>
> Regards
>
Thanks for all the input,

I did successfully try this approach, could change the "received uuid"
and then transfer a snapshot from a different source. So far so good.

But:

Due to a lot of errors during btrfs check on SSH, I decided to recreate
the BTRFS filesystem on SSH still with the goal to not transfer all the
data over the network.

These were the steps:

1. Create a new btrfs (calling it SSH')

2. Full transfer S1 from SSH to SSH'

3. Incremental transfer S2 from USB to SSH' (S1 as parent)

4. Incremental transfer S3 from Origin to SSH' (S2 as parent)

5. Btrfs check SSH'

6. Used rsync (with checksum-diff) to verify that S3 on Origin and SSH'
contain the same files.


Step 2 did work and beside of a single checksum error on SSH the
transfer completed without errors.

Step 3 and 4 did work as well and surprisingly, I did not even had to
update the "received uuid". They cant be full transfers as that would
have taken months with my bandwidth. How can this be?

Step 5 did not return any errors

Step 6 did find a single file differing which is due to the checksum
error on step 2.


So, everything seems to be fine now, I just do not understand why this
did work without any updating of the UUID.
Do you have an explanation for that?

In any case, thanks for your help.
René


