Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo201.cox.net ([68.230.241.216]:53913 "EHLO
	eastrmfepo201.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbaEPERX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 00:17:23 -0400
Received: from eastrmimpo306 ([68.230.241.238]) by eastrmfepo201.cox.net
          (InterMail vM.8.01.05.15 201-2260-151-145-20131218) with ESMTP
          id <20140516041722.QNFP31475.eastrmfepo201.cox.net@eastrmimpo306>
          for <linux-btrfs@vger.kernel.org>;
          Fri, 16 May 2014 00:17:22 -0400
Date: Thu, 15 May 2014 21:17:21 -0700
From: Duncan <1i5t5.duncan@cox.net>
To: russell@coker.com.au
Cc: linux-btrfs@vger.kernel.org
Subject: Re: staggered stripes
Message-ID: <20140515211721.53aaea69@ws>
In-Reply-To: <2Ee51o00g0uXw0U01Ee7j5>
References: <2751140.Zb1qMBeNgk@xev>
	<pan$a10c6$96b782de$86a74a2f$b7f37af@cox.net>
	<2Ee51o00g0uXw0U01Ee7j5>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 16 May 2014 00:38:04 +1000
Russell Coker <russell@coker.com.au> wrote:

> > You do mention the partition alternative, but not as I'd do it for
> > such a case.  Instead of doing a different sized buffer partition
> > (or using the mkfs.btrfs option to start at some offset into the
> > device) on each device, I'd simply do multiple partitions and
> > reorder them on each device.  
> 
> If there are multiple partitions on a device then that will probably
> make performance suck.  Also does BTRFS even allow special treatment
> of them or will it put two copies from a RAID-10 on the same disk?

I try to be brief, omitting the "common sense" stuff as readable
between the lines, and people don't...

What I meant is a layout like the one I have now, only staggered
partitions.  Rather than describe the ideas, here's my actual sda
layout. sdb is identical, but would have the same partitions reordered
if setup as discussed here.  These are actually SSD so the firmware
will be scrambling and write-leveling the erase-blocks in any case,
but I've long used the same basic layout on spinning rust too, tweaking
it only a bit over several generations:

# gdisk -l /dev/sda

[...]
Found valid GPT with protective MBR; using GPT.
Disk /dev/sda: 500118192 sectors, 238.5 GiB
[...]
Partitions will be aligned on 2048-sector boundaries
Total free space is 246364781 sectors (117.5 GiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048            8191   3.0 MiB     EF02  bi0238gcn1+35l0
   2            8192          262143   124.0 MiB   EF00  ef0238gcn1+35l0
   3          262144          786431   256.0 MiB   8300  bt0238gcn1+35l0
   4          786432         2097151   640.0 MiB   8300  lg0238gcn1+35l0
   5         2097152        18874367   8.0 GiB     8300  rt0238gcn1+35l0
   6        18874368        60817407   20.0 GiB    8300  hm0238gcn1+35l0
   7        60817408       111149055   24.0 GiB    8300  pk0238gcn1+35l0
   8       111149056       127926271   8.0 GiB     8300  nr0238gcn1+35l0
   9       127926272       144703487   8.0 GiB     8300  rt0238gcn1+35l1
  10       144703488       186646527   20.0 GiB    8300  hm0238gcn1+35l1
  11       186646528       236978175   24.0 GiB    8300  pk0238gcn1+35l1
  12       236978176       253755391   8.0 GiB     8300  nr0238gcn1+35l1

You will note that partitioning is GPT for reliability and simplicity,
even tho my system's standard BIOS.  You'll also note I use GPT
partition naming to keep track of what's what, with the first two
characters denoting partition function (rt=root, hm=home, pk=package,
etc), and the last denoting working copy or backup N.[1]

Partition #1 is BIOS reserved -- that's where grub2 puts it's core.  It
starts at the 1 MiB boundary and is 3 MiB, so everything after it is on
a 4 MiB boundary minimum.

#2 is EFI reserved, so I don't have to repartition if I upgrade to
UEFI and want to try it.  It starts at 4 MiB and is 124 MiB size, so
ends at 128 MiB, and everything after it is at minimum 128 MiB
boundaries.

Thus the first 128 MiB is special-purpose reserved.  Below that,
starting with #3, are my normal partitions, all btrfs, raid1 both
data/metadata except for /boot.

#3 is /boot.  Starting at 128 MiB it is 256 MiB size so ends at 384 MiB.

Unlike my other btrfs, /boot is single-device dup-mode mixed-bg, with
its primary backup on the partner hardware device (sda3 and sdb3,
working /boot and and primary /boot backup).  This is because
it's FAR easier to simply point the grub on each device at its
own /boot partition, using the BIOS boot-device selector to
decide which one to boot, than it is to dynamically tell grub to
use a different /boot at boot-time (tho unlike with grub1, with grub2
it's actually possible due to grub rescue mode).

Btrfs dup-mode-mixed-bg effectively means I have only half capacity,
128 MiB, but that's enough for /boot.

#4 is /var/log.  Starting at 384 MiB it is 640 MiB in size (per device),
so it ends at the 1 GiB boundary and all partitions beyond it are whole
GiB sized so begin and end on whole GiB boundaries.  As it's under a
GiB per device it's btrfs mixed-bg mode, not separate data/metadata,
and btrfs raid1.

Unlike my other btrfs, log has no independent backup copy as I don't
find a backup of /var/log particularly useful.  But like the others
with the exception of /boot and its backup, it's btrfs raid1, so losing
a device doesn't mean losing the logs.

I'd probably leave the partitions thru #4 as-is, since they're sub-GiB
and end on a GiB boundary.  If /var/log happens to be on a weak part of
the device, oh, well, I'll take the loss, /boot is independent with the
backup written far less than the working copy anyway, so if that's a
weak spot, the working copy should go out first, with plenty of warning
before the 

The next 8 partitions are split into two sets of four.  All are btrfs
raid1 mode for both data and metadata.

#5 is root (/).  It's 8 GiB and contains very nearly
everything that the package manager installs including the package
database, with the exception of /var/log as mentioned above and
some /var/lib/ subdirs as discussed below.  I once had a tough disaster
recovery where I ended up restoring from root, /usr and /var from
backups done at three separate times, such that after the initial
recovery the installed package database on /var didn't match what was
actually on either the rootfs (including /etc) or /usr.  *NEVER*
*AGAIN*!!  It's (almost) all on the same partition and backup now, so
while I might end up restoring from an old backup, the package
installation database will always be in sync with what's actually
installed.  The "(almost)" is log and state and if they're out of sync
I can just blow them away and start over, but all documentation and
configuration files as well as the actual operational files for a
package will remain synced.

8 GiB is plenty for my installation.  Btrfs fi show says the devices
are only 4.53 GiB used.  Btrfs raid1 both data/metadata.

#6 is /home.  It's 20 GiB, which is enough, given I have a separate,
dedicated media partition (on spinning rust as access is reasonably
sequential and doesn't need the speed of ssd so I save on cost too,
and it's actually not btrfs). Btrfs raid1 both data/metadata.

#7 is distro package tree and cache.

I run gentoo so the distro package tree means build-scripts, and cached
sources.  I have the binpkg feature set, however, so I keep tarballed
binpkg backups of all packages needed for a complete reinstall, plus a
reasonable binpkg version history, in case I need to roll back.  In
addition to the build-scripts and source tarballs, the binpkgs are on
this filesystem too.  And I run ccache to speed up builds, with ccache
located on the packages filesystem too.

Additionally, I keep a second, independent set of binpkgs and ccache
for my 32-bit-only netbook, and that's on this partition too.  That's
why it's so big, 24 GiB, as it contains the distro tree and source
tarballs, plus both the binpkg tarballs and ccache for two independent
build sets.

Btrfs raid1 both data/metadata, of course.

#8 is the netbook's rootfs build image. Again, 8 GiB, just as is the
main rootfs.

That's the first set of four partitions, my working copy set, 60 GiB
total, beginning at 1 GiB so ending at 61 GiB.

The second set of four partitions mirrors the first set in size and
function, forming my first/primary backup, on the same pair of SSD
physical devices.  So it's 60 GiB total also, ending at 121 GiB.

The SSDs are 238.5 GiB (256 GB SI units) in size, so I've only actually
allocated just under 51% of the SSDs, plenty of overprovisioning to
allow the firmware lots and lots of room to do its wear-leveling.

Given that these ARE SSDs and the firmware DOES do wear-level
shuffling, I don't see the point in staggering the partitions here and
the layouts are identical on both, with btrfs using sda5/sdb5 as my
working root partition, for instance. However were I on spinning rust,
I'd likely setup the btrfs raid1s such that working root was sda5/sdb9
while backup root was sda9/sdb5, thus staggering the partitions on each
device, while each filesystem would still consist of only a single
partition on each device.

*THAT* is what I meant.

---
[1]  I have a standard scheme I use for both partition and filesystem
names/labels that allows me to uniquely identify devices partitions and
filesystems by function, size, brand, target machine,
intended-working-copy or backup number, etc.  Only the first two
characters, partition/filesystem function, and the last character,
working copy (0) or backup N, are of interest for this post, however.

-- 
Duncan - No HTML messages please, as they are filtered as spam.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman
