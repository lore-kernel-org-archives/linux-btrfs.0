Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f195.google.com ([209.85.217.195]:35999 "EHLO
	mail-lb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbcEPLeJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 May 2016 07:34:09 -0400
Received: by mail-lb0-f195.google.com with SMTP id le2so6963546lbc.3
        for <linux-btrfs@vger.kernel.org>; Mon, 16 May 2016 04:34:08 -0700 (PDT)
Subject: Re: fsck: to repair or not to repair
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Nikolaus Rath <Nikolaus@rath.org>
References: <87y47g1esh.fsf@thinkpad.rath.org>
 <CAPmG0jYDw8Sid2jORVtfwNLpeZPAqtH429EQsraz9GzNdK1aUQ@mail.gmail.com>
 <pan$14f07$a448b38$b8e37f4a$116d54ce@cox.net>
 <87vb2ij7u5.fsf@vostro.rath.org>
 <CAJCQCtRs6VhRDFT6PvD4LkKYvtMero7UBs6Gd-XtjHLqwBe-5Q@mail.gmail.com>
 <60824d00-56c4-8f83-34e2-07fc99ca3c8b@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <5739B02D.2020203@gmail.com>
Date: Mon, 16 May 2016 14:34:05 +0300
MIME-Version: 1.0
In-Reply-To: <60824d00-56c4-8f83-34e2-07fc99ca3c8b@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

16.05.2016 14:17, Austin S. Hemmelgarn пишет:
> On 2016-05-13 17:35, Chris Murphy wrote:
>> On Fri, May 13, 2016 at 9:28 AM, Nikolaus Rath <Nikolaus@rath.org> wrote:
>>> On May 13 2016, Duncan <1i5t5.duncan@cox.net> wrote:
>>>> Because btrfs can be multi-device, it needs some way to track which
>>>> devices belong to each filesystem, and it uses filesystem UUID for this
>>>> purpose.
>>>>
>>>> If you clone a filesystem (for instance using dd or lvm snapshotting,
>>>> doesn't matter how) and then trigger a btrfs device scan, say by
>>>> plugging
>>>> in some other device with btrfs on it so udev triggers a scan, and the
>>>> kernel sees multiple devices with the same filesystem UUID as a result,
>>>> and one of those happens to be mounted, you can corrupt both copies as
>>>> the kernel btrfs won't be able to tell them apart and may write updates
>>>> to the wrong one.
>>>
>>> That seems like a rather odd design. Why isn't btrfs refusing to mount
>>> in this situation? In the face of ambiguity, guessing is generally bad
>>> idea (at least for a computer program).
>>
>> The logic  you describe requires code. It's the absence of code rather
>> than an intentional design that's the cause of the current behavior.
>> And yes, it'd be nice if Btrfs weren't stepping on its own tail in
>> this situation. It could be as simple as refusing to mount anytime
>> there's an ambiguity, but that's sorta user hostile if there isn't a
>> message that goes along with it to help the user figure out a way to
>> resolve the problem. And that too could be fraught with peril if the
>> user makes a mistake. So, really what's the right way to do this is
>> part of the problem but I agree it's better to be hostile and refuse
>> to mount a given volume UUID at all when too many devices are found,
>> than corrupt the file system.
>>
> FWIW, the behavior I'd expect from a sysadmin perspective would be:
> 1. If and only if a correct number of device= options have been passed
> to mount, use those devices (and only those devices), and log a warning
> if extra devices are detected.

First, how do you know that devices, passed as device= options, are
correct? Is it possible to detect stale copy?

Second, today udev rules will run equivalent of "btrfs device ready" for
each device that is part of btrfs. So you still need to handle the
situation when device(s) appear and disappear after initial mount and
have some way to distinguish between two copies.

Third, what exactly "extra devices detected" means? Who is responsible
for detection? Where this information is kept? How can mount query this
information?

> 2. Otherwise, refuse to mount and log a warning.

So no way to mount degraded redundant filesystem?
