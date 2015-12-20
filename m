Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36012 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754149AbbLTIu5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Dec 2015 03:50:57 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aAZhf-0004lV-J7
	for linux-btrfs@vger.kernel.org; Sun, 20 Dec 2015 09:50:55 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Dec 2015 09:50:55 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Dec 2015 09:50:55 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Disk quota exceeded
Date: Sun, 20 Dec 2015 08:50:45 +0000 (UTC)
Message-ID: <pan$253ad$3e8b4bb5$68393e15$fc470a38@cox.net>
References: <567533BA.1010207@edcint.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Matthew Jurgens posted on Sat, 19 Dec 2015 21:38:50 +1100 as excerpted:

> I've create a subvolume [and] assigned a small quota to it:
> CMD: btrfs qgroup limit 100M /export/shared/TV/files

> I've also disabled copy on write:
> CMD: chattr -R -V +C /export/shared/TV/files

[wrote only ~50 M of files, can't write more]

> It seems like copy on write is still functioning for this directory? or
> quota results have delays?

> Is this happening because quotas are not yet considered stable?
> Is there something I am doing wrong?

> uname [-r] 4.2.7-200.fc22.x86_64

> btrfs --version btrfs-progs v4.2.2

[Disclaimer: List regular and btrfs user.  Not a dev.  My own use-case 
doesn't involve quotas or even subvolumes, so the following is based 
purely on what I've seen on-list.]

Quotas are definitely not stable, thru 4.3 at least, and you're running 
4.2.

IIRC They've on the product of the second major rewrite (so third try) 
now and there have always been issues.  While there's hard work going 
into fixing the issues, full fixes have remained at least a kernel cycle 
or two out for quite some time now.  AFAIK, 4.4 is supposed to fix some 
more issues, but I'm not sure if it fixes all known issues yet or if 
there's more remaining, and even if it fixes all known issues, I'd 
suggest waiting at least a complete kernel cycle and preferably two with 
no known issues, before considering quotas actually reasonably 
dependable, as given the history, there's a fair chance more issues will 
popup.

Additionally, quotas thru at least 4.3 still have bad scaling issues that 
slow down maintenance such as balance.  (I'm not sure if check is 
affected or not, but scrub shouldn't be.)

So I'd strongly suggest leaving quotas off thru the 4.4 cycle at least.  
If 4.4 and the 4.5 development cycle ends up with no further issues, you 
may wish to consider enabling them for 4.5, tho more conservative users 
will wait another cycle and see if there's no further issues reported 
thru the 4.6 development cycle as well, enabling them once they're on it.

(Since 4.4 will be an LTS kernel, if you're sticking to it, you could 
consider enabling quotas on updates after 4.5 or 4.6 release, if there 
have been no reports of quota issues on 4.4 by then.)


Meanwhile, a few more quota related factors to consider:

1) As I'm not a quota user I can't say for sure on this, but it seems 
mighty coincidental that it failed at just over half the set quota... and 
you're running btrfs raid10 data, so btrfs is keeping two copies and 
doubling the usage.  Maybe it's tracking the actual doubled due to the 
raid10 usage instead of the single-copy value?  (This actually sounds 
like some of the sort of internal logic bugs they've been fixing tho I'm 
unaware of one exactly like this, so you might try a current kernel 4.4-rc 
and see if the results are different, and/or try it on a different btrfs 
with replication set to single mode.)

2) Btrfs metadata is always copy-on-write.  That can't be disabled.  
Disabling COW only disables it for data.

I remember some discussion of whether quotas should track data only or 
include metadata as well, or possibly make it optional to track both or 
set quotas separately for each, but IDR the results of those discussions 
and as I don't use them myself...

That would explain not being able to delete the file at times, because 
doing so would change the metadata and thus require COWing it, and if 
it's quota tracked and reporting over quota errors...

3) While this shouldn't apply to the scenario above because you followed 
the recommendation and set nocow on the dir and /then/ created the file, 
so the file should have inherited the nocow, and I suppose you know this 
already, but for the benefit of others following alone, it should be 
noted that nocow doesn't necessarily take effect on files that already 
have content -- they need to be zero-sized for it to take effect.

The recommended procedure to avoid the problem is exactly what you did, 
set nocow on the dir and take care to either create new files (as you 
did) or copy/move them into place without reflinking, so they're actually 
created before they have any content, so the nocow inherited from the dir 
will actually take effect.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

