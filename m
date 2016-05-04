Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60693 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311AbcEDJyr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 4 May 2016 05:54:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1axtVx-0006KT-25
	for linux-btrfs@vger.kernel.org; Wed, 04 May 2016 11:54:41 +0200
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 11:54:41 +0200
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 04 May 2016 11:54:41 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Subvolumes cannot be mounted after raid1 conversion
Date: Wed, 4 May 2016 09:54:28 +0000 (UTC)
Message-ID: <pan$ebee2$82efbc86$90db3c12$ee956c44@cox.net>
References: <983F0471-51E8-47EC-B5A0-FBA9040F634B@hagenjohansen.dk>
	<20160503095515.GM7228@carfax.org.uk>
	<B66776EA-68EA-490F-862E-C49A1D51FCE5@hagenjohansen.dk>
	<20160503102746.GN7228@carfax.org.uk>
	<pan$53532$8cf28e4d$10d40c2$bb30f4bb@cox.net>
	<2a657997-6da8-a190-6057-7b5dcb5d70b1@hagenjohansen.dk>
	<e0f52464-e153-9961-57df-b45c3513ccf8@hagenjohansen.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hasse posted on Tue, 03 May 2016 20:38:14 +0200 as excerpted:

> I have found the easy solution. From
> https://bbs.archlinux.org/viewtopic.php?id=192991
> 
>     First:
> 
>     # systemctl daemon-reload
> 
>     followed by:
> 
>     # systemctl restart remote-fs.target
> 
>     or
> 
>     # systemctl restart local-fs.target
> 
>     depending on filesystem type
> 
> I still think it is pretty stupid that systemd doesn't monitor
> /etc/fstab (when choosing to create it own secret files) :)

Indeed.  And thanks for that hint about what to restart.  It will likely 
save me some time when I look into things in a bit more detail, here. =:^)

FWIW, my pet gripe about systemd filesystem via fstab handling is...  I 
have several levels of backup mountable from fstab, for example, the 
first backup root which is also btrfs raid1 on different partitions on 
the same pair of ssds as my primary btrfs raid1 root, and a second and 
third backup roots that are still reiserfs on spinning rust.  Similarly 
for home, the media partition, the distro updates tree and (since it's 
gentoo) build machinery partition, etc.

But while I have different mountpoints for the backups based on whether 
they're of root/home/media/packages, all root backups, for instance, 
share the same root-backup mountpoint, as there's little reason for me to 
mount more than one backup of a particular type at a time (and a big 
reason not to, since in theory that endangers more than one at a time 
should something go wrong).  I mount by label and all the fstab lines 
have different LABEL= first-fields, so it's fine, and has worked well for 
me for years now.

But at boot and every time I run systemctl daemon-reload or daemon-reexec 
(the latter of which I often run after updates that affected some library 
that systemd uses, so it's not running the old version and I can 
ultimately remount my / readonly again, as it is by default and except 
when updating), systemd complains about it, because its *.mount unit 
files are named after the mountpoint, and the multiple fstab entries for 
the same mountpoint means it tries to create multiple identically named 
mount unit files.

The systemd devs are very aware of the problem as I've seen discussion of 
it elsewhere, but their policy is simply only one fstab entry per 
mountpoint, and they see the failure to support more as a feature, not a 
bug.

I've always thought if I got bored I might post a message on the systemd 
discussion list and ask what their recommendation is, for people that 
don't want to uselessly track all those extra mount points for multiple 
levels of backup but still want the convenience of having the entries in 
fstab, so feeding mount just the LABEL= line works (as does the mountpoint 
for just mounting the first/default entry), just to see what sort of 
recommendation they'd have, but I know better than to think that I'd get 
them to change the policy and call systemd's failure to support the 
multiple fstab entries for a single mountpoint feature a bug, instead of 
a feature.

Oh, well...  As long as it still works in practice, as it has so far, 
systemd complaining every time I reload it, isn't going to hurt me.

But if it stops working, get out the torches and pitchforks! =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

