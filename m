Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42892 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbbFFGUL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 6 Jun 2015 02:20:11 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z17Sd-0007Mp-PH
	for linux-btrfs@vger.kernel.org; Sat, 06 Jun 2015 08:20:04 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Jun 2015 08:20:03 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Jun 2015 08:20:03 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: checksum error on vmem file
Date: Sat, 6 Jun 2015 06:19:55 +0000 (UTC)
Message-ID: <pan$5cc39$12a02726$5f9dae2$66967953@cox.net>
References: <CAG+QAKViMuK4WRp9e89izd7nFcckp-aq0eEmG+peBK-5RKVsGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Rauenzahn posted on Fri, 05 Jun 2015 15:50:26 -0700 as excerpted:

> I get this error occasionally on the same file.  I suspect it is some
> interaction between vmware server and btrfs.  Besides this error, I have
> no ill effects.
> 
> Is this a known issue?  Is it something that ought to be investigated to
> improve btrfs?
> 
> I might be able to help find the right folks at vmware...
> 
> Rich
> 
> Fri Jun  5 15:43:41 2015: Jun  5 15:43:41 tendo kernel: BTRFS: checksum
> error at logical 2253263028224 on dev /dev/sde1, sector 2382346400, root
> 257, inode 610942, offset 908943360, length 4096, links 1 (path:
> VMs/Ubuntu 64-bit/564dc367-07ae-10b5-bff0-8762c109606c.vmem)

Non-dev list-regular answer...

The problem in /general/ (not sure about the details) is known and has 
been seen before on, among other things, VMs running MS Windows.

What's very likely happening is that inside the kernel, vmware is sending 
btrfs data to be saved using direct-IO (normal cached access doesn't 
normally have this issue as the rules are stricter), but then modifying 
it "in flight", after sending the pointer and after btrfs has calculated 
or is calculating the checksum, but before btrfs has fully saved it to 
the filesystem.  The correct fix of course is "don't do that", don't 
modify the data after it has been handed to btrfs, but...

One possible user-side workaround is to ensure that the files in question 
are set NOCOW, chattr +C.  This turns off copy-on-write, checksumming, 
and btrfs-side compression, all three, and can have efficiency 
(fragmentation, etc) benefits for generally large (multi-gig) VM image 
files as well, tho obviously you lose the benefits of those btrfs 
features in the process.

There is a NOCOW caveat related to btrfs snapshotting, however, as 
snapshotting locks in place the existing version, such that file blocks 
effectively become COW1, copied the first time they are modified after 
the snapshot, after which they are modified in-place again until the next 
snapshot.  For folks doing frequent (more than once a day up to once a 
minute) snapshotting, this can almost nullify the anti-fragmentation 
effects of the nocow, depending on how active the file in question is, 
vs. snapshotting frequency.

An additional limitation of btrfs nocow is that it needs set when the 
file is zero-sized, before it has content, in ordered to take effect 
properly.  The easiest way to ensure this is to set the attribute on the 
directory in which the nocow files are created, so they inherit the 
attribute from the directory at creation.  For existing files, move them 
elsewhere and then copy them back after setting the attribute on the dir.  
The copy back should be handled such that a new file is created, not 
simply a reflink to the old one.  This can be ensured by either moving to 
a different filesystem (for files upto a few gigs I use my tmpfs-based 
/tmp for this) so the file /has/ to be recreated, or by cat-ing the file 
into place using redirection: cat oldfile > newfile.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

