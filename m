Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63064 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbaAVVGS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jan 2014 16:06:18 -0500
Received: by mail-pd0-f173.google.com with SMTP id y10so878842pdj.4
        for <linux-btrfs@vger.kernel.org>; Wed, 22 Jan 2014 13:06:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1390423628.1198.49.camel@ret.masoncoding.com>
References: <95DB9BB3-D706-4023-940A-D100D93D560A@gmail.com>
	<pan$226f4$e1329373$53c2dcca$438e95e@cox.net>
	<1390423628.1198.49.camel@ret.masoncoding.com>
Date: Wed, 22 Jan 2014 13:06:17 -0800
Message-ID: <CAN05THQP_BZR5r6DC8NVk0XLv8BcoZjuYAuMU=+Z6fsdBBHcyA@mail.gmail.com>
Subject: Re: Scrubbing with BTRFS Raid 5
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: "1i5t5.duncan@cox.net" <1i5t5.duncan@cox.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 22, 2014 at 12:45 PM, Chris Mason <clm@fb.com> wrote:
> On Tue, 2014-01-21 at 17:08 +0000, Duncan wrote:
>> Graham Fleming posted on Tue, 21 Jan 2014 01:06:37 -0800 as excerpted:
>>
>> > Thanks for all the info guys.
>> >
>> > I ran some tests on the latest 3.12.8 kernel. I set up 3 1GB files and
>> > attached them to /dev/loop{1..3} and created a BTRFS RAID 5 volume with
>> > them.
>> >
>> > I copied some data (from dev/urandom) into two test files and got their
>> > MD5 sums and saved them to a text file.
>> >
>> > I then unmounted the volume, trashed Disk3 and created a new Disk4 file,
>> > attached to /dev/loop4.
>> >
>> > I mounted the BTRFS RAID 5 volume degraded and the md5 sums were fine. I
>> > added /dev/loop4 to the volume and then deleted the missing device and
>> > it rebalanced. I had data spread out on all three devices now. MD5 sums
>> > unchanged on test files.
>> >
>> > This, to me, implies BTRFS RAID 5 is working quite well and I can in
>> > fact,
>> > replace a dead drive.
>> >
>> > Am I missing something?
>>
>> What you're missing is that device death and replacement rarely happens
>> as neatly as your test (clean unmounts and all, no middle-of-process
>> power-loss, etc).  You tested best-case, not real-life or worst-case.
>>
>> Try that again, setting up the raid5, setting up a big write to it,
>> disconnect one device in the middle of that write (I'm not sure if just
>> dropping the loop works or if the kernel gracefully shuts down the loop
>> device), then unplugging the system without unmounting... and /then/ see
>> what sense btrfs can make of the resulting mess.  In theory, with an
>> atomic write btree filesystem such as btrfs, even that should work fine,
>> minus perhaps the last few seconds of file-write activity, but the
>> filesystem should remain consistent on degraded remount and device add,
>> device remove, and rebalance, even if another power-pull happens in the
>> middle of /that/.
>>
>> But given btrfs' raid5 incompleteness, I don't expect that will work.
>>
>
> raid5/6 deals with IO errors from one or two drives, and it is able to
> reconstruct the parity from the remaining drives and give you good data.
>
> If we hit a crc error, the raid5/6 code will try a parity reconstruction
> to make good data, and if we find good data from the other copy, it'll
> return that up to userland.
>
> In other words, for those cases it works just like raid1/10.  What it
> won't do (yet) is write that good data back to the storage.  It'll stay
> bad until you remove the device or run balance to rewrite everything.
>
> Balance will reconstruct parity to get good data as it balances.  This
> isn't as useful as scrub, but that work is coming.
>

That is awesome!

What about online conversion from not-raid5/6 to raid5/6  what is the
status for that code, for example
what happens if there is a failure during the conversion or a reboot ?



> -chris
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
