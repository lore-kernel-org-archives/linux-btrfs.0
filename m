Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:37661 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab3KPUeM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Nov 2013 15:34:12 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VhmZH-0002HS-AN
	for linux-btrfs@vger.kernel.org; Sat, 16 Nov 2013 21:34:11 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 21:34:11 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Nov 2013 21:34:11 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs fi show
Date: Sat, 16 Nov 2013 20:33:47 +0000 (UTC)
Message-ID: <pan$daf92$6b3b3c71$c97cb6b7$f9d238aa@cox.net>
References: <528787FB.4040100@czarc.net>
	<8A471BDA-8355-4267-BA6F-44046F6422BD@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Sat, 16 Nov 2013 09:04:31 -0700 as excerpted:

> On Nov 16, 2013, at 7:58 AM, Gene Czarcinski <gene@czarc.net> wrote:
> 
>> I am on Fedora 20-Beta and we just updated to btrfs-progs
>> 0.20.rc1-20131114git9f0c53f
>> 
>> Previously, when you did a btrfs fi show, you got a list with one
>> output for each btrfs storage volume whether it was a single device or
>> multi-device volume.
>> 
>> Now, I get multiple outputs for each storage volume.  For example, I
>> have a system with two SSDs as one btrfs storage volume and two USB
>> round-and-brown disks as a second btrfs storage volume.  Each has three
>> subvols defined and mounted.
>> 
>> Previously, I got two outputs; one for each volume.
>> 
>> Now I get three outputs for the SSD storage volume and SIX outputs for
>> the out volume.
>> 
>> Is this a bug or a feature?  If it is a feature, what is it telling me?
> 
> I filed a bug on it.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=1031299

As I understand things based on the on-list patch-flow and discussion as 
well as reading the git commit log and current manpages, previously the 
output was potentially outdated; if a mkfs.btrfs had just been run, a 
btrfs device add had been issued, or a btrfs device delete had just 
completed, and a btrfs device scan had not been run since, the output 
(sometime?) didn't reflect the most current state, sometimes surprising 
users.

Here's the relevant git commit from the git whatchanged log:

commit dde4b9214162d994f0190e42f53d2e1d6fdcc893
Author: Anand Jain <anand.jain@oracle.com>
Date:   Tue Oct 8 11:41:40 2013 +0800

    btrfs-progs: use BTRFS_SCAN_LBLKID as default scan in filesystem show

    btrfs progs has to scan for the btrfs disks for two main reasons,
     one to register them with the btrfs kernel (under btrfs dev scan)
     2nd to report btrfs disks to the user (under btrfs fi show)
     (there few more minor reasons like check_mounted etc..).

     To facilitate the scan, in total we have the following methods
     to scan for the btrfs

     BTRFS_SCAN_PROC
      which uses the /proc/partitions to look for the disks, when
      scanning it does it twice first would look for non dm- paths
      and in the 2nd scan it would pick only dm- paths.

     BTRFS_SCAN_DEV
      which scans all the block dev under /dev as they appear during
      scanning.

     BTRFS_SCAN_LBLKID
      this uses the library functions provided  by the lblkid to get
      only disks which contains the btrfs SB.

     The better method to use would be BTRFS_SCAN_LBLKID for the obvious
     reasons we don't have to reinvent that feature with in btrfs-progs.

     For the btrfs fi show - This patch will..
       - make BTRFS_SCAN_LBLKID as the default scan option

       (BTRFS_SCAN_DEV is accessible under the option --all-devices and
       BTRFS_SCAN_PROC won't be used by btrfs fi show any more)
    
    Signed-off-by: Anand Jain <anand.jain@oracle.com>
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Chris Mason <chris.mason@fusionio.com>

 cmds-filesystem.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

And the following commit:

commit b4c3cd0bbc68ca61b69cd58b1faadc995e2bf77c
Author: Anand Jain <anand.jain@oracle.com>
Date:   Fri Oct 11 19:52:53 2013 +0800

    btrfs-progs: device scan use BTRFS_SCAN_LBLKID by default

    with this patch, BTRFS_SCAN_LBLKID (which leverages lblkid
    to look for btrfs disks) would be the default scan method
    to look for the btrfs disks. And thus the output as seen
    in the latest btrfs fi show and btrfs fi show -m for the
    mounted disks will have the consistent disks path.
    (it was inconsistent (across disks) because btrfs dev scan
    provided a different path from the mount command eg. below)

        devid    1 size 1.98GiB used 435.00MiB path /dev/mapper/mpatha
        devid    2 size 2.00GiB used 415.00MiB path /dev/dm-1
     
    Signed-off-by: Anand Jain <anand.jain@oracle.com>
    Signed-off-by: David Sterba <dsterba@suse.cz>
    Signed-off-by: Chris Mason <chris.mason@fusionio.com>

 cmds-device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)



>From that you can look back on the patches on-list and their discussion, 
if desired.

Meanwhile, behavior from previous /has/ changed, making things a bit 
confusing for people already using this after all still officially 
experimental and thus prone to changing UI product, but that's something 
people testing still officially unstable product get used to after 
awhile.  At some point the interface and behavior should settle down and 
be subject to rather less change.

So here's the relevant btrfs manpage snippet (reformatted for posting):

filesystem show [--mounted|--all-devices|<uuid>]

Show the btrfs filesystem with some additional info. If no option or UUID 
is passed, btrfs shows information of all the btrfs filesystem both 
mounted and unmounted. If --mounted is passed, it would probe btrfs 
kernel to list mounted btrfs filesystem(s); If --all-devices is passed, 
all the devices under /dev are scanned; otherwise the devices list is 
extracted from the /proc/partitions file.


And the filesystem show --help output:

usage: btrfs filesystem show [options|<path>|<uuid>]

Show the structure of a filesystem

-d|--all-devices   show only disks under /dev containing btrfs filesystem
-m|--mounted       show only mounted btrfs
If no argument is given, structure of all present filesystems is shown.


Meanwhile, in plain English based on my observation here, the new 
behavior works like this:

1) If you run a generic btrfs filesystem show (without options or path), 
you *WILL* likely get the same base filesystem listed multiple times, as 
the default lookup appears to get the info from at least two different 
places, one appearing right away that only appears to include currently 
mounted filesystems, then a pause, then a more complete listing that 
includes currently unmounted btrfs volumes as well.

2) If you use -m (mounted only), you'll still get dups as the information 
apparently still comes from two different kernel lists, but the list 
won't include unmounted filesystems and the pause will be gone as the 
lookup won't have to scan for the unmounted ones.

3) If you use -d, you'll get a different list, based on devices in /dev 
so it includes unmounted filesystems (and thus the pause), but at least 
here, this list is BOTH comprehensive AND avoids dups!

However, I don't have device-mapper turned on in my kernel (thus no lvm2 
or similar volumes), so I'm unsure the practical effect on systems that 
use it.

4) If you're only looking for information on a specific filesystem, use 
the optional path/uuid parameter.  This can be either the mountpoint (if 
the filesystem is mounted) or a component device-path.  If you use 
component device, however, you /might/ get multiple listings for 
subvolumes too -- I don't know as I prefer the not having all my data 
eggs in the same filesystem basket and thus use independent partitions, 
not subvolumes, here.

But ($>> indicating my prompt, being preceded by <LF> so there's a blank 
line between commands, other lines being output):

$>>btrfs filesystem show /
Label: rt0238gcnx+35l0  uuid: 886dcca6-29b4-4e6e-8cdc-8a8ea435d510
        Total devices 2 FS bytes used 1.91GiB
        devid    1 size 8.00GiB used 3.53GiB path /dev/sdc5
        devid    2 size 8.00GiB used 3.53GiB path /dev/sda5

Btrfs v0.20-rc1-596-ge9ac73b

>>s btrfs filesystem show /dev/sda5
Label: rt0238gcnx+35l0  uuid: 886dcca6-29b4-4e6e-8cdc-8a8ea435d510
        Total devices 2 FS bytes used 1.91GiB
        devid    1 size 8.00GiB used 3.53GiB path /dev/sdc5
        devid    2 size 8.00GiB used 3.53GiB path /dev/sda5

Btrfs v0.20-rc1-596-ge9ac73b

$>>


Bottom line, try either btrfs filesystem show -d, or btrfs filesystem 
show <path>.  Both avoid dups here (tho using component device path may 
produce dups if you use subvolumes, but using mountpoint shouldn't), 
while -d is comprehensive and path limits display to just the filesystem 
of interest.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

