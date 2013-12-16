Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38521 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab3LPPA2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 10:00:28 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VsZei-0002ih-KO
	for linux-btrfs@vger.kernel.org; Mon, 16 Dec 2013 16:00:24 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 16:00:24 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 16:00:24 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Blocket for more than 120 seconds
Date: Mon, 16 Dec 2013 15:00:01 +0000 (UTC)
Message-ID: <pan$9e1d3$23c81b61$a4c9fcce$2641dfd9@cox.net>
References: <CAD_cGvFdrhwC2erqYTMjPRG7Y=69tsT2O+S-GHYK7+wpBwFSFQ@mail.gmail.com>
	<46A0D70E-99DF-46FE-A4E8-71E9AC45129F@colorremedies.com>
	<CAD_cGvHkpkuveYFKm4kjgc0SkJ=mQ4mpChes0F25fdjc5r3PmQ@mail.gmail.com>
	<337E6C9D-298E-4F77-91D7-648A7C65D360@colorremedies.com>
	<CAD_cGvGLHgHagW-G5Qz1yXY4w14BBiZsJj3K0-FmjEGzoo-_rw@mail.gmail.com>
	<840381F8-BDCA-43BF-A170-6E10C2908B8A@colorremedies.com>
	<CAD_cGvF8-pxXXvwpB+yNYnKRW09S4c0VuKUGiWa7=8C2uFkvqA@mail.gmail.com>
	<pan$e9ec8$f8abd102$9f0d15ad$59d83b5d@cox.net>
	<CAD_cGvHU0yaXj-CzVgNYbeqzu7ZH0mUOiwjT-GmU7F5JTqx=jw@mail.gmail.com>
	<pan$9369c$4a56c817$cc0b6bdf$1b4a6541@cox.net>
	<CAD_cGvHQkO23gXtXmCF48Fh+Cxb6Z3b0yiD6pzPyQunGhgD5MA@mail.gmail.com>
	<pan$39434$1fcf3006$dfc308a2$84507249@cox.net>
	<CAD_cGvHAnS4r6MNxd32x6NMAgBRHxR53vVdjnc3EhZdxzipD_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hans-Kristian Bakke posted on Mon, 16 Dec 2013 11:55:40 +0100 as
excerpted:

> Stupid me, I completely forgot that you can run multidisk arrays with
> just block level partitions, just like with md raid! It will introduce a
> rather significant management overhead in my case though, as managing
> several individual partitions per drive is quite annoying with so many
> drives.

What I did here, both with mdraid and now with btrfs raid1, is use a 
parallel partition setup on all target drives.  In a couple special cases 
it results in some wasted space[1], but for most cases it's possible to 
simply plan partition sizes so the end result after raid combination is 
the desired size.

And some years ago I switched to GPT partitions, for checksummed/
redundant partition table reliability, partition naming (similar to 
filesystem labels but in the GPT partition table itself), and to not have 
to mess with primary/secondary/logical partitions.  That lets me set 
partition names, which given the scheme I use for both partition names 
and filesystem labeling, means I have unique name/label IDs for 
everything, across multiple machines and with thumb-drives too!

The scheme is 15 chars long, reiserfs' max label length since I was using 
it at the time I designed the scheme.  Here's the content of text file I 
keep, documenting it:

>>>>>

* 15 characters long
123456789012345
ff     bbB ymd
  ssssS   t   n


Example: rt0005gmd3+9bc0


Function:
ff:     2-char function abbreviation (bt/rt/lg, etc)

Device ID (size, brand, 0-based number/letter)
ssssS:  4-digit size, 1-char multiplier (m=meg, g=gig, etc)
        This is the size of the underlying media, NOT the partition!
bbB     2-char media brand ID, 1-digit sequence number.
        pa=patriot, io=iomega, md=md/raid, etc.
        Note that /dev/md10=mda...

Target/separator
t:      1-char target ID and separator.
        .=aa1, +=workstation, %=both (bt/swap on portable disk)

Date code
ymd:    1-char-each year/month/day prepared
        y=last digit of year
        m=month (1-9abc)
        d=day (1-9a-v)

Number (working, backup-n)
        n=copy number (zero-based)

So together, we have 2 chars of function, 8 of size/mfr/n as device-id,
1 of target/separator,  3 of date prepared, 1 of copy number.

So our example: rt0005gmd3+9bc0

rt=root
0005gmd3=5-gig /dev/md3
+=targeted at the workstation
9bc0=2009.1112 (Nov. 12), first/main version.

<<<<<

For a multi-device btrfs, I set the "hardware" sequence number 
appropriately for the partitions, with the filesystem label identical, 
except its "hardware" sequence number is "x", indicating it's across 
multiple hardware devices.

The "filesystem" sequence number, meanwhile, is 0 for the working copy, 1 
for the primary backup, etc.

With that scheme, I have both the partitions and the filesystems on top 
of them uniquely labeled with function, hardware/media ID (brand, size, 
sequence number), target machine, and partition/filesystem ID (date of 
layout, working/backup sequence number).  If it ever got /too/ complex I 
could keep a list of them somewhere, but so far, it hasn't gotten beyond 
the context-manageable scope level, so between seeing the name/label and 
knowing the context of what I'm accessing, I've been able to track it 
without resorting to a written tracking list.

But that's not to say you gotta do what I do.  If you still find the 
administrative overhead of all those partitions too high, well so be it.
This is just the solution that I've come up with after a couple decades 
of incremental modification, to where it works pretty well for me now.  
If some of the stuff I've come up with the hard way makes useful hints 
for someone else, great.  Otherwise, just ignore it and do what works for 
you.  It's your system and you're the one dealing with it, after all, not 
mine/me. =:^)

> What happens If I do cp --reflink=auto from a NOCOW file in a NOCOW
> folder to a folder with COW set on the same btrfs volume? Do I still get
> "free" copying, and is the resulting file COW or NOCOW?

I don't actually know as that doesn't fit my USE case so well, tho a 
comment I read awhile back hinted it may spit out an error.

FWIW, I tend to either use symlinks one direction or the other or I'm 
trying to keep deliberately redundant backups where I don't want 
potential damage to kill the common-due-to-COW parts of both files, so I 
don't actually tend to find reflinks particularly useful here, even if I 
appreciate the flexibility that option allows.

---
[1] For instance, swap with a hibernate image back before I switched to 
SSD (hibernate was broken on my new machine, last I checked about a year 
ago, and I've enough memory on this machine I usually don't fill it even 
with cache, so I wasn't hibernate or swap anyway, when I switched to 
SSD).  The hibernate image must ordinarily be on a single device and 
should be half the size of RAM or so to avoid dumping cache to fit, but 
making all the parallel swap partitions that size made for a 
prohibitively large swap, that even if I WERE to need it, would take well 
longer to transfer all those gigs
to/from spinning rust than I'd want to take, so one way or another, I'd 
never actually use it all.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

