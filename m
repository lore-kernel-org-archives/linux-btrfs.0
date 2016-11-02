Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from virtualmin.buehlmann.net ([185.95.218.216]:53816 "EHLO
        virtualmin.buehlmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753561AbcKBPPC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 11:15:02 -0400
Received: from [87.239.210.24] (nat13.ergon.ch [87.239.215.13])
        by virtualmin.buehlmann.net (Postfix) with ESMTPSA id 59CBD16202C
        for <linux-btrfs@vger.kernel.org>; Wed,  2 Nov 2016 16:14:56 +0100 (CET)
Subject: Re: Send/receive snapshot from/between backup
References: <a58d070d-30f8-9abe-04cd-4cb4ba88697b@buehlmann.net>
 <0db7a069-e29b-f548-969e-2fc8ad15f96a@mendix.com>
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?B?UmVuw6kgQsO8aGxtYW5u?= <rene@buehlmann.net>
Message-ID: <824b6cdc-a220-9137-7df4-eb3fd2ca66c7@buehlmann.net>
Date: Wed, 2 Nov 2016 16:14:55 +0100
MIME-Version: 1.0
In-Reply-To: <0db7a069-e29b-f548-969e-2fc8ad15f96a@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/02/2016 03:49 PM, Hans van Kranenburg wrote:
> On 11/02/2016 03:23 PM, René Bühlmann wrote:
>> I have a system running on btrfs which is backed up to two (one local
>> USB and one through SSH) external drives (also using btrfs) using
>> send/receive (with the help of btrbk). For each backup a snapshot is
>> created and transferred to the external drives. After some time, the
>> snapshot on the origin is removed but kept on the two backups.
>>
>> Now my problem is, that the SSH-drive has not received any snapshots for
>> some time such that there is no snapshot any more which is on the origin
>> AND the SSH-drive. I would like to prevent transferring a full snapshot
>> over the network and am now trying to work around it.
>>
>> Here the current situation (S? for a Snapshot):
>>
>> Origin: S2 S3
>>
>> USB: S1 S2
>>
>> SSH: S1
>>
>> Transferring S3 to USB is no problem as S2 is on both btrfs drives. But
>> how can I transfer S3 to SSH?
> Since there is no snapshot left that is present on both drives, you
> cannot use incremental send.
>
> btrbk does not remember what snapshots were last transferred or were
> present on the missing disk, since the tool does not do any extra meta
> administation on top of just having the snapshots on btrfs level. So
> it's figuring out the relationships between each of them (combining it
> with info from the remotes) again every time it runs.
Yes this explains why 1. did not work. But why can't I transfer S1 from
USB back to Origin as incremental to S2?
And why can't I transfer S2 from USB to SSH? Is S1 not recognized as the
same snapshot there?
>
>> I tried to transfer...
>>
>> 1. S3 from Origin to SSH -> does not work as there is no common snapshot.
>>
>> 2. S2 from USB to SSH -> did not work.
>>
>> 3. S1 from USB to Origin (such that there is a common snapshot with SSH)
>> -> did not work.
>>
>> Is it correct that 1. would work if a common snapshot is present on
>> Origin and SSH?
>>
>> Is it expected that 2. and 3. do not work?
>>
>> Is there some other way to achieve it?
> At home, I do a similar thing, I periodically send/receive changes of a
> filesystem to two external disks, also using btrbk. Since I don't want
> to have both backup disks and the originating filesystem all online and
> in the same geographical location at the same moment, I have the same
> problem.
>
> What I did is just setting expiry the snapshots on the origin manually,
> and keep the meta-administration in my head. I don't do it that often
> anyway.
>


