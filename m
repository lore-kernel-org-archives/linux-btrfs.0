Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39171 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab3KJPnQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Nov 2013 10:43:16 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VfXAP-0001zO-Hv
	for linux-btrfs@vger.kernel.org; Sun, 10 Nov 2013 16:43:13 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 16:43:13 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Nov 2013 16:43:13 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Fwd: unable to delete files after kernel upgrade from 3.8.10 to
 3.12
Date: Sun, 10 Nov 2013 15:42:53 +0000 (UTC)
Message-ID: <pan$db67$dd5d03d8$5d8b6d6f$728d89d1@cox.net>
References: <CAMajw1N4bqFyHA4V8SkEzQFZF8adN0xQDShRq7bC2Of+nxsJGA@mail.gmail.com>
	<CAMajw1MVmO5dbkDB7Wj1J-O0mTE-q6xyo1Do83gQk8RLX2dnpQ@mail.gmail.com>
	<CAMajw1O4-zrfxYgxeZaTNwtgY-_zTUpBbiLSExkcmwuyU5x+mw@mail.gmail.com>
	<201311110010.36848.russell@coker.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Russell Coker posted on Mon, 11 Nov 2013 00:10:36 +1100 as excerpted:

> On Thu, 7 Nov 2013, Bartosz Kulicki <bartosz.kulicki@gmail.com> wrote:
>> FWIW - just before nuking the fs I have added a 3GB loopback device to
>> btrfs.
>> 
>> This restored ability to delete the files but I could not remove the
>> loopback after deleting some large files (if I remember correctly error
>> I got was "block device required")
> 
> I once had a problem where I added a second block device and started a
> balance.  But for some reason the balance decided to make metadata a
> RAID-1 and even when there was enough space I couldn't remove it (you
> must have 2 devices for RAID-1).
> 
> So I added a third device, that allowed me to delete the second device
> which made the meta-data no longer RAID-1 and I could then delete the
> third device and have the single-device BTRFS filesystem I wanted.
> 
> That was a while ago, maybe running kernel 3.10 or 3.8.

Hmm... Very good point that I guess the classic "add a device to get out 
of the jam" recommendation doesn't cover, without a more complex 
explanation, at least!  Thanks for bringing it up!

For safety reasons btrfs (almost[1]) always defaults to two copies of 
metadata.  On a single device, that's DUP mode, two copies obviously on 
the same device.  But with two or more devices it'll default metadata to 
raid1 mode, trying to keep one copy of metadata on each of two different 
devices thus allowing the chance to recover at least the data that's on 
surviving drives in the event of a failure.

So if there's only a single existing device and the "add-a-device-to-get-
out-of-the-jam" method is used, either adding a /third/ device may be 
needed (your solution), or alternatively, doing the balance using options 
to force single mode may be necessary:

btrfs balance -mconvert=single -f <path>

Or possibly -mconvert=dup, to force metadata to stay dup mode, but I'm 
not sure without trying it whether dup will work on more than a single 
device.

---
[1] The exception is SSD, I believe only with a single device, where 
SINGLE mode is the default because some SSDs automatically dedup in any 
case, so even DUP mode would only actually be physically stored only 
once, second-guessing btrfs' efforts to keep two separate copies.  I'm 
not sure why the dedup feature changes the default for /all/ ssds as it 
seems to me SSDs without that feature should arguably still get DUP by 
default which means it's a bad exception, do DUP regardless and if the 
hardware dedups let the hardware dedup seems more reasonable, but that's 
what's documented.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

