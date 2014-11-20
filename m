Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:47076 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbaKTAFP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Nov 2014 19:05:15 -0500
Received: by mail-yh0-f53.google.com with SMTP id i57so822475yha.12
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Nov 2014 16:05:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <546CB332.3080705@ubuntu.com>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
	<546AF572.2020101@swiftspirit.co.za>
	<20141118153526.GS20972@merlins.org>
	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>
	<546BB2EA.5080809@ubuntu.com>
	<E47EA20E-375D-49A6-B4B0-C6594CE6A633@colorremedies.com>
	<546CB332.3080705@ubuntu.com>
Date: Wed, 19 Nov 2014 17:05:14 -0700
Message-ID: <CAJCQCtTfhxW2w+mT6rqyr+WwVdj8SAEAGV+LB8_S3mcw0agxaw@mail.gmail.com>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 19, 2014 at 8:11 AM, Phillip Susi <psusi@ubuntu.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 11/18/2014 9:40 PM, Chris Murphy wrote:
>> It’s well known on linux-raid@ that consumer drives have well over
>> 30 second "deep recoveries" when they lack SCT command support. The
>> WDC and Seagate “green” drives are over 2 minutes apparently. This
>> isn’t easy to test because it requires a sector with enough error
>> that it requires the ECC to do something, and yet not so much error
>> that it gives up in less than 30 seconds. So you have to track down
>> a drive model spec document (one of those 100 pagers).
>>
>> This makes sense, sorta, because the manufacturer use case is
>> typically single drive only, and most proscribe raid5/6 with such
>> products. So it’s a “recover data at all costs” behavior because
>> it’s assumed to be the only (immediately) available copy.
>
> It doesn't make sense to me.  If it can't recover the data after one
> or two hundred retries in one or two seconds, it can keep trying until
> the cows come home and it just isn't ever going to work.

I'm not a hard drive engineer, so I can't argue either point. But
consumer drives clearly do behave this way. On Linux, the kernel's
default 30 second command timer eventually results in what look like
link errors rather than drive read errors. And instead of the problems
being fixed with the normal md and btrfs recovery mechanisms, the
errors simply get worse and eventually there's data loss. Exhibits A,
B, C, D - the linux-raid list is full to the brim of such reports and
their solution.

>
>> I don’t see how that’s possible because anything other than the
>> drive explicitly producing  a read error (which includes the
>> affected LBA’s), it’s ambiguous what the actual problem is as far
>> as the kernel is concerned. It has no way of knowing which of
>> possibly dozens of ata commands queued up in the drive have
>> actually hung up the drive. It has no idea why the drive is hung up
>> as well.
>
> IIRC, this is true when the drive returns failure as well.  The whole
> bio is marked as failed, and the page cache layer then begins retrying
> with progressively smaller requests to see if it can get *some* data out.

Well that's very course. It's not at a sector level, so as long as the
drive continues to try to read from a particular LBA, but fails to
either succeed reading or give up and report a read error, within 30
seconds, then you just get a bunch of wonky system behavior.

Conversely what I've observed on Windows in such a case, is it
tolerates these deep recoveries on consumer drives. So they just get
really slow but the drive does seem to eventually recover (until it
doesn't). But yeah 2 minutes is a long time. So then the user gets
annoyed and reinstalls their system. Since that means writing to the
affected drive, the firmware logic causes bad sectors to be
dereferenced when the write error is persistent. Problem solved,
faster system.



>
>> No I think 30 is pretty sane for servers using SATA drives because
>> if the bus is reset all pending commands in the queue get
>> obliterated which is worse than just waiting up to 30 seconds. With
>> SAS drives maybe less time makes sense. But in either case you
>> still need configurable SCT ERC, or it needs to be a sane fixed
>> default like 70 deciseconds.
>
> Who cares if multiple commands in the queue are obliterated if they
> can all be retried on the other mirror?

Because now you have a member drive that's inconsistent. At least in
the md raid case, a certain number of read failures causes the drive
to be ejected from the array. Anytime there's a write failure, it's
ejected from the array too. What you want is for the drive to give up
sooner with an explicit read error, so md can help fix the problem by
writing good data to the effected LBA. That doesn't happen when there
are a bunch of link resets happening.


> Better to fall back to the
> other mirror NOW instead of waiting 30 seconds ( or longer! ).  Sure,
> you might end up recovering more than you really had to, but that
> won't hurt anything.

Again, if your drive SCT ERC is configurable, and set to something
sane like 70 deciseconds, that read failure happens at MOST 7 seconds
after the read attempt. And md is notified of *exactly* what sectors
are affected, it immediately goes to mirror data, or rebuilds it from
parity, and then writes the correct data to the previously reported
bad sectors. And that will fix the problem.

So really, if you're going to play the multiple device game, you need
drive error timing to be shorter than the kernel's.



Chris Murphy
