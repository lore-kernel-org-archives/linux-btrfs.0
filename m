Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44398 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbaLTBdc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 20:33:32 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Y28vB-0000Fn-T7
	for linux-btrfs@vger.kernel.org; Sat, 20 Dec 2014 02:33:30 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 02:33:29 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Dec 2014 02:33:29 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs is using 25% more disk than it should
Date: Sat, 20 Dec 2014 01:33:10 +0000 (UTC)
Message-ID: <pan$5ee96$62de2cb1$5eb9b857$32dd0ff2@cox.net>
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>
	<54947432.5010107@ubuntu.com>
	<CAN6BF2JoMki_KmpmVYVM-_ECqCg_w-qo9_6P=MiZbabMQyVN_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Daniele Testa posted on Sat, 20 Dec 2014 03:59:42 +0800 as excerpted:

> The file has both checksums and datacow on it. I will do "chattr +C"
> on the parent dir and re-create the file to make sure all files are
> marked as "nodatacow".
> 
> Should I also turn off checksums with the mount-flags if this filesystem
> only contain big VM-files? Or is it not needed if I put +C on the parent
> dir?

FWIW...

Turning off datacow, whether by chattr +C on the parent dir before 
creating the file, or via mount option, turns off checksumming as well.  
(For completeness, it also turns off compression, but I don't think that 
applies in your case.)

In general, active VM images (and database files) with default flags tend 
to get very highly fragmented very fast, due to btrfs' default COW on a 
file with a heavy "internal rewrite" pattern (as opposed to append-only 
or full rename/replace on rewrite).  For relatively small files with this 
rewrite pattern, think typical desktop firefox sqlite database files of a 
quarter GiB or less, the btrfs autodefrag mount option can be helpful, 
but because it triggers a rewrite of the entire file, as filesize goes 
up, the viability of autodefrag goes down, and at somewhere around half a 
gig, autodefrag doesn't work so well any more, particularly on very 
active files where the incoming rewrite stream may be faster than btrfs 
can rewrite the entire file.

Making heavy-internal-rewrite pattern files of over say half a GiB in 
size nocow is one suggested solution.  However, snapshots lock in place 
the existing version, causing a one-time COW after a snapshot.  If people 
are doing frequent automated snapshots (say once an hour), this can be a 
big problem, as the file ends up fragmenting pretty badly with these 1-
cow writes as well.  That's where snapshots come into the picture.

There are ways to work around the problem (put the files in question on a 
subvolume and don't snapshot it as often as the parent, setup a cron job 
to do say weekly defrag on the files in question, etc), but since you 
don't have snapshots going anyway, that's not a concern for you except as 
a preventative -- consider it if you /do/ start doing snapshots.

So anyway, as I said, creating the file nocow (whether by mount option or 
chattr) will turn off checksumming too.  But on something that frequently 
internally rewritten, where corruption will very likely corrupt the VM 
anyway and there's already mechanisms in place to deal with that (either 
VM integrity mechanisms, or backups, or simply disposable VMs, fire up a 
new one when necessary), at least with btrfs single-mode-data where 
there's no second copy to restore from if the checksum /does/ fail, 
turning off checksumming isn't necessarily as bad as it may seem anyway.

And it /should/ save you some on the metadata... tho I'd not consider 
that savings worth turning off checksumming if that were the /only/ 
reason, on its own.  The metadata difference is more a nice side-effect 
of an already commonly recommended practice for large VM image files, 
than something you'd turn off checksumming for in the first place.  
Certainly, on most files I'd prefer the checksums, and in fact am running 
btrfs raid1 mode here specifically to get the benefit of having a second 
copy to retrieve from if the first attempted copy fails checksum.  But VM 
images and database files are a bit of an exception.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

