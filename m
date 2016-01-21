Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34328 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759857AbcAURPP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jan 2016 12:15:15 -0500
Received: by mail-ig0-f179.google.com with SMTP id ik10so128417586igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Jan 2016 09:15:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_=0Fu96a=SZwYkkV7Ukk7Jc_8c6sn8ZeiacocTcRbMp8w@mail.gmail.com>
References: <alpine.OSX.2.20.1601190308520.34954@ioko>
	<CAGfcS_=0Fu96a=SZwYkkV7Ukk7Jc_8c6sn8ZeiacocTcRbMp8w@mail.gmail.com>
Date: Thu, 21 Jan 2016 10:15:14 -0700
Message-ID: <CAJCQCtTSHepYgTxiJ49wPsrO0Hh-NFEcxbo6DzG7XyFyi9ySSg@mail.gmail.com>
Subject: Re: FS corruption when mounting non-degraded after mounting degraded
From: Chris Murphy <lists@colorremedies.com>
To: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
Cc: Rian Hunter <rian@thelig.ht>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 21, 2016 at 9:26 AM, Rich Freeman
<r-btrfs@thefreemanclan.net> wrote:
> On Tue, Jan 19, 2016 at 6:28 AM, Rian Hunter <rian@thelig.ht> wrote:
>> In my raid6 setup, a disk was soft-failing on me. I pulled the disk,
>> inserted a new one, mounted degraded, then did btrfs-replace while running
>> some RW jobs on the FS.
>>
>> My jobs were taking too long. It seems like raid6 btrfs-replace without the
>> source disk is not very fast. So I unmounted the FS, inserted the
>> soft-failing disk again, remounted normally (non-degraded) and restarted the
>> (now much faster) btrfs-replace.
>>
>> I checked on the status sometime later and there were hundreds if not
>> thousands of "transid verify failure" messages in my dmesg. Additionally the
>> btrfs-replace operation had outright failed.
>>
>
> I think the bottom line here is the same thing that everybody runs
> into when they have LVM snapshots of btrfs devices.

Seems unrelated. The LVM and dd concern is an *identical* member
device appearing (two or more instances of the same volume UUID and
dev UUID). In this case it's a member device with a (truly) unique dev
UUID. So there should be no such confusion.


>
> Btrfs doesn't record any kind of timestamp or generation number of
> anything like that when it touches data on a drive, or if it does it
> isn't granular enough or it isn't being used when mounting drives to
> ensure consistency.

Except it does.

And the superblock on every device includes the dev UUID of all other
devices. So even with a device missing, or a device missing and
reappearing while that same device is being replaced, the file system
has information available.

While a member device is being replaced, it isn't invalid. It's still
available for reading from for its own replacement. Hence why 'btrfs
replace start' has an -r option. So it makes sense that the rebuild
goes faster once it's reconnected, because now that drive is available
for normal reads, the volume isn't degraded anymore, so data doesn't
have to be reconstructed from parity.

But none of this explains why corruption happened. So I'd say it's a
bug. The question is, is it discretely reproducible? Once there's
concise reproduce steps, it's much more likely a dev can reproduce and
debug what the problem is.

Maybe there's a problem where the reintroduction of a previously
missing device in the middle of being replaced. The devid is different
from dev.uuid, but they are mapped somehow, and mainly it's the devid
being used by the filesystem chunk tree. So maybe confusion happens
where there are suddenly two devid 2, even though they have different
dev UUID.

-- 
Chris Murphy
