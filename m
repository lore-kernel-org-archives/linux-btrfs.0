Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55091 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbaH1ULM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Aug 2014 16:11:12 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XN62E-0002UW-7t
	for linux-btrfs@vger.kernel.org; Thu, 28 Aug 2014 22:11:06 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 22:11:06 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Aug 2014 22:11:06 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: fallocate fail on btrfs
Date: Thu, 28 Aug 2014 20:10:54 +0000 (UTC)
Message-ID: <pan$5a8b4$82e4440a$7d2e1fad$aa69a9b3@cox.net>
References: <CADw2B2PYPJdcLWvkufY71kvAdCdgXhsdO2Gizf8hXAruppxXPA@mail.gmail.com>
	<pan$427a1$f65bd1f8$7ddfd94c$6b06de1b@cox.net>
	<CADw2B2NX8XY3V_vD-7eN9vj0tHtEfJwdsS4bovQ0cOHus_9Q-g@mail.gmail.com>
	<CADw2B2MJS-pkd+XfwLTpq_pqzQzLWnkzxLcaw8UYjnS-jOF25g@mail.gmail.com>
	<CADw2B2M3+M6-W-bqyQNYXLX4ug0=t9kNOp320UU3G2iN-CGbHQ@mail.gmail.com>
	<CADw2B2MmR41K3_qEeHUg0ZQAEojK4T3PTFUeUQxLLxsEiEa8_w@mail.gmail.com>
	<pan.2014.08.27.23.33.55@googlemail.com>
	<pan$4f96f$308624ac$25e2c83c$5db208b4@cox.net>
	<CADw2B2Nr56D7_RKSpEOybDFMNr=g_9nZvOFdcYjgN+FaiQyx=w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

G. Richard Bellamy posted on Thu, 28 Aug 2014 07:48:04 -0700 as excerpted:

> School is in again... and my goodness I learned a lot in this go-around.

Don't worry, I did too. =:^)  I consider myself an admin (as I believe 
everyone should who administrates their own systems, it's a big 
responsibility!) not a coder, and tho I can and do read/modify/create an 
occasional patch, I don't claim to do C/C++ code either.  So I rarely 
actually look at sources.

But I'm finding more sources make sense when I do, and Holger's post 
along with your straces was enough to get me digging in to see what's 
actually going on here, and that was quite enlightening on its own.  
Besides looking at code and actually finding I could make sense of it, I 
now understand a bit more of the dynamics of file size vs allocated 
size.  I had no idea it was possible to fallocate beyond EOF like that, 
and simply reading the manpage wouldn't have gotten the point across 
NEARLY as well as actually seeing the change in ls -s, contrasted with 
the file size itself staying the same, as it did here.  That's some 
potentially rather useful information I have safely tucked under my belt 
for future interpretation of "strange" filesize results, now, and it's 
all due to your posts along with Holger's reply, stimulating my own 
investigation. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

