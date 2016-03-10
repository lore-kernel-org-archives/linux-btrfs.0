Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58339 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbcCJCzm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 21:55:42 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1adqlH-0004VR-W4
	for linux-btrfs@vger.kernel.org; Thu, 10 Mar 2016 03:55:40 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 03:55:39 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 03:55:39 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs and containers
Date: Thu, 10 Mar 2016 02:55:33 +0000 (UTC)
Message-ID: <pan$389e0$596a4ce9$6594c4ff$3be23a55@cox.net>
References: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
	<CAJCQCtSPEY1c-=GTJwH3-qRNxGCEsd0bVu9A_srdFt03bX7BcQ@mail.gmail.com>
	<20160308195857.GB26981@localhost.localdomain>
	<CAJCQCtSp5B=nnpCs3zaCsMK+8qLNLzYQAqka5P1X+a+R4RzGOQ@mail.gmail.com>
	<56E013E8.9080401@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Wed, 09 Mar 2016 07:15:36 -0500 as
excerpted:

> On 2016-03-08 16:28, Chris Murphy wrote:

>> Yes, it's a bit peculiar I can create subvolumes and snapshot them, but
>> can't 'btrfs sub list/show'
>>
>> It's an open question why the user needs a subvolume, but I'm not
>> thinking of a human user necessarily but rather some service, maybe
>> it's httpd. Or maybe with the xdg-app stuff the Gnome folks are working
>> on it makes sense to encapsulate applications and their updates in
>> their own subvolume. *shrug*  I'm open to the idea that the use case
>> needs to be more compelling and detailed in order to get the
>> implementation right.
>>
> It's probably worth tossing out there that I use them on a regular basis
> as a normal user (not root or some service) for:
> 1. Local copies of VCS repositories.
> 2. Build directories.
> 3. Staging areas for a variety of things.
> 4. Specifically isolating certain parts of my home directory from
> backups.
> 
> 1-3 are mostly because of the fact that deleting a subvolume is insanely
> fast compared to recursive deletion of a directory, although 4 is
> somewhat significant for those as well.

For #2 and possibly #3, depending on what's being staged and why, tmpfs 
works well, and deleting should be even faster (AFAIK, subvolume deletion 
returns immediately but the work continues in the background, so if 
you're running other IO-bound jobs they'll still be affected even tho the 
subvolume deletion command has returned... if it's all in memory as is 
tmpfs, that problem's eliminated too), tho of course you need enough 
memory so that tmpfs doesn't trigger swap-thrashing.

But #1 and #4 of course don't work as well on tmpfs as you'll likely want 
them around longer, and all four cases definitely make use of the the 
fact that nested subvolumes wall off snapshotting and thus btrfs send, 
for backup purposes.  And of course if you're on a limited-memory machine 
and thus can't easily use tmpfs for building and other staging, and don't 
need to care about the ongoing background IO, using subvolumes for #2 and 
3 remains useful, as well.

> In general I can see them being useful for any number of things from a
> service perspective, although I feel that snapshots are likely more
> useful there (the ability to atomically save the state of a set of files
> is extremely useful for a lot of things).

I consider the current situation somewhat of a security (DoS) issue, 
since users (or runaway scripts or malware) can create unlimited 
subvolumes as an ordinary user, with that user then not being able to 
delete them, requiring admin intervention to do so.  Of course as long as 
it's a single-human-user with an admin-rights alter-ego login, it's not 
/that/ much of a security issue, but I could see it being one for human 
users who do not have that admin-rights alter-ego login.  So were I to be 
running in such a situation, I'd probably use the mount option to let the 
users delete their own subvolumes, unless of course that opens up other 
security issues I'm not aware of.

IMO before btrfs can really be considered stable, this possible DoS needs 
resolved by making the list/delete set the exact same as the create set, 
either by giving users some way to deal with (only) their own subvolumes 
just as they can their own directories, or by reserving subvolume 
creation to superuser, because that's what's needed for listing and 
deletion.  Because if not, I fear someone's going to take advantage of it 
in some way, perhaps, as with many DoS vulns, using it to deny critical 
resources as a way to simplify some other more critical attack, and it'll 
be in the headlines as an attack that worked and a zero-day that still 
works.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

