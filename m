Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40837 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015AbaEBKUS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 May 2014 06:20:18 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WgAZl-0006LM-0h
	for linux-btrfs@vger.kernel.org; Fri, 02 May 2014 12:20:17 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 May 2014 12:20:17 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 May 2014 12:20:17 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: "csum failed" that was not detected by scrub
Date: Fri, 2 May 2014 10:20:03 +0000 (UTC)
Message-ID: <pan$ba09e$4b80fc30$5f891c70$5774c32f@cox.net>
References: <CAOwjQU4GP5PjdPZx8HPihS7GQOA74M+DexwMWoh1FOQP0tCTcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Jaap Pieroen posted on Fri, 02 May 2014 11:42:35 +0200 as excerpted:

> I completed a full scrub:
> root@nasbak:/home/jpieroen# btrfs scrub status /home/
> scrub status for 7ca5f38e-308f-43ab-b3ea-31b3bcd11a0d
> scrub started at Wed Apr 30 08:30:19 2014
> and finished after 144131 seconds
> total bytes scrubbed: 4.76TiB with 0 errors
> 
> Then tried to remove a device:
> root@nasbak:/home/jpieroen# btrfs device delete /dev/sdb /home
> 
> This triggered bug_on, with the following error in dmesg: csum failed
> ino 258 off 1395560448 csum 2284440321 expected csum 319628859
> 
> How can there still be csum failures directly after a scrub?

Simple enough, really...

> root@nasbak:/home/jpieroen#   btrfs fi df /home
> Data, RAID5: total=4.57TiB, used=4.55TiB
> System, RAID1: total=32.00MiB, used=352.00KiB
> Metadata, RAID1: total=7.00GiB, used=5.59GiB

To those that know the details, this tells the story.

Btrfs raid5/6 modes are not yet code-complete, and scrub is one of the 
incomplete bits.  btrfs scrub doesn't know how to deal with raid5/6 
properly just yet.

While the operational bits of raid5/6 support are there, parity is 
calculated and written, scrub, and recovery from a lost device, are not 
yet code complete.  Thus, it's effectively a slower, lower capacity raid0 
without scrub support at this point, except that when the code is 
complete, you'll get an automatic "free" upgrade to full raid5 or raid6, 
because the operational bits have been working since they were 
introduced, just the recovery and scrub bits were bad, making it 
effectively a raid0 in reliability terms, lose one and you've lost them 
all.

That's the big picture anyway.  Marc Merlin recently did quite a bit of 
raid5/6 testing and there's a page on the wiki now with what he found.  
Additionally, I saw a scrub support for raid5/6 modes patch on the list 
recently, but while it may be in integration, I believe it's too new to 
have reached release yet.

Wiki, for memory or bookmark: https://btrfs.wiki.kernel.org

Direct user documentation link for bookmark (unwrap as necessary):

https://btrfs.wiki.kernel.org/index.php/
Main_Page#Guides_and_usage_information

The raid5/6 page (which I didn't otherwise see conveniently linked, I dug 
it out of the recent changes list since I knew it was there from on-list 
discussion):

https://btrfs.wiki.kernel.org/index.php/RAID56


@ Marc or Hugo or someone with a wiki account:  Can this be more visibly 
linked from the user-docs contents, added to the user docs category list, 
and probably linked from at least the multiple devices and (for now) the 
gotchas pages?

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

