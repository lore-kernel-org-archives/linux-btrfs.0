Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59210 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbcD1IJI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 04:09:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1avh0T-0006Sg-Ok
	for linux-btrfs@vger.kernel.org; Thu, 28 Apr 2016 10:09:05 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 10:09:05 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Apr 2016 10:09:05 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Question: raid1 behaviour on failure
Date: Thu, 28 Apr 2016 08:08:58 +0000 (UTC)
Message-ID: <pan$76628$87e41497$7920bbe4$5a54b486@cox.net>
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
	<nf73cv$7vh$1@ger.gmane.org> <571871FC.2010101@jp.fujitsu.com>
	<CAPmG0jZd7AaH+u52_gqBmke-3S=yH_i9Pmk1R=mOFmdnsj6BgQ@mail.gmail.com>
	<nfb2hr$6i0$1@ger.gmane.org>
	<CAPmG0jY5RRS_8YcECyCts6BEeJKT+74Uxr-2kitouruyBDwgfQ@mail.gmail.com>
	<571F9A92.8060602@googlemail.com> <nfs642$ua8$1@ger.gmane.org>
	<CA+WRLO-L_jy651cr_amdqisQPrZGm7mOmniOF7q_t9ZSfY+EPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Gareth Pye posted on Thu, 28 Apr 2016 15:24:51 +1000 as excerpted:

> PDF doc info dates it at 23/1/2013, which is the best guess that can
> easily be found.

Well, "easily" is relative, but motivated by your observation I first 
confirmed it, then decided to see what google had to say about the 
authors.

I only looked at the two University of Minnesota authors.  David Lilja is 
a professor there since the 90s, with google turning up various lectures, 
etc, at other universities.  Peng Li, listed as a student in the paper, 
was presumably a graduate student.  His linkedin profile says he's at 
Intel from Aug 2015 to present (software engineer, non-volatitle memory 
device R&D), but was Sr. Engineer, Seagate Tech, Minneapolis/St.Paul 
area, July 2013 to August 2015 (drive arch and performance modeling), and 
was a summer intern at Huawei in San Fran area in the middle of 2012.  
There's several patent and papers to his name.

More importantly for us, however, linkedin links to his personal page, 
still University of Minnesota as he graduated there with a doctorate, PhD 
Advisor, no surprise, Prof. David J Lilja.

http://people.ece.umn.edu/~lipeng/

That page lists as a one project:

Reliability of SATA Port Multiplier (2012).

So while the paper probably came out in January of 2013 as the pdf date 
suggests, he was working on it in 2012.

BTW, his personal site was last updated in June of 2013 and thus doesn't 
mention anything about his move to Intel in 2015.  I'd guess he hasn't 
touched it since getting the doctorate and the job at Seagate, given the 
page mentions that, but the Linkedin profile said it didn't start until 
July of that year, the month after his last personal page at the 
university, update.


Took me longer to write that up than to find it, so it wasn't hard, but 
as I said, "easy" is relative, so YMMV. =:^)

Meanwhile, that was just a single sampling, as the paper itself points 
out, so we don't know where it falls among other port multipliers, or 
even if its behavior was characteristic of that brand and model.

What we do have, however, is that semi-official paper, along with other 
observations here about the reliability, or more accurately, lack of 
reliability, of the various USB2SATA bridge chips, etc.  Even without the 
port multiplier, prior real world posted experience here suggests that 
while single device btrfs on USB via USB2SATA bridge may be reasonable, 
it's not particularly reliable as part of a multi-device btrfs, as too 
often the bridges and devices behind them drop out temporarily due to 
power or other reasons, and btrfs at this point simply doesn't cope well 
with devices dropping out and appearing again, possibly as other 
devices.  With a single-device btrfs there isn't much to screw up, the 
data either gets there or doesn't, and the atomic-cow nature of btrfs 
does at least normally allow for recovery to a known past state plus 
replay of the fsync log between commits if it doesn't, but multi-device 
can quickly get out of hand, particularly if more than one device is 
playing the disappear and reappear game at once.


A reasonable conclusion then, is that the given layout isn't particularly 
reliable at more than one point, making multi-device anything over it 
rather unwise.  JBOD /as/ /JBOD/, creating individual single-device 
filesystems on each device (or device partition), may be somewhat more 
workable, but multi-device, whether at the btrfs level or dm- or md-raid 
level underneath some other filesystem, isn't likely to be very reliable 
at all.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

