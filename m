Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51135 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297AbaBGWJx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 17:09:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WBtcL-0004OC-R3
	for linux-btrfs@vger.kernel.org; Fri, 07 Feb 2014 23:09:49 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 23:09:49 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 07 Feb 2014 23:09:49 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Are nocow files snapshot-aware
Date: Fri, 07 Feb 2014 22:58:51 +0100
Message-ID: <rh1gsa-194.ln1@hurikhan77.spdns.de>
References: <mh08sa-5tp.ln1@hurikhan77.spdns.de> <52F1923D.8090306@fb.com> <20140205020239.GP1364@twin.jikos.cz> <6qbasa-fq1.ln1@hurikhan77.spdns.de> <pan$9252f$8363907a$3eaa17a6$f558018@cox.net> <r5mdsa-hng.ln1@hurikhan77.spdns.de> <pan$851d5$f707f4ca$8ec9d1c3$9613615f@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Duncan <1i5t5.duncan@cox.net> schrieb:

>> The question here is: Does it really make sense to create such snapshots
>> of disk images currently online and running a system. They will probably
>> be broken anyway after rollback - or at least I'd not fully trust the
>> contents.
>> 
>> VM images should not be part of a subvolume of which snapshots are taken
>> at a regular and short interval. The problem will go away if you follow
>> this rule.
>> 
>> The same applies to probably any kind of file which you make nocow -
>> e.g. database files. The only use case is taking _controlled_ snapshots
>> - and doing it all 30 seconds is by all means NOT controlled, it's
>> completely undeterministic.
> 
> I'd absolutely agree -- and that wasn't my report, I'm just recalling it,
> as at the time I didn't understand the interaction between NOCOW and
> snapshots and couldn't quite understand how a NOCOW file was still
> triggering the snapshot-aware-defrag pathology, which in fact we were
> just beginning to realize based on such reports.

Sorry, didn't mean to push it to you. ;-) I just wanted to give some 
pointers to rethink such practices for people stumpling upon this.

> But some of the snapshotting scripts out there, and the admins running
> them, seem to have the idea that just because it's possible it must be
> done, and they have snapshots taken every minute or more frequently, with
> no automated snapshot thinning at all.  IMO that's pathology run amok
> even if btrfs /was/ stable and mature and /could/ handle it properly.

Yeah, people should stop such "bullshit practice" (sorry), no matter if 
there's a technical problem with it. It does not give the protection they 
intended to give. It's just wrong sense for security/safety... There _may_ 
be actual use cases for doing it - but generally I'd suggest it's plain 
wrong.

> That's regardless of the content so it's from a different angle than you
> were attacking the problem from...  But if admins aren't able to
> recognize the problem with per-minute snapshots without any thinning at
> all for days, weeks, months on end, I doubt they'll be any better at
> recognizing that VMs, databases, etc, should have a dedicated subvolume.

True.

> But be that as it may, since such extreme snapshotting /is/ possible, and
> with automation and downloadable snapper scripts somebody WILL be doing
> it, btrfs should scale to it if it is to be considered mature and
> stable.  People don't want a filesystem that's going to fall over on them
> and lose data or simply become unworkably live-locked just because they
> didn't know what they were doing when they setup the snapper script and
> set it to 1 minute snaps without any corresponding thinning after an hour
> or a day or whatever.

Such, uhm, sorry, "bullshit practice" should not be a high priority on the 
fix-list for btrfs. There are other areas. It's a technical problem, yes, 
but I think there are more important ones than brute-forcing problems out of 
btrfs that are never being hit by normal usage patterns.

It is good that such "tests" are done, but I would not understand how people 
can expect they need such a "feature" - now and at once. Such tests are not 
ready to leave the development sandbox yet.

>From a normal use perspective, doing such heavy snapshotting is probably 
almost always nonsense.

I'd be more interested in how btrfs behaves in highly io loaded server 
patterns. One interesting use case for me would be to use btrfs as the 
building block of a system with container virtualization (docker, lxc), 
making a high vm density on the machine (with the io load and unpredictable 
io bahavior that internet-facing servers apply to their storage layer), 
using btrfs snapshots to instantly create new vms from vm templates living 
in subvolumes (thin provisioning), spreading btrfs across a higher number of 
disks as the average desktop user / standard server has. I think this is one 
of many very interesting use cases for btrfs and its capabilities. And this 
is how we get back to my initial question: In such a scenario I'd like to 
take ro snapshots of all machines (which probably host nocow files for 
databases), send these to a backup server at low io-priority, then remove 
the snapshots. Apparently, btrfs send/receive is still far from being stable 
and bullet-proof from what I read here, so the destination would probably be 
another btrfs or zfs, using inplace-rsync backups and snapshotting for 
backlog.

-- 
Replies to list only preferred.

