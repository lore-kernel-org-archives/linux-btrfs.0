Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41334 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbbLIL12 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Dec 2015 06:27:28 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a6cto-0008TF-In
	for linux-btrfs@vger.kernel.org; Wed, 09 Dec 2015 12:27:13 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 12:27:03 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Dec 2015 12:27:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: subvols and parents - how?
Date: Wed, 9 Dec 2015 11:26:52 +0000 (UTC)
Message-ID: <pan$eafa8$b5da4379$31bc32b1$5bc4c9a0@cox.net>
References: <1448340960.14125.51.camel@scientia.net>
	<pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
	<1448400350.21291.88.camel@scientia.net>
	<pan$3a1c9$86b20059$6602684a$c91a5eb4@cox.net>
	<1449635882.20578.2.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Wed, 09 Dec 2015 05:38:02 +0100 as
excerpted:

> On Fri, 2015-11-27 at 02:02 +0000, Duncan wrote:

>> Consider a setuid-root binary with a recently publicized but patched on
>> your system vuln.  But if you have root snapshots from before the patch
>> and those snapshots are nested below root, then they're always
>> accessible.  If the path to the vulnerable setuid is as user accessible
>> as it likely was in its original location, then anyone with login
>> access to the system is likely to be able to run it from the
>> snapshot... and will be able to get root due to the vuln.
> 
> Hmm good point... I think it would be great if you could add that
> scenario somewhere to the documentation. :-)

FWIW, I (personally, not sure if that "you" was singular or plural) am 
much more comfortable on the lists than on wikis, which I tend to treat 
much as I did printed encyclopedias back in the day -- as great 
references, but read-only from my perspective.  So while I know they can 
be edited in theory, I just don't tend to get around to it, and don't 
believe I've ever even gotten a wiki login, on /any/ wiki, let alone the 
btrfs wiki.  But as you've likely noticed, I do find them great 
references to read and to post links to. =:^)

So while I'm not opposed in principle to editing the wiki, in practice 
I'm never going to do it.  I'll reply here with the info, and if it gets 
to the wiki, it's almost certainly because someone else posted it there, 
based on my post here, or not.

> Based on that one can easily think about more/similar examples... device
> file that had too permissive modes set, and where snapshotted like
> that... and so on.

Exactly...

> I think that's another example why it would be nice if btrfs had
> something (per subvolume) like ext4's default mount options (I mean the
> ones stored in the superblock).
> 
> Not only would it allow the userland tools to do things like "adding
> notatime" [...] it would also allow to set things like nodev, noexec,
> nosuid and that like on subvols... and again it would make the whole
> thing practically usable with nested subvols.
> 
> Where would be the appropriate place to record that as a feature
> request?
> Simply here on the list?

While the appropriate place would be on the wiki, where there's a page 
for that (here, the request is likely to be lost to history, while on the 
wiki it's in a nice list that both devs and other requesters can look at, 
a year, five years, a decade... into the future), in this case...

There's already a framework for it and a limited implementation, tho only 
a small subset of possible options are yet available.  The UI exposure is 
as btrfs property (see the btrfs-property manpage), with the properties, 
in general, implemented as extented attributes.

You can browse what's currently available, but as I said, it's pretty 
limited ATM, pretty much just enough to prove the concept and serve as a 
placeholder for more to be added, later.

Of course other informational and sometimes configurable bits are exposed 
in the developing btrfs sysfs tree, which is where most of the work of 
that sort has been focused recently.  But it too is somewhat immature and 
developing, tho at this point it seems to be further along than 
properties, partly because btrfs' own tools are using it at times.

Basically, both properties and the sysfs interface demonstrate btrfs' 
status as stabilizING and maturING, as that sort of thing really can't be 
implemented until the basics have settled down far enough to form a 
stable reference point, but not yet fully stable or mature, as both 
interfaces are as yet not fully developed, with more to be added.

But in both cases there's enough there to browse and get a reasonable 
idea how things are being exposed and how they'll work once they are. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

