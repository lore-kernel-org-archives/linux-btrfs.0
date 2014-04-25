Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54225 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750897AbaDYHCj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 03:02:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wda9d-00089h-QW
	for linux-btrfs@vger.kernel.org; Fri, 25 Apr 2014 09:02:37 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 09:02:37 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 09:02:37 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
 newer?
Date: Fri, 25 Apr 2014 07:02:21 +0000 (UTC)
Message-ID: <pan$282b2$5991d930$3e5bf99$a27adcf2@cox.net>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
	<20140423185413.GF26949@merlins.org>
	<001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info>
	<20140423191546.GG26949@merlins.org>
	<000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info>
	<20140424173317.GI7884@merlins.org>
	<002301cf5fee$346fefc0$9d4fcf40$@petrovi.no-ip.info>
	<8953EAE6-E8DD-40DC-B485-128BE7CB4BA1@colorremedies.com>
	<000c01cf600b$b01f6cf0$105e46d0$@petrovi.no-ip.info>
	<20140424230704.GK7884@merlins.org>
	<F6EDB160-FCC5-4D1C-A5A8-AAADE5C803F6@colorremedies.com>
	<5359A77C.70209@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason posted on Thu, 24 Apr 2014 20:08:28 -0400 as excerpted:

> On 04/24/2014 08:04 PM, Chris Murphy wrote:

>> So I don't think the order is it. The biggest difference I'm seeing
>> between the 3.13.11 and 3.14.1 dmesg's provided:
>>
>> 3.13.11:
>> [    1.861740] bio: create slab <bio-1> at 1 [    1.863389] Btrfs
>> loaded
>>
>> 3.14.1:
>> [    3.949312] bio: create slab <bio-1> at 1 [    3.950942] Btrfs
>> loaded
>>
>> It's happening much later, and it's right at this point VFS complains:
>> [    4.182603] VFS: Cannot open root device "sda2" or
>> unknown-block(8,2): error -38
>>
>> The 8,2 message is consistent with the kernel not knowing what file
>> system sda2 is. Seems like it's saying "I see sda2, I know you want to
>> use it as root, but I don't know what's there - *poof*" and it panics.

That's what I'm thinking too...

>> I vaguely recall there recently being btrfs boot problems with the
>> module compiled in…
>>
> Yes, it was with the crc code.  I noticed he has compression on and I'm
> wondering if we're hitting a similar ordering problem with the zlib
> init.

Everyone:  I didn't think of this earlier, when I first saw the thread, 
but coming home and catching up after work, I think my subconscious must 
have been working on it all day, and even before I read this message, I 
was wondering if it might be another variant of that CRC32 problem.  I 
was impatiently going thru the messages to see if someone mentioned it 
before I started another subthread on it... and here it is. =:^

But both crc32 and crc32c are loaded at about the same point in both 
kernels, before the filesystem tries to load, so that can't be it.

But your zlib theory looks like a good candidate, Chris (Mason), and my 
sysadmin's intuition is behaving like a Geiger counter at Fukishima ATM, 
so I think we're on the right track! =:^)

> The best way to know for sure is to please try with an initrd.  If that
> does work we'll know it's an init ordering problem and we can track it
> down from there.

Indeed, altho as I know from experience, reading/writing that is a lot 
easier than actually setting up an initr*, if you've not used one in a 
decade and haven't the foggiest how to create one.  (Being a gentooer 
here, I ended up following a recommendation from an only semi-related 
gentoo discussion, and setting up dracut for my initr* when I needed one 
to support a multi-device btrfs rootfs.  Wasn't too hard, but I did need 
to set aside some undisturbed time to study up on it and get it 
configured and working.  Since this thread's about a single-device btrfs 
rootfs, he got away without one until now, but...)

Meanwhile, if an initr* bypasses the issue, the fact that I'm running a 
multi-device btrfs root here, and thus an initr*, would explain why I 
hadn't run into the problem, here...  There goes that Geiger counter 
again!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

