Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57542 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754297AbaD2G2w (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Apr 2014 02:28:52 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wf1X8-0004zc-Ud
	for linux-btrfs@vger.kernel.org; Tue, 29 Apr 2014 08:28:50 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 08:28:50 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Apr 2014 08:28:50 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "kernel BUG at
 =?us-ascii?Q?=2Fhome=2Fapw=2FCOD=2Flinux=2Ffs=2Fbtrfs=2Fextent=5Fio?=
 =?us-ascii?Q?=2Ec=3A2116!=22?= when deleting device or balancing
 filesystem.
Date: Tue, 29 Apr 2014 06:28:39 +0000 (UTC)
Message-ID: <pan$c3e1d$1f669ca6$e80dc3d5$584048c@cox.net>
References: <C25AA8A9-30B0-4D00-80B5-B681D93D67A3@pieroen.nl>
	<pan$2abc$efe882ea$fdd493d$5779ebd8@cox.net>
	<loom.20140428T222711-911@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jaap Pieroen posted on Mon, 28 Apr 2014 20:30:55 +0000 as excerpted:

>> For further reference, whenever you post btrfs fi show, please post
>> btrfs fi df as well, as the two provide complementary information, and
>> the picture without both of them is incomplete.
>> 
>> If you'd supplied the btrfs fi df output, we could see what raid level
>> you're running for data/metadata/system, as well as which type of
>> chunks were still left on /dev/sdb.
> 
> Yep, I dropped the ball here. I did look in the wiki for a list of
> output required when asking for support, but I couldn't find any. I'll
> make sure I add it to the wiki for the next person.

Thanks.  That's likely to be quite practically useful to many people over 
time, including me.  =:^)

(FWIW, while I mentally appreciate that wikis are there to be user-
edited, in practice I seem to treat them like I do most of the web, read-
only, and never actually seem to get around to changing them at all.  
OTOH, I've always enjoyed the give and take of newsgroups and mailing 
lists and in practice spend quite a bit of time replying to posts, 
hopefully helping others there, which I know I do based on the thanks I 
get.  So I really /can/ thank you for putting that on the wiki, since 
while it's likely to make my job replying to posts easier, in practice 
it's something I'd be extremely unlikely to change on the wiki myself, 
even on wikis like the btrfs wiki which I highly value and have spent 
quite some time reading and much more replying on the related list, 
because for whatever reason I personally just seem to have an easier time 
replying on-list than I do editing wikis.  But I'm sure glad others get 
around to editing them. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

