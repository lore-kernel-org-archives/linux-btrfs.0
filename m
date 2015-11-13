Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35991 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbbKMGlv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Nov 2015 01:41:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zx83Q-0005v4-Og
	for linux-btrfs@vger.kernel.org; Fri, 13 Nov 2015 07:41:48 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 07:41:48 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Nov 2015 07:41:48 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Ideas for btrfs-convert fix(or rework)
Date: Fri, 13 Nov 2015 06:41:40 +0000 (UTC)
Message-ID: <pan$ec21f$788a0920$bfddacc$a403adaf@cox.net>
References: <56418E5D.9020604@gmx.com> <20151110125501.1aa6f155@natsu>
	<5641A7DA.6010102@gmx.com> <20151110140855.3ae7297c@natsu>
	<5641B64A.9020606@gmx.com> <pan$edd20$481e3529$4248bf13$5caaf119@cox.net>
	<CAO5K3OfBy72Yn1s4Ow2h_2KkE7U4wQA66oxjQLva82-D2LqScA@mail.gmail.com>
	<564493D5.2070609@gmail.com> <20151112190918.3820dd2a@natsu>
	<5644A44B.6050804@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S Hemmelgarn posted on Thu, 12 Nov 2015 09:38:03 -0500 as
excerpted:

> I'm not arguing that [btrfs-convert] should just go away, I'm trying to
> argue that it shouldn't be a development priority if it works correctly.

Agreed.

If you go back to my reply that started this subthread, the statement I 
took issue with was that btrfs couldn't be accepted as stable unless 
btrfs-convert was stable.

I simply argued that wasn't the case, since a convert tool is entirely 
optional, and many fully stable filesystems do entirely without one.  
Btrfs as a filesystem doesn't /have/ to have this tool, it's optional, so 
btrfs as a filesystem should be able to stabilize just fine, just as have 
all the filesystems without a convert tool, no matter the condition of 
this tool.

Of course having a convert tool and having it working is indeed nice to 
have, and I said that, but the condition of a convert tool, or even 
having one at all, really shouldn't hold up stabilization of the 
filesystem as a whole, just as it hasn't held up stabilization of all the 
other filesystems that don't have such a tool.

/Because/ btrfs-convert is a very nice to have tool, yes, time spent 
working on it is worthwhile time.  But nobody, least of all me, was 
arguing otherwise.  I was just saying that the overall stability of btrfs 
as a filesystem shouldn't be affected by the stability of this tool, as 
it's optional, and many other accepted as stable filesystems don't have 
such tools, so just because btrfs does, if the tool doesn't happen to be 
stable, should have nothing to do with whether the filesystem itself is 
stable or not.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

