Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47300 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829Ab3KSVFK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Nov 2013 16:05:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VisTt-0002JY-R9
	for linux-btrfs@vger.kernel.org; Tue, 19 Nov 2013 22:05:09 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Nov 2013 22:05:09 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Nov 2013 22:05:09 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Actual effect of mkfs.btrfs -m raid10 </dev/sdX> ... -d raid10
 </dev/sdX> ...
Date: Tue, 19 Nov 2013 21:04:49 +0000 (UTC)
Message-ID: <pan$bf2c2$464ddc53$a304706e$f524e2ac@cox.net>
References: <CAEWPe=pwpxdYUDk7BzfjR8h-Jq9wtQE+gxxQChjOZzsXJO4vHQ@mail.gmail.com>
	<20131119090602.GV4315@carfax.org.uk>
	<CAEWPe=rMXVehpFNko-wZ1i4dKP21J8wJKj1R2jDSK2HsEYmduQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

deadhorseconsulting posted on Tue, 19 Nov 2013 13:24:01 -0600 as
excerpted:

> Interesting, this confirms what I was observing.

> Given the wording in man pages for "-m" and "-d" which states "Specify
> how the metadata or data must be spanned across the devices specified."
> I took "devices specified" to literally mean the devices specified after
> the according switch.

It's all in how you read the documentation.  After years of doing so...

While I can see how you might get that from reading the -m and -d option 
text descriptions, the synopsis indicates differently (excerpt quotes 
reformatted for posting):

SYNOPSIS

mkfs.btrfs  [ -A alloc-start ] [ -b byte-count ] [ -d data-profile ]
[ -f ] [ -n node‐size ] [ -l leafsize ] [ -L label ] [ -m metadata 
profile ] [ -M mixed data+metadata ] [ -s sectorsize ] [ -r rootdir ]
[ -K ] [ -O feature1,feature2,... ] [ -h ] [ -V ] device [ device ... ]


Here, you can see that the -d and -m options take only a single 
parameter, the profile, and that the device list goes at the end and is 
thus a general device list, not specifically linked to the -d and -m 
options.

Similarly, the option lines themselves:

-d, --data type

-m, --metadata profile

... not...

-d, --data type [ device [ device ... ]]

-m, --metdata profile [ device [ device ...]]


Those are from the manpage.  Similarly, the usage line from the output of 
mkfs.btrfs --help (--help being an unrecognized option it says, but it 
does what it needs to do...):

usage: mkfs.btrfs [options] dev [ dev ... ]

options:

-d --data data profile, raid0, raid1, raid5, raid6, raid10, dup or single

-m --metadata metadata profile, values like data profile


All options come first, no indication of per-option device list, then the 
general purpose devices list.


So I'd argue that the documentation's reasonably clear as-is, no per-
option device list, general purpose device list at the end, thus no 
ability to specify data-specific and metadata-specific device lists.

(Of course it can happen that the code gets out of sync with the 
documentation, but that wasn't the argument here.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

