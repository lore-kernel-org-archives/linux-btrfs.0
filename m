Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:32798 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaKYXNu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 18:13:50 -0500
Received: by mail-yk0-f174.google.com with SMTP id 10so760451ykt.5
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 15:13:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5474F5D1.2070908@ubuntu.com>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
	<546AF572.2020101@swiftspirit.co.za>
	<20141118153526.GS20972@merlins.org>
	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>
	<546BB2EA.5080809@ubuntu.com>
	<E47EA20E-375D-49A6-B4B0-C6594CE6A633@colorremedies.com>
	<546CB332.3080705@ubuntu.com>
	<CAJCQCtTfhxW2w+mT6rqyr+WwVdj8SAEAGV+LB8_S3mcw0agxaw@mail.gmail.com>
	<5474F5D1.2070908@ubuntu.com>
Date: Tue, 25 Nov 2014 16:13:50 -0700
Message-ID: <CAJCQCtSYFBj=KLZpdB5J+mXZwE5SCAR-H9mz5BXpsukOOp8SZQ@mail.gmail.com>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25, 2014 at 2:34 PM, Phillip Susi <psusi@ubuntu.com> wrote:

> I have seen plenty of error logs of people with drives that do
> properly give up and return an error instead of timing out so I get
> the feeling that most drives are properly behaved.  Is there a
> particular make/model of drive that is known to exhibit this silly
> behavior?

The drive will only issue a read error when its ECC absolutely cannot
recover the data, hard fail.

A few years ago companies including Western Digital started shipping
large cheap drives, think of the "green" drives. These had very high
TLER (Time Limited Error Recovery) settings, a.k.a. SCT ERC. Later
they completely took out the ability to configure this error recovery
timing so you only get the upward of 2 minutes to actually get a read
error reported by the drive. Presumably if the ECC determines it's a
hard fail and no point in reading the same sector 14000 times, it
would issue a read error much sooner. But again, the linux-raid list
if full of cases where this doesn't happen, and merely by changing the
linux SCSI command timer from 30 to 121 seconds, now the drive reports
an explicit read error with LBA information included, and now md can
correct the problem.




>
>>> IIRC, this is true when the drive returns failure as well.  The
>>> whole bio is marked as failed, and the page cache layer then
>>> begins retrying with progressively smaller requests to see if it
>>> can get *some* data out.
>>
>> Well that's very course. It's not at a sector level, so as long as
>> the drive continues to try to read from a particular LBA, but fails
>> to either succeed reading or give up and report a read error,
>> within 30 seconds, then you just get a bunch of wonky system
>> behavior.
>
> I don't understand this response at all.  The drive isn't going to
> keep trying to read the same bad lba; after the kernel times out, it
> resets the drive, and tries reading different smaller parts to see
> which it can read and which it can't.

That's my whole point. When the link is reset, no read error is
submitted by the drive, the md driver has no idea what the drive's
problem was, no idea that it's a read problem, no idea what LBA is
affected, and thus no way of writing over the affected bad sector. If
the SCSI command timer is raised well above 30 seconds, this problem
is resolved. Also replacing the drive with one that definitively
errors out (or can be configured with smartctl -l scterc) before 30
seconds is another option.


>
>> Conversely what I've observed on Windows in such a case, is it
>> tolerates these deep recoveries on consumer drives. So they just
>> get really slow but the drive does seem to eventually recover
>> (until it doesn't). But yeah 2 minutes is a long time. So then the
>> user gets annoyed and reinstalls their system. Since that means
>> writing to the affected drive, the firmware logic causes bad
>> sectors to be dereferenced when the write error is persistent.
>> Problem solved, faster system.
>
> That seems like rather unsubstantiated guesswork.  i.e. the 2 minute+
> delays are likely not on an individual request, but from several
> requests that each go into deep recovery, possibly because windows is
> retrying the same sector or a few consecutive sectors are bad.

It doesn't really matter, clearly its time out for drive commands is
much higher than the linux default of 30 seconds.

>
>> Because now you have a member drive that's inconsistent. At least
>> in the md raid case, a certain number of read failures causes the
>> drive to be ejected from the array. Anytime there's a write
>> failure, it's ejected from the array too. What you want is for the
>> drive to give up sooner with an explicit read error, so md can help
>> fix the problem by writing good data to the effected LBA. That
>> doesn't happen when there are a bunch of link resets happening.
>
> What?  It is no different than when it does return an error, with the
> exception that the error is incorrectly applied to the entire request
> instead of just the affected sector.

OK that doesn't actually happen and it would be completely f'n wrong
behavior if it were happening. All the kernel knows is the command
timer has expired, it doesn't know why the drive isn't responding. It
doesn't know there are uncorrectable sector errors causing the
problem. To just assume link resets are the same thing as bad sectors
and to just wholesale start writing possibly a metric shit ton of data
when you don't know what the problem is would be asinine. It might
even be sabotage. Jesus...




>
>> Again, if your drive SCT ERC is configurable, and set to something
>> sane like 70 deciseconds, that read failure happens at MOST 7
>> seconds after the read attempt. And md is notified of *exactly*
>> what sectors are affected, it immediately goes to mirror data, or
>> rebuilds it from parity, and then writes the correct data to the
>> previously reported bad sectors. And that will fix the problem.
>
> Yes... I'm talking about when the drive doesn't support that.

Then there is one option which is to increase the value of the SCSI
command timer. And that applies to all raid: md, lvm, btrfs, and
hardware.




-- 
Chris Murphy
