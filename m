Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44004 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaJ0HvB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 03:51:01 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xif4t-000067-CI
	for linux-btrfs@vger.kernel.org; Mon, 27 Oct 2014 08:50:59 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 08:50:59 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 08:50:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Poll: time to switch skinny-metadata on by default?
Date: Mon, 27 Oct 2014 07:50:48 +0000 (UTC)
Message-ID: <pan$1bd1f$ec6d13d0$43a21241$9f8eca24@cox.net>
References: <20141016113337.GC22943@twin.jikos.cz>
	<20141020163403.GW22943@twin.jikos.cz> <20141025142458.5d96970b@marcec>
	<64867638-EADF-4258-ACD7-BC33014B3DA9@colorremedies.com>
	<CF7BFF69-89E5-44EE-8CC3-E306531B88FE@colorremedies.com>
	<20141027022415.14940745@marcec.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc Joliet posted on Mon, 27 Oct 2014 02:24:15 +0100 as excerpted:

> Am Sat, 25 Oct 2014 14:35:33 -0600 schrieb Chris Murphy
> <lists@colorremedies.com>:
> 
> 
>> On Oct 25, 2014, at 2:33 PM, Chris Murphy <lists@colorremedies.com>
>> wrote:
>> 
>> 
>> > On Oct 25, 2014, at 6:24 AM, Marc Joliet <marcec@gmx.de> wrote:
>> >> 
>> >> First of all: does grub2 support booting from a btrfs file system
>> >> with skinny-metadata, or is it irrelevant?
>> > 
>> > Seems plausible if older kernels don't understand skinny-metadata,
>> > that GRUB2 won't either. So I just tested it with grub2-2.02-0.8.fc21
>> > and it works. I'm surprised, actually.
>> 
>> I don't understand the nature of the incompatibility with older
>> kernels. Can they not mount a Btrfs volume even as ro? If so then I'd
>> expect GRUB to have a problem, so I'm going to guess that maybe a 3.9
>> or older kernel could ro mount a Btrfs volume with skinny extents and
>> the incompatibility is writing.
> 
> That sounds plausible, though I hope for a definitive answer. (FWIW, I
> originally asked because I couldn't find any commits to grub2 related to
> skinny metadata; the updates to the btrfs driver were fairly sparse.)

FWIW I have three /boot partitions, one one each of my main drives.  All 
three are gpt with a reserved BIOS partition that grub2 installs its 
monolithic grub2core into, but have dedicated /boot partitions as well, 
for the grub2 config and additional grub2 modules, kernels, etc.  The 
third one is reiserfs on spinning rust, but the other two are btrfs on 
ssd.

Last time I updated I thought I switched them to skinny-metadata, but 
just checking dmesg while mounting them now, the second one (first 
backup) is skinny-metadata, but my working /boot is still fat-metadata.

I did test the backup (with the skinny-metadata) after I did the mkfs and 
restore and it booted to grub2 and from grub2 to my main system just 
fine, so grub2 with skinny-metadata *CAN* work.

But because it's my backup, I don't update it with new kernels as 
frequently as I do my working /boot, nor do I boot from it that often.  
So while I can be sure grub2 /can/ work with skinny-metadata, I do not 
yet know at this point if it does so /reliably/.

And of course, to the extent that grub2 works differently on MBR and/or 
on GPT when it doesn't have a reserved BIOS partition to put the 
monolithic grub2core in, I haven't tested that.  Tho in theory that 
should install in slack-space if available and the filesystem shouldn't 
affect that at all.  But I know reiserfs used to screw up grub1 very  
occasionally (maybe .5-1% of new kernel installations; it did it I think 
twice in about 7 years, and I run git kernels so update them reasonably 
frequently) on my old MBR setup without much slack-space to spare, and 
I'd have to reinstall grub1.

So that's a qualified skinny-metadata shouldn't affect grub2, as I've 
booted using grub2 on a btrfs with skinny-metadata /boot.  But I've 
simply not tested it enough to know whether it's reliable over time as 
the filesystem updates and changes, or not.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

