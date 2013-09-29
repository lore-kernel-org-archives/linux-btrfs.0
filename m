Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:9096 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753211Ab3I2CHH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 22:07:07 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Corrupt btrfs filesystem recovery... (Due to *sata* errors)
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <l27mgf$qmn$1@ger.gmane.org>
Date: Sat, 28 Sep 2013 20:06:36 -0600
Cc: linux-btrfs@vger.kernel.org
Message-Id: <53F0C9F1-BF66-47DA-BAE9-7E0C3B7030EF@colorremedies.com>
References: <l27agq$u5a$1@ger.gmane.org> <87F045E8-CBB5-4818-B60B-0325EC87A56D@colorremedies.com> <l27mgf$qmn$1@ger.gmane.org>
To: Martin <m_btrfs@ml1.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Sep 28, 2013, at 4:51 PM, Martin <m_btrfs@ml1.co.uk> wrote:

> Indeed. However, are not the sata errors reported back to btrfs so that
> it knows whatever parts haven't been updated?

It's a good question.

My doubtful speculation of such a mechanism is that it is really not the responsibility of the file system to be prepared for the hardware face planting this spectacularly. The hardware really should do better than this. There are specifications that apply here, and the drive and controller and driver all agreed long before the mounting of a volume and writes started to occur. But then later on, at some point in the middle of the really important part of the conversation (writing your data) something in the hardware chain puked and said "OHHh wait about that prior conversation, I'm really confused, let's talk at a slower speed shall we?" So the before part is just a lost conversation, is my speculation.

The other thing is that SATA and SAS handle these things differently. When there's such a serious error that results in a link speed change, usually the bus is reset and for SATA it means the command queue is lost. And I don't think Btrfs is informed of what commands were completed vs failed in such a case.

But I'd love someone who actually knows what they're talking about to answer that question.

My expectation though, is that unlike perhaps other file systems, Btrfs's design goal is to handle the data that did get written, better. In that it's still accessible where other file systems possibly will have a more difficulty.


> Is there not a mechanism to then go "read-only"?

I don't know. In this case it does seem sorta reasonable. But the dmesg might still be revealing. The PHY Event counters indicate a lot of retries of over 1000 sectors.
> 
> Also, should not the journal limit the damage?

Well it's COW so it's not quite like a journaled file system, but yeah it should be in a position to know at the next mount time the most recent state of file system consistency. But that doesn't mean it can fix the parts that are just fundamentally broken. But I think it's a valid question, "now what?" because I don't actually know the state of your file system or how to determine it. So maybe Hugo, or someone else has some thoughts.

But for sure I would move to kernel 3.11.2 or 3.12.rc2 before mounting this file system again.

> 
> 
>>> How best to recover from this?
>> 
>> Why you're getting I/O errors at SATA 6Gbps link speed needs to be
>> understood. Is it a bad cable? Bad SATA port? Drive or controller
>> firmware bug? Or libata driver bug?
> 
> I systematically eliminated such as leads, PSU, and NCQ. Limiting libata
> to only use 3Gbit/s is the one change that gives a consistent fix. The
> HDD and motherboard both support 6Gbit/s, but hey-ho, that's an
> experiment I can try again some other time when I have another HDD/SSD
> to test in there.

Stick with forced 3Gbps, but I think it's worth while to find out what the actual problem is. One day you forget about this 3Gbps SATA link, upgrade or regress to another kernel and you don't have the 3Gbps forced speed on the parameter line, and poof - you've got more problems again. The hardware shouldn't negotiate a 6Gbps link and then do a backwards swan dive at 30,000' with your data as if it's an after thought.


> In any case, for the existing HDD - motherboard combination, using sata2
> rather than sata3 speeds shouldn't noticeably impact performance. (Other
> than sata2 works reliably and so is infinitely better for this case!)

It's true.


> 
> 
>>> Lots of sata error noise omitted.
>> 
>> And entire dmesg might still be useful. I don't know if the list will
>> handle the whole dmesg in one email, but it's worth a shot (reply to
>> an email in the thread, don't change the subject).
> 
> I can email directly if of use/interest. Let me know offlist.

Use pastebin.com and post the link if it's really huge, but I'd consider setting it to no expiration because if something interesting is learned, people doing searches have a better chance of finding the problem if the link hasn't expired.

I would also separately unmount the file system, note the latest kernel message, then mount the file system and see if there are any kernel messages that might indicate recognition of problems with the fs.

I would not use btrfsck --repair until someone says it's a good idea. That person would not be me.

Chris Murphy

