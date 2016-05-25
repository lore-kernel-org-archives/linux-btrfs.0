Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:48961 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbcEYTDq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 15:03:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1b5e5n-0003TX-Et
	for linux-btrfs@vger.kernel.org; Wed, 25 May 2016 21:03:43 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 21:03:43 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 25 May 2016 21:03:43 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Some ideas for improvements
Date: Wed, 25 May 2016 19:03:32 +0000 (UTC)
Message-ID: <pan$4409c$50898a15$4d9b8e7d$2537805b@cox.net>
References: <45a47ee4db4cc92248f91f1d00e8ed03@www.centurion.link>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dmitry Katsubo posted on Wed, 25 May 2016 16:45:41 +0200 as excerpted:

> Dear btrfs community,
> 
> I hope btrfs developers are open for suggestions.
> 
> btrfs-scrub:
> 
> * Would be nice if 'btrfs scrub status' shows estimated finishing time
> (ETA) and throughput (in Mb/s).

That might not be so easy to implement.  (Caveat, I'm not a dev, just a 
btrfs user and list regular, so if a dev says different...)

Currently, a running scrub simply outputs progress to a file (/var/lib/
btrfs/scrub.status.<UUID>), and scrub status is simply a UI to pretty-
print that file.  Note that there's nothing in there which lists the 
total number of extents or bytes to go -- that's not calculated ahead of 
time.

So implementing some form of percentage done or eta is likely to increase 
the processing time dramatically, as it could involve doing a dry-run 
first, in ordered to get the total figures against which to calculate 
percentage done.

> * Not possible to start scrub for all devices in the volume without
> mounting it.

Interesting.  It's news to me that you can scrub individual devices 
without mounting.  But given that, this would indeed be a useful feature, 
and given that btrfs filesystem show can get the information, scrub 
should be able to get and make use of it as well. =:^)

So (again not a dev, but...) this one's probably just a matter of coding 
it up.  Tho there's lots of ideas and only a comparatively few devs 
working on them, so unless it happens to strike someone's fancy as a nice 
short project, it could be awhile before it's implemented.

> btrfs-restore:
> 
> * It does not restore special files like named pipes and devices.
> * Hard-linked files are not correctly restored (they all turn into
> independent replicas).
> * If the file cannot be read / recovered, it is still created with zero
> size (I would expect that the file is not created).
> * I think that the options '-xmS' should be enabled by default
> (shouldn't it be a goal to restore as much as possible?).
> * Option that applies (y) to all questions (completely unattended
> recovery) is missing.

That latter point is a known sore spot that a lot of people have 
complained about.  So it'll almost certainly be addressed eventually, but 
it's a matter of this project vying with all the others so it could be 
awhile.

As for the other points, restore has rather evolved over time.  Those 
optional features were added on one or two at a time and were at first 
non-default options because as new features there was a non-zero chance 
they could disrupt the entire restore, regressing restore as a useful 
disaster recovery tool.

It's also useful to remember that btrfs is still considered by its devs 
to be very much still stabilizing, not fully stable and mature, and many 
of its tools, including restore, /do/ continue to evolve.  Once the 
general feature set is reasonably full and stable, it's likely some of 
these non-default options will be made default, for a final stable-form 
command-set.  I'd consider it quite likely that some of the restore 
options will indeed be made the default, in final-form btrfs restore.

Meanwhile, that unfinished evolution is most likely behind the zero-sized 
(non-)restore of some files, the missing special files, etc.  Those 
issues will likely be addressed at some point.

In fact, it was someone wanting timestamp restoration for his own use, 
that happened to be a dev that could actually write the code, that 
contributed the metadata restoration option, scratching his own itch.  
And when I saw that, I immediately asked about symlink restoration, as 
that was an itch I had when using restore myself, tho not being a dev I 
couldn't just code up the solution to scratch it as he did.  But I was 
lucky and he had the time and patience to do it while he was working with 
the code, so the symlinks restoration option was added a release or two 
after the metadata restoration option.

But I guess nobody has had and made known an itch for other special file 
restoration yet -- I wasn't even aware they weren't restored, here, as it 
hadn't occurred to me to check.  So it'll probably happen, but having 
missed the opportunity I took advantage of to request symlink restoration 
support while he was working on the metadata support, again, it could be 
awhile until someone actually codes up the special file restoration 
support.

I am, however, not sure how practical hardlink (and of course the btrfs 
specific reflink) restoration, maintaining the link as opposed to 
breaking the link and restoring as separate files actually is, and if 
it's complicated at all, the priority is likely to be quite low.  Because 
after all, btrfs restore isn't intended for routine use, but as a 
disaster recovery tool.  In theory, people should be recovering from 
their backups (and any good sysadmin knows the first rule of backups in 
simple form is that if you don't have at least one level of backup, you 
are by lack thereof declaring the data to be worth less than the time and 
resources necessary to do that backup), and shouldn't really be depending 
on btrfs restore anyway.  As such, just restoring the files at all is 
arguably enough, and all these options like restoring metadata are 
arguably gravy on top already.  If restoring hard-links, and if the 
restore is to btrfs, possibly reflinks as well, as links not independent 
files, isn't too complex, then yeah, restoring them as an option is 
fine.  But if it's adding serious additional complexity, as I suspect it 
might, yes, the option might still be added at some point, but the 
priority to do it will be pretty low, which means the point at which it's 
actually added is likely to be out there five years or more, simply 
because there's so many other ideas at a higher priority to implement as 
well.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

