Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55924 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbdGOAsi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Jul 2017 20:48:38 -0400
Date: Fri, 14 Jul 2017 17:48:28 -0700
From: Marc MERLIN <marc@merlins.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-ID: <20170715004828.f4bom5wq34abe4lz@merlins.org>
References: <20170711062155.hvlx5ud4zphpzjnp@merlins.org>
 <CAJCQCtREGq4i5mn+PPB__dFLBvo8YrDeU_=GPHdzD1CuVYAfwg@mail.gmail.com>
 <20170711164812.sj64s3nc2oe3ai3n@merlins.org>
 <20170713011056.GW30689@merlins.org>
 <CAJCQCtSojaaS7=7dskDR3k4TwyE-qNGXFytLTyRHNXhzxyqDDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtSojaaS7=7dskDR3k4TwyE-qNGXFytLTyRHNXhzxyqDDg@mail.gmail.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 12:17:16PM -0600, Chris Murphy wrote:
> Well I'd say it's a bug, but that's not a revelation. Is there a
> snapshot being deleted in the approximate time frame for this? I see a

Yep :)
I run btrfs-snaps and it happens right aroudn that time.
It creates a snapshot and deletes the oldest one.
There is likely a race condition if you delete a or more snapshots just
after creating one on the same subvolume, although this has worked for
about 3 years up to now.
http://marc.merlins.org/perso/btrfs/post_2014-03-21_Btrfs-Tips_-How-To-Setup-Netapp-Style-Snapshots.html
http://marc.merlins.org/linux/scripts/btrfs-snaps

Sure, I can start adding sleeps between creation and deletion, but I
haven't had to so far.

> snapshot is being cleaned up and chunks being removed. So I wonder if
> this can be avoided or intentionally triggered by manipulating
> snapshot deletion coinciding with the workload? Maybe it's a race, and
> that's why it hits EEXIST, and if so then it's just getting confused
> and needs to start from scratch - if true then it's OK to just umount
> and mount (rw) again and continue on.
 
which is what I've been doing.

> There are some changes in the code between 4.9.36 and 4.12.1 (not sure
> when the change was introduced, or if it alters whether you hit this
> bug)

I don't think I hit the bug with 4.11 or 4.12 since I didn't stay on it
long enough to know for sure (I don't think I hit the bug on 4.11, but
with the corruption issues I had which I'm still not sure were due to
other factors or the kernel, I've rolled back as discussed earlier.

On my biggest system, I'm still debugging an issue with 3 of my 8 drives
get pseudo randomly kicked out after returning corrupted data for a few
seconds. I'm pretty sure it's not an issue with the drives, but I'm not
sure if it's the disk carrier/enclosure, cables, or actual ports on the
SAS card (working through the option matrix to find out)

> Another thing I'm not certain of is if the dm-2 reference is just how
> it's referring to the file system, or if it's to be taken literally as
> an issue with this device. My understanding of the code is really
> weak, but I think this whole trace is within Btrfs logical block
> handling, in which case it wouldn't know of a problem with a
> particular device. It knows that it's in the weeds, but has no idea
> what golf course it's on.

dm-2 is correct, it does refer to the correct device.

gargamel:~# dmsetup status -v dshelf1
Name:              dshelf1
State:             ACTIVE
Read Ahead:        8192
Tables present:    LIVE
Open count:        1
Event number:      1
Major, minor:      253, 2
Number of targets: 1
UUID: CRYPT-LUKS1-3cd9bbafa2bb44a587a658a77487ee73-dshelf1_unformatted
0 46883102704 crypt 
gargamel:~# l /dev/mapper/dshelf1 /dev/dm-2 
brw-rw---- 1 root disk 253, 2 Jul 14 06:30 /dev/dm-2
lrwxrwxrwx 1 root root      7 Jul 14 06:30 /dev/mapper/dshelf1 -> ../dm-2

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
