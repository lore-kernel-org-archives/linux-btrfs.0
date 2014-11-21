Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36686 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaKUWtT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 17:49:19 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Xrx0v-0003M7-Eb
	for linux-btrfs@vger.kernel.org; Fri, 21 Nov 2014 23:49:17 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 23:49:17 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Nov 2014 23:49:17 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Fri, 21 Nov 2014 22:49:06 +0000 (UTC)
Message-ID: <pan$d7b2d$664c44b1$38518f25$5a7dbe8a@cox.net>
References: <54699CC7.1050909@swiftspirit.co.za>
	<546A46A5.8030603@inwind.it>
	<CAE8gLh=VubBbZdeKTAuWRjOxPF7C+ouUeeVvmGfT2ckYWGhQVA@mail.gmail.com>
	<CAE8gLh=Lf+z2B_9EXQM_ODSOa5HZsFpFMB=kKGmQXJSjYdy5kg@mail.gmail.com>
	<27BDAC3B-789C-4477-B065-E703CE425F54@colorremedies.com>
	<546B68F8.6080008@ubuntu.com>
	<FC0BA13C-21E3-44DD-A87C-4BEAE4FBF9EA@colorremedies.com>
	<546BA96D.4050805@ubuntu.com>
	<2A57F99C-80AA-4FD4-AA41-57F02AD4E1A2@colorremedies.com>
	<546CB531.2060509@ubuntu.com> <20141121042814.GR17395@hungrycats.org>
	<pan$29e1e$f368f5df$85fe86e7$dd12c3b5@cox.net>
	<CAJCQCtR26DBb9KqYTXXew6TPQhAyya318oLXfBf=Q+NfL_dSPQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Fri, 21 Nov 2014 11:23:45 -0700 as excerpted:

> On Thu, Nov 20, 2014 at 11:22 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> 
>> When I have such a filesystem level problem, I simply dd from the
>> backing device to some other location, generally to a file that's on a
>> different filesystem (preferrably non-btrfs, I use reiserfs as I've
>> found it very resilient, here), in which case btrfs device scan won't
>> see the UUID on the copy as it scans block devices, not inside
>> non-device files.
> 
> That's hours of dd and you have to find space to do it.

I did it recently here.  There's a method to my sub-100-GiB partition 
madness! =:^)  The partitions in question were on SSD, and were small 
enough I could simply DD them to files on my media filesystem, which was 
after all designed to be able to take full ISO images, etc.

Additionally, due to size and reasonably consistent linear intra-file 
access patterns, the media filesystem's still on much cheaper spinning 
rust, while most of the system's on much faster to random-access but far 
more expensive SSD, so in this case one side was SSD, the other spinning 
rust.

Tho granted, if you're doing single-partition/filesystem multi-TiB 
filesystems, it does get to be a problem.  As there would have been if 
the filesystem in question was the media filesystem, altho that one's not 
yet btrfs for a reason.  But still, if there's room enough for an LVM 
snapshot in the first place, with a different layout, there'd be room for 
the same data as a file.  That's pretty basic.

>> After all, an LVM block-level snapshot takes the same space as a file
>> containing the same raw data, and if there's room for the data in an
>> LVM snapshot, given a different layout, there's room for exactly the
>> same amount of data as a file on a different filesystem, piped thru
>> some compressor if necessary due to tight datasize constraints.
> 
> That's not true for thin volume snapshots. They take up next to no space
> upon creation, they don't need space reserved in advance.

Thus the mention of compression if necessary.  Thin-volume snapshots are 
effectively compression by another name, and a raw dd from them should 
compress pretty much equally well, depending on compression method 
chosen, of course. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

