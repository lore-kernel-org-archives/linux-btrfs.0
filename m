Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35220 "EHLO
	mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbbLTWcz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Dec 2015 17:32:55 -0500
Received: by mail-io0-f193.google.com with SMTP id o67so12625861iof.2
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Dec 2015 14:32:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR7B7h0+CKdpRT2KuZP-Bdzv3j0zPWD6s5MMMs7apTCOg@mail.gmail.com>
References: <CAJCQCtSQUu8c-eG01tJwwUzC9jONuuaVRTpyLLDCK-gwEE6hUg@mail.gmail.com>
	<566E584B.5040104@cn.fujitsu.com>
	<CAJCQCtRzQ=9NbaaajPuoP2KOCvOd_rFT6P990aU=-EOo8dKS1A@mail.gmail.com>
	<566E77FA.3050405@cn.fujitsu.com>
	<CAJCQCtR7B7h0+CKdpRT2KuZP-Bdzv3j0zPWD6s5MMMs7apTCOg@mail.gmail.com>
Date: Sun, 20 Dec 2015 15:32:54 -0700
Message-ID: <CAJCQCtR11LLQnXdsb3Y4KFfVf6zj6ta1kFrgieiUtEq+ZBud_A@mail.gmail.com>
Subject: Re: btrfs check inconsistency with raid1, part 1
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 14, 2015 at 10:59 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Mon, Dec 14, 2015 at 1:04 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>>
>> Chris Murphy wrote on 2015/12/14 00:24 -0700:
>>> What is a full disk dump? I can try to see if it's possible.
>>
>>
>> Just a dd dump.
>
> OK, yeah. That's 750GB per drive.
>
>>t won't be an easy
>> thing to find a place to upload them.
>
> Right. I have no ideas. I'll give you the rest of what you asked for,
> and won't do the rw mount yet in case you need more.
>
>
>> Got the result, and things is very interesting.
>>
>> It seems all these tree blocks (search by the bytenr) shares the same crc32
>> by coincidence.
>> Or we won't be able to read them all (and their contents all seems valid).
>>
>>
>> I hope if I can have some raw blocks dump of that bytenr.
>> Here is the procedure:
>> $ btrfs-map-logical -l <LOGICAL> -n 16384 -c 2 <DEVICE1or2>
>> mirror 1 logical <LOGICAL> physical XXXXXXXX device <DEVICE1>
>> mirror 2 logical <LOGICAL> physical YYYYYYYY device <DEVICE2>
>
> Option -n is invalid, I'll use option -b.
>
> ##btrfs fi show has this mapping, seems opposite from
> btrfs-map-logical (although it uses the term mirror rather than
> devid). So I will use devid and ignore mirror number.
> /dev/sdb = devid1
> /dev/sdc = devid2
>
>
> # btrfs-map-logical -l 714189357056 -b 16384 -c 2 /dev/sdb
> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
> mirror 1 logical 714189357056 physical 356605018112 device /dev/sdc
> mirror 2 logical 714189357056 physical 3380658176 device /dev/sdb
>
>
>
> # btrfs-map-logical -l 714189471744 -b 16384 -c 2 /dev/sdb
> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
> checksum verify failed on 714189357056 found E4E3BDB6 wanted 00000000
> mirror 1 logical 714189471744 physical 356605132800 device /dev/sdc
> mirror 2 logical 714189471744 physical 3380772864 device /dev/sdb
>
>
>>
>> $ dd if=<DEVICE1> of=dev1_<LOGICAL>.img bs=1 count=16384 skip=XXXXXXX
>> $ dd if=<DEVICE2> of=dev2_<LOGICAL>.img bs=1 count=16384 skip=YYYYYYY
>>
>> In your output, there are 12 different bytenr, but the most interesting ones
>> are *714189357056* and *714189471744*.
>
>
> dd if=/dev/sdb of=dev1_714189357056.img bs=1 count=16384 skip=3380658176
> dd if=/dev/sdc of=dev2_714189357056.img bs=1 count=16384 skip=356605018112
>
> dd if=/dev/sdb of=dev1_714189471744.img bs=1 count=16384 skip=3380772864
> dd if=/dev/sdc of=dev2_714189471744.img bs=1 count=16384 skip=356605132800
>
> Files are attached to this email.
>

Hi Qu, any insight with these attachements?

I will likely try a normal rw mount once 4.4.0rc6 is done and built in
Fedora's koji (24-48 hours). If that goes OK I'll try some reads and
see if that triggers any problems, and if there are no problems then
I'll do some writes and see if the two device generations end up back
in sync. If there continue to be no complaints, I'll do a scrub and
we'll see if that notices anything or fixes things or what.

I think the cause is related to bus power with buggy USB 3 LPM
firmware (these enclosures are cheap maybe $6). I've found some
threads about this being a problem, but it's not expected to cause any
corruptions. So, the fact Btrfs picks up one some problems might prove
that (somewhat) incorrect.

http://permalink.gmane.org/gmane.linux.usb.general/105502
http://www.spinics.net/lists/linux-usb/msg108949.html

I have the same exactly enclosure mentioned in the 2nd link (which is
the last email in the thread, with no real resolution). The usb reset
messages never happen when the same enclosure+drive is attached to a
1.5A USB connector on the NUC. It only happens (with two of the same
model enclosures with different drive make/models) on the standard USB
connectors on the Intel NUC. But I have a hard time believing a laptop
drive needs more than 900mA continuously, rather than just at spin up
time.



-- 
Chris Murphy
