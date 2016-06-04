Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33806 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbcFDBsR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 21:48:17 -0400
Received: by mail-oi0-f45.google.com with SMTP id e72so153060631oib.1
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 18:48:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAD=QJKgqHBaUJXupFgzXR6jgC_LVacY4ZO58SYZOcmmfG_hdiA@mail.gmail.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
	<aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
	<CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com>
	<CAGQ70YdK0XZeDB_J7ugcQj-c=UPYimo=MUGPTNy8oOVpi8H9GA@mail.gmail.com>
	<156f60b2-d666-d553-194b-c09de041d476@gmail.com>
	<CAD=QJKgqHBaUJXupFgzXR6jgC_LVacY4ZO58SYZOcmmfG_hdiA@mail.gmail.com>
Date: Fri, 3 Jun 2016 19:48:15 -0600
Message-ID: <CAJCQCtTjB=Yf8kjASV+eEiL03NOsD-tZn3UN3aHSR2N73vVkkg@mail.gmail.com>
Subject: Re: Recommended why to use btrfs for production?
From: Chris Murphy <lists@colorremedies.com>
To: Nicholas D Steeves <nsteeves@gmail.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Martin <rc6encrypted@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 3, 2016 at 6:48 PM, Nicholas D Steeves <nsteeves@gmail.com> wrote:
> On 3 June 2016 at 11:33, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
>> On 2016-06-03 10:11, Martin wrote:
>>>>
>>>> Make certain the kernel command timer value is greater than the driver
>>>> error recovery timeout. The former is found in sysfs, per block
>>>> device, the latter can be get and set with smartctl. Wrong
>>>> configuration is common (it's actually the default) when using
>>>> consumer drives, and inevitably leads to problems, even the loss of
>>>> the entire array. It really is a terrible default.
>>>
>>>
>>> Are nearline SAS drives considered consumer drives?
>>>
>> If it's a SAS drive, then no, especially when you start talking about things
>> marketed as 'nearline'.  Additionally, SCT ERC is entirely a SATA thing, I
>> forget what the equivalent in SCSI (and by extension SAS) terms is, but I'm
>> pretty sure that the kernel handles things differently there.
>
> For the purposes of BTRFS RAID1: For drives that ship with SCT ERC of
> 7sec, is the default kernel command timeout of 30sec appropriate, or
> should it be reduced?

It's fine. But it depends on your use case, if it can tolerate a rare
> 7 second < 30 second hang, and you're prepared to start
investigating the cause then I'd leave it alone. If the use case
prefers resetting the drive when it stops responding, then you'd go
with something shorter.

I'm fairly certain SAS's command queue doesn't get obliterated with
such a link reset, just the hung command; where SATA drives all
information in the queue is lost. So resets on SATA are a much bigger
penalty if I have the correct understanding.


>  For SATA drives that do not support SC TERC, is
> it true that 120sec is a sane value?  I forget where I got this value
> of 120sec;

It's a good question. It's not well documented, is not defined in the
SATA spec, so it's probably make/model specific. The linux-raid@ list
probably has the most information on this just because their users get
nailed by this problem often. And the recommendation does seem to vary
around 120 to 180. That is of course a maximum. The drive could give
up much sooner. But what you don't want is for the drive to be in
recovery for a bad sector, and the command timer does a link reset,
losing all of what the drive was doing: all of which is replaceable
except really one thing which is what sector was having the problem.
And right now there's no report of the drive for slow sectors. It only
reports failed reads, and it's that failed read error that includes
the sector, so that the raid mechanism can figure out what data is
missing, recongistruct from mirror or parity, and then fix the bad
sector by writing to it.

> it might have been this list, it might have been an mdadm
> bug report.  Also, in terms of tuning, I've been unable to find
> whether the ideal kernel timeout value changes depending on RAID
> type...is that a factor in selecting a sane kernel timeout value?

No. It's strictly a value to make certain you get read errors from the
drive rather than link resets.

And that's why I think it's a bad default, because it totally thwarts
attempts by manufacturers to recover marginal sectors, even in the
single disk case.


-- 
Chris Murphy
