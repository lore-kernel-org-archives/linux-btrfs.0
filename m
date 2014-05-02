Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46760 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782AbaEBRs1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 May 2014 13:48:27 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WgHZS-0004Ml-A7
	for linux-btrfs@vger.kernel.org; Fri, 02 May 2014 19:48:26 +0200
Received: from 5ED60B40.cm-7-7a.dynamic.ziggo.nl ([94.214.11.64])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 May 2014 19:48:26 +0200
Received: from jaap by 5ED60B40.cm-7-7a.dynamic.ziggo.nl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 May 2014 19:48:26 +0200
To: linux-btrfs@vger.kernel.org
From: Jaap Pieroen <jaap@pieroen.nl>
Subject: Re: 
Date: Fri, 2 May 2014 17:48:13 +0000 (UTC)
Message-ID: <loom.20140502T194216-357@post.gmane.org>
References: <CAOwjQU4GP5PjdPZx8HPihS7GQOA74M+DexwMWoh1FOQP0tCTcw@mail.gmail.com> <pan$ba09e$4b80fc30$5f891c70$5774c32f@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan <at> cox.net> writes:

> 
> To those that know the details, this tells the story.
> 
> Btrfs raid5/6 modes are not yet code-complete, and scrub is one of the 
> incomplete bits.  btrfs scrub doesn't know how to deal with raid5/6 
> properly just yet.
> 
> While the operational bits of raid5/6 support are there, parity is 
> calculated and written, scrub, and recovery from a lost device, are not 
> yet code complete.  Thus, it's effectively a slower, lower capacity raid0 
> without scrub support at this point, except that when the code is 
> complete, you'll get an automatic "free" upgrade to full raid5 or raid6, 
> because the operational bits have been working since they were 
> introduced, just the recovery and scrub bits were bad, making it 
> effectively a raid0 in reliability terms, lose one and you've lost them 
> all.
> 
> That's the big picture anyway.  Marc Merlin recently did quite a bit of 
> raid5/6 testing and there's a page on the wiki now with what he found.  
> Additionally, I saw a scrub support for raid5/6 modes patch on the list 
> recently, but while it may be in integration, I believe it's too new to 
> have reached release yet.
> 
> Wiki, for memory or bookmark: https://btrfs.wiki.kernel.org
> 
> Direct user documentation link for bookmark (unwrap as necessary):
> 
> https://btrfs.wiki.kernel.org/index.php/
> Main_Page#Guides_and_usage_information
> 
> The raid5/6 page (which I didn't otherwise see conveniently linked, I dug 
> it out of the recent changes list since I knew it was there from on-list 
> discussion):
> 
> https://btrfs.wiki.kernel.org/index.php/RAID56
> 
>  <at>  Marc or Hugo or someone with a wiki account:  Can this be more visibly 
> linked from the user-docs contents, added to the user docs category list, 
> and probably linked from at least the multiple devices and (for now) the 
> gotchas pages?
> 

So raid5 is much more useless than I assumed. I read Marc's blog and
figured that btrfs was ready enough.

I' really in trouble now. I tried to get rid of raid5 by doing a convert
balance to raid1. But of course this triggered the same issue. And now
I have a dead system because the first thing btrfs does after mounting
is continue the balance which will crash the system and send me into
a vicious loop.

- How can I stop btrfs from continuing balancing?
- How can I salvage this situation and convert to raid1?

Unfortunately I have little spare drives left. Not enough to contain
4.7TiB of data.. :(




