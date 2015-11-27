Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41173 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609AbbK0BDF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 20:03:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1a27RD-0003Qi-7Y
	for linux-btrfs@vger.kernel.org; Fri, 27 Nov 2015 02:02:59 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 02:02:59 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Nov 2015 02:02:59 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: subvols and parents - how?
Date: Fri, 27 Nov 2015 01:02:53 +0000 (UTC)
Message-ID: <pan$22dc8$4457dc54$1cd0d037$c9fb9e32@cox.net>
References: <1448340960.14125.51.camel@scientia.net>
	<pan$72d2a$22c54e26$a0b05056$57585aef@cox.net>
	<1448400350.21291.88.camel@scientia.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Christoph Anton Mitterer posted on Tue, 24 Nov 2015 22:25:50 +0100 as
excerpted:

>> Suppose you only want to rollback /, because some update screwed you
>> up,
>> but not /home, which is fine.  If /home is a nested subvolume, then
>> you're now mounting the nested home subvolume from some other nesting
>> tree entirely,
> That's a bit unclear to me,... I thought when I make a snapshot, any
> nested subvols wouldn't be snapshotted and thus be empty dirs.
> So I'd have rather that if I would simply have no /home (if I didn't
> move it to the rolled-back subvol manually)

What I was intending to convey but apparently failed to be quite clear 
enough, suppose:

5
|
+-+ subvols (dir)
  |
  +-+ root (subvol)
  | |
  | + home (nested subvol)
  |
  +-+ snaps-2015.0901 (dir)
    |
    +-+ root-2015.0901 (subvol)


As long as you're on the working /, then /home is a nested subvol, and 
you don't have to mount it to access, tho you can if you want.

But now, you roll back to snaps-2015.0901/root-2015.0901.

It won't have /home nested underneath, as you correctly pointed out, but 
in ordered to access it, you now MUST mount /home, which...

#1 could be a pain to setup if you weren't actually mounting it 
previously, just relying on the nested tree, AND...

#2 The point I was trying to make, now, to mount it you'll mount not a 
native nested subvol, and not a directly available sibling
5/subvols/home, but you'll actually be reaching into an entirely 
different nesting structure to grab something down inside, mounting
5/subvols/root/home subvolume nesting down inside the direct
5/subvols/root sibling subvol.

With just one level of nesting and one additional mount, it's not too 
hard to keep track of, but if you're dealing with four or five levels of 
subvol nesting and some of them you're mounting the working head copy 
while others you're rolling back, it could get difficult to keep straight 
in your head what's going on.

Consider a layout like this:

5
+-+ subvols (dir)
  |
  +-+ root (subvol)
  | |
  | +-+ home (subvol)
  | | |
  | | +-+ henry (dir, no subvol for henry)
  | | |
  | | +-+ fred (subvol)
  | | | |
  | | | +-+ vms (subvol)
  | | | 
  | | +-+ betty (subvol)
  | |
  | +-+ svr (subvol)
  |   |
  |   +-+ vms (subvol)
  |
  +-+ snaps-2015.0901 (dir)
    |
    +-+ root-2015.0901 (subvol here and below)
    |
    +-+ home-2015.0901
    |
    +-+ fred-2015.0901
    |
    +-+ fred-vms-2015.0901
    |
    +-+ betty-2015.0901
    |
    +-+ svr-2015.0901
    |
    +-+ svr-vms-2015.0901


Now, you were hacked and they encrypted a bunch of stuff, but you were 
lucky and caught them before they got everything.  You need to roll back 
root but not home, fred is fine, but his vms subvol needs rolled back, 
betty needs rolled back, svr needs rolled back, but svr's vms are fine.

Try to sort THAT out along with the nesting, and keep it all straight 
while under the severe pressure of trying to recover from a hack in time 
for those svr things to go live for Black Friday in a few hours, where in 
a single day you expect to make as much as you normally do in a month, 
the rest of the year!  The pressure is on!

Oh, and you weren't actually doing the mounts as you were depending on 
the nested tree, so you have to actually setup the mounts as well, not 
just switch them to point to the appropriate location.

OK, so that's a bit contrived, but server encryption for ransom hacks are 
in the news, black Friday starts in a few hours here, and I think the 
point should be obvious! =:^)

(Some years ago, before btrfs, I had something similar setup but with 
partitions.  Disaster struck and I ended up with / from one backup, /usr 
from another, and /var, with the package database of what was installed 
on the other two, from current, or something like that.  Needless to say 
I learned quite some lessons from that, one of which was that everything 
that the package manager installs should be on the same partition with 
the installed-package database, so if it has to be restored from backup, 
at least if it's all old, at least it's all equally old, and the package 
database actually matches what's on the system because it's in the same 
backup!  That partition and btrfs, along with each of its various 
backups, are now 8 GiB each, so it's not like I'll run out of room with 
several levels of backup.  I went mdraid after that, but after an initial 
experiment with lvm on top of the raid, I decided that was too complex to 
deal with in the pressure of a disaster and redid it to multiple raids on 
parallel partitioned hardware.  In a disaster the raid would be bad 
enough to deal with but tolerable, but I did NOT need the complexity of 
lvm on top of raid, and after dealing with the parts of three different 
installs mess, I had the hard-earned wisdom to realize it!

The same idea applies here.  Once you start reaching into nested subvols 
to get the deeper nested subvols you're trying to mount, it's too much 
and you're just begging to get it wrong under the extreme pressures of a 
disaster recovery.  Do it right and keep it mostly flat, and you'll not 
only know your basic mounts are already setup and you only have to point 
them at the rollbacks if appropriate, but you won't be having to reach 
deep into multiple arbitrary nestings to grab subvols from weird spots.  
Disaster recovery you might well be thanking me, come a few months or a 
few years from now!  =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

