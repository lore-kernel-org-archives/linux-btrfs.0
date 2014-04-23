Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37675 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaDWCa6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Apr 2014 22:30:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Wcmxd-00060V-12
	for linux-btrfs@vger.kernel.org; Wed, 23 Apr 2014 04:30:57 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 04:30:57 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Apr 2014 04:30:57 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: convert from RAID5: enospc errors during balance (500 GB free
 on each device)
Date: Wed, 23 Apr 2014 02:30:45 +0000 (UTC)
Message-ID: <pan$7a4f$d3c597d8$d78eba87$c0f85f47@cox.net>
References: <CAG6W84JS1-rzAJfGyPmXMTPLqLN=0UbqefRa-BoqgyzFruhJ_g@mail.gmail.com>
	<CAG6W84JEBg3FRDn6Q9m-cKgA9L=wZP0PQxJTTVXSxVn73pEotA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Arjen Nienhuis posted on Tue, 22 Apr 2014 23:52:43 +0200 as excerpted:

>> Did you try running another balance soft?
> 
> I tried a few. The only thing that happens is that more empty blocks get
> allocated. I also tried convert=single,profiles=raid5. I ended up with a
> few empty 'single' blocks. (The empty blocks could be discarded with
> balance usage=0)

Hmm... So the blocks of the new type get allocated, but nothing gets 
written into them.  That's strange.

I'm not a dev just a btrfs user and list regular, and this is the first 
time I've seen that sort of behavior reported so I can't help much 
further there, but the reason I suggested rerunning the balance is that 
I've had times when I got ENOSPC errors for some chunks on the first 
balance, but it did free enough space from the ones it could rewrite that 
a second pass went just fine, no errors, and since you didn't mention 
retrying in the original post, I thought I would.

The one similar report we did have was with someone that had originally 
done the conversion from ext3/4 following the instructions in the wiki, 
and had removed the ext3/4 subvolume after conversion, but had *NOT* then 
run the defrag and rebalance as recommended.  IIRC he was actually trying 
a later btrfs mode convert (IIRC from single to raid1, after adding a 
second device) as well, when he ran into problems.  Those problems were 
traced to the fact that btrfs data chunks are 1 GiB in size, so that's 
the largest possible extent on native btrfs, while ext3/4 allowed larger 
extents.  The problems thus occurred when the conversion process ran into 
these larger extents, which the original btrfs single mode handled, but 
which the conversion to raid1, copying to the other device in now native 
btrfs mode, couldn't manage.

He ended up having to move a bunch of files off of the btrfs (to tmpfs in 
his case, the files were multi-gig but he had the memory to handle it) 
and then back onto it, in ordered to have them recreated in btrfs-native 
1-GiB data chunks mode.  I don't recall whether they were written back in 
raid1 or single mode, but in any case, once he dealt with the problem 
files that way, the conversion finished properly.

So on the off chance... your filesystem wasn't also originally converted 
from ext3/4 to btrfs, was it?  If so, it might be that issue.  Otherwise 
I don't have a clue.  Maybe the devs can help.

>> Meanwhile... kernel v3.13, btrfs-progs v3.12.  You're just a bit
>> behind, as kernel 3.14 is out (and 3.15 is rc2), and btrfs-progs is
>> 3.14 (possibly 3.14.1, I've not updated in a week or so).  When you
>> run into problems, consider updating before reporting, as there are
>> still very real fixes going into each new version, and they might just
>> fix the problem you're reporting.
> 
> I just upgraded to Ubuntu 14.04. I can try a kernel ppa but I didn't
> find anything in the about this on the wiki.

When you do a mkfs.btrfs, the output there warns that btrfs is still 
experimental, run current kernels, keep backups, etc.  (I'm not creating 
one ATM so I unlike the wiki I don't have that right in front of me, but 
I just redid my backups with a new mkfs.btrfs a few days ago and the 
experimental warning was still there).  The wiki also strongly encourages 
both.  See the stuff in red right near the top of the getting started 
page:

https://btrfs.wiki.kernel.org/index.php/Getting_started

Further down the page there's both a distros vs shipped versions table, 
and a discussion of building from source when the distro version is 
behind.

https://btrfs.wiki.kernel.org/index.php/
Getting_started#Compiling_Btrfs_from_sources

Also see stability status, which emphasizes running the latest stable if 
not the development version, on the main page:

https://btrfs.wiki.kernel.org/index.php/Main_Page#Stability_status

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

