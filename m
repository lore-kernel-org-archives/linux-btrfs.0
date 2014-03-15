Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57340 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573AbaCOJi3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 15 Mar 2014 05:38:29 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WOl2x-0007Dp-Af
	for linux-btrfs@vger.kernel.org; Sat, 15 Mar 2014 10:38:27 +0100
Received: from p5b005b90.dip0.t-ipconnect.de ([91.0.91.144])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 10:38:27 +0100
Received: from holger.hoffstaette by p5b005b90.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 15 Mar 2014 10:38:27 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: discard synchronous on most SSDs?
Date: Sat, 15 Mar 2014 09:38:01 +0000 (UTC)
Message-ID: <pan.2014.03.15.09.38.15@googlemail.com>
References: <C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com>
	<20140314051750.GY6143@merlins.org>
	<pan$667da$c4955705$c59674a0$a844850c@cox.net> <531C1CC4.701@gmail.com>
	<C13A2AFA-A9F0-4219-879C-F1C15ADC63A9@colorremedies.com>
	<20140314051750.GY6143@merlins.org> <5289248.oqpgSKG6td@quad>
	<20140314192605.GD6143@merlins.org> <yq1bnx8y2mi.fsf@sermon.lab.mkp.net>
	<pan.2014.03.14.20.46.24@googlemail.com>
	<20140315042116.GK6143@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 14 Mar 2014 21:21:16 -0700, Marc MERLIN wrote:

> On Fri, Mar 14, 2014 at 08:46:09PM +0000, Holger Hoffstätte wrote:
>> On Fri, 14 Mar 2014 15:57:41 -0400, Martin K. Petersen wrote:
>> 
>> > So right now I'm afraid we don't have a good way for a user to
>> > determine whether a device supports queued trims or not.
>> 
>> Mount with discard, unpack kernel tree, sync, rm -rf tree.
>> If it takes several seconds, you have sync discard, no?
> 
> Mmmh, interesting point.
> 
> legolas:/usr/src# time rm -rf linux-3.14-rc5 real	0m1.584s user	
0m0.008s
> sys	0m1.524s
> 
> I remounted my FS with remount,nodiscard, and the time was the same.
> 
>> This changed somewhere around kernel 3.8.x; before that it used to be
>> acceptably fast. Since then I only do batch trims, daily (server) or
>> weekly (laptop).
> 
> I'm never really timed this before. Is it supposed to be faster than
> 1.5s on a fast SSD?

No, ~1s + noise is OK and seems normal, depending on filesystem and
phase of the moon. To contrast here is the output from my laptop,
which has an old but still-going-strong Intel G2 with ext4:

$smartctl -i /dev/sda | grep ATA
ATA Version is:   ATA/ATAPI-7 T13/1532D revision 1
SATA Version is:  SATA 2.6, 3.0 Gb/s

without dicard:
rm -rf linux-3.12.14  0.05s user 1.28s system 98% cpu 1.364 total

remounted with discard & after an initial manual fstrim:
rm -rf linux-3.12.14  1.90s user 0.02s system 2% cpu 1:07.45 total

I think these numbers speak for themselves. :)

It's really good to know that SATA 3.1 apparently fixed this.

cheers
Holger

