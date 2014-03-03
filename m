Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:48752 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752717AbaCCVC3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 16:02:29 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:63027 helo=[192.168.1.145])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1WKa0L-003yH5-Gs
	for linux-btrfs@vger.kernel.org; Mon, 03 Mar 2014 14:02:29 -0700
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: ENOSPC errors during raid1 rebalance
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <loom.20140303T214420-188@post.gmane.org>
Date: Mon, 3 Mar 2014 14:02:28 -0700
Message-Id: <484B2C3D-6BCF-4B31-BEB7-B917A49476AF@colorremedies.com>
References: <DF16C10AFF7F394A8C8A09C9405478890BCBE534@EXHOST.stardatecomputer.com> <pan$b5b02$85505b$f53ee629$e32b9776@cox.net> <loom.20140303T191959-983@post.gmane.org> <D35E6741-2350-4910-B785-5584F730EDA9@colorremedies.com> <loom.20140303T200845-874@post.gmane.org> <523E1747-8B25-48F8-8DAD-D40021F42DAC@colorremedies.com> <loom.20140303T214420-188@post.gmane.org>
To: Btrfs <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Mar 3, 2014, at 1:50 PM, Michael Russo <mike@papersolve.com> wrote:

> Oh yeah, it was definitely a problem with either the drives 
> or the external enclosure, which was converting USB to SATA 
> and mirroring the drives internally (it was a WD MyBook 
> Mirror Edition). There was a problem with one of the drives 
> and I replaced it, but before I did it screwed up some 
> data. I think one drive kept trying to do a retry on a read 
> and somehow the logic decided to just give me a "nearby" 
> sector to satisfy the read (I can't really figure out how else 
> 10 seconds of a random but "nearby" in alphabetical order 
> MP3 could get stuck into the middle of another MP3).   

If it's a persistent problem with a particular file, that has the same 10 seconds from some other song, it's actually been written to disk wrong. That's a misdirected write.

10 seconds of some other file playing translates into how many blocks of data roughly? That's probably a pretty big misdirect. So I don't know that this would be more likely a drive problem, or possibly memory or controller. I'd burn a memtest86+ run for a few days if you haven't done this recently to remove that as a factor.

> So I removed the entire enclosure and put them inside 
> my case and decided I never wanted it to happen again so I 
> converted to btrfs. :)  Very happy it exists!


The USB to SATA chipsets are all over the map quality wise, a lot of them suck. So this sounds like you've eliminated the controller as a factor going forward, by changing back to a direct SATA connection. That's a good idea.



Chris Murphy

