Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35788 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067AbaKRPRI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 10:17:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XqkWf-0007C2-41
	for linux-btrfs@vger.kernel.org; Tue, 18 Nov 2014 16:17:05 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 16:17:05 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 16:17:05 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
Date: Tue, 18 Nov 2014 15:16:53 +0000 (UTC)
Message-ID: <pan$14d66$beee78b5$e18f9ce1$e04b1493@cox.net>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
	<546AF572.2020101@swiftspirit.co.za> <20141118123646.01239614@natsu>
	<546B48A0.1070206@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Brendan Hide posted on Tue, 18 Nov 2014 15:24:48 +0200 as excerpted:

> In this case, yup, its directly to the motherboard chipset's built-in
> ports. This is a very old desktop, and the other 3 disks don't have any
> issues. I'm checking out the alternative pointed out by Austin.
> 
> SATA-relevant lspci output:
> 00:1f.2 SATA controller: Intel Corporation 82801JD/DO (ICH10 Family)
> SATA AHCI Controller (rev 02)

I guess your definition of _very_ old desktop, and mine, are _very_ 
different.

* A quick check of wikipedia says the ICH10 wasn't even 
/introduced/ until 2008 (the wiki link for the 82801jo/do points to an 
Intel page, which says it was launched Q3-2008), and it would have been 
some time after that, likely 2009, that you actually purchased the 
machine.

2009 is five years ago, middle-aged yes, arguably old, but _very_ old, 
not so much in this day and age of longer system replace cycles.

* It has SATA, not IDE/PATA.

* It was PCIE 1.1, not PCI-X or PCI and AGP, and DEFINITELY not ISA bus, 
with or without VLB!

* It has USB 2.0 ports, not USB 1.1, and not only serial/parallel/ps2, 
and DEFINITELY not an AT keyboard.

* It has Gigabit Ethernet, not simply Fast Ethernet or just Ethernet, and 
DEFINITELY Ethernet not token-ring.

* It already has Intel Virtualization technology and HD audio instead of 
AC97 or earlier.

Now I can certainly imagine and "old" desktop having most of these, but 
you said _very_ old, not simply old, and _very_ old to me would mean PATA/
USB-1/AGP/PCI/FastEthernet with AC97 audio or earlier and no 
virtualization.  64-bit would be questionable as well.


FWIW, I've been playing minitube/youtube C64 music the last few days.  
Martin Galway, etc.  Now C64 really _IS_ _very_ old!

Also FWIW, "only" a couple years ago now (well, about three,
time flies!), my old 2003 vintage original 3-digit Opteron based mobo 
died due to bulging/burst capacitors, after serving me 8 years.  I was 
shooting for a full decade but didn't quite make it...

So indeed, 2009 vintage system, five years, definitely not _very_ old, 
arguably not even "old", more like middle-aged. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

