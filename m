Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51513 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370AbaGVCv3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 22:51:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1X9QAp-0001dC-JS
	for linux-btrfs@vger.kernel.org; Tue, 22 Jul 2014 04:51:27 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jul 2014 04:51:27 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Jul 2014 04:51:27 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
Date: Tue, 22 Jul 2014 02:51:13 +0000 (UTC)
Message-ID: <pan$6f72e$34416d71$688a2a2$980c8acd@cox.net>
References: <loom.20140720T102642-239@post.gmane.org>
	<53CC1553.1020908@shiftmail.org> <20140721013609.6d99c399@natsu>
	<37e3a8cf8b7439d5cd2745b5efb9d37f.squirrel@webmail.wanet.net>
	<pan$7b757$4788e010$b65976c7$4d1c0bad@cox.net>
	<CAN05THTSG9czwpM7AYEPWg5hpZuJ=vjJrjz8yn5V0rXe5oguxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

ronnie sahlberg posted on Mon, 21 Jul 2014 09:46:07 -0700 as excerpted:

> On Sun, Jul 20, 2014 at 7:48 PM, Duncan <1i5t5.duncan@cox.net> wrote:
>> ashford posted on Sun, 20 Jul 2014 12:59:21 -0700 as excerpted:
>>
>>> If you assume a 12ms average seek time (normal for 7200RPM SATA
>>> drives), an 8.3ms rotational latency (half a rotation), an average
>>> 64kb write and a 100MB/S streaming write speed, each write comes in
>>> at ~21ms, which gives us ~47 IOPS.  With the 64KB write size, this
>>> comes out to ~3MB/S, DISK LIMITED.
>>
>>> The 5MB/S that TM is seeing is fine, considering the small files he
>>> says he has.
>>
> That is actually nonsense.
> Raid rebuild operates on the block/stripe layer and not on the
> filesystem layer.

If we were talking about a normal raid, yes.  But we're talking about 
btrFS, note the FS for filesystem, so indeed it *IS* the filesystem 
layer.  Now this particular "filesystem" /does/ happen to have raid 
properties as well, but it's definitely filesystem level...

> It does not matter at all what the average file size is.

... and the filesize /does/ matter.

> Raid rebuild is really only limited by disk i/o speed when performing a
> linear read of the whole spindle using huge i/o sizes,
> or, if you have multiple spindles on the same bus, the bus saturation
> speed.

Makes sense... if you're dealing at the raid level.  If we were talking 
about dmraid or mdraid... and they're both much more mature and 
optimized, as well, so 50 MiB/sec, per spindle in parallel, would indeed 
be a reasonable expectation for them.

But (barring bugs, which will and do happen at this stage of development) 
btrfs both makes far better data validity guarantees, and does a lot more 
complex processing what with COW and snapshotting, etc, of course in 
addition to the normal filesystem level stuff AND the raid-level stuff it 
does.

> Thus is is perfectly reasonabe to expect ~50MByte/second, per spindle,
> when doing a raid rebuild.

... And perfectly reasonable, at least at this point, to expect ~5 MiB/
sec total thruput, one spindle at a time, for btrfs.

> That is for the naive rebuild that rebuilds every single stripe. A
> smarter rebuild that knows which stripes are unused can skip the unused
> stripes and thus become even faster than that.
> 
> 
> Now, that the rebuild is off by an order of magnitude is by design but
> should be fixed at some stage, but with the current state of btrfs it is
> probably better to focus on other more urgent areas first.

Because of all the extra work it does, btrfs may never get to full 
streaming speed across all spindles at once.  But it can and will 
certainly get much better than it is, once the focus moves to 
optimization.  *AND*, because it /does/ know which areas of the device 
are actually in use, once btrfs is optimized, it's quite likely that 
despite the slower raw speed, because it won't have to deal with the 
unused area, at least with the typically 20-60% unused filesystems most 
people run, rebuild times will match or be faster than raid-layer-only 
technologies that must rebuild the entire device, because they do /not/ 
know which areas are unused.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

