From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: =?utf-8?Q?=E2=80=9Cbio?= too =?utf-8?Q?big=E2=80=9D?=
 regression and silent data corruption in 3.0
Date: Tue, 16 Aug 2011 13:56:42 -0300
Message-ID: <orbovpcn1x.fsf@livre.localdomain>
References: <orwreobtuf.fsf@livre.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <orwreobtuf.fsf@livre.localdomain> (Alexandre Oliva's message of
	"Sun, 07 Aug 2011 22:00:24 -0300")
List-ID: <linux-btrfs.vger.kernel.org>

Here's some additional information and work-arounds.

On Aug  7, 2011, Alexandre Oliva <oliva@lsd.ic.unicamp.br> wrote:

> A bit of investigation showed that max_hw_sectors for the USB disk was
> 120, much lower than the internal SATA and PATA disks.

FWIW, overriding /sys/class/block/sd*/queue/max_sectors_kb of all disks
used by the filesystem to the lowest max_hw_sectors_kb works around this
problem, at least as long as you don't hit it before you get a chance to
change the setting.

> Raid0 block groups were created to hold data from single block groups
> and, if it couldn't create big-enough raid0 blocks because *any* of
> the other disks was nearly-full, removal would fail.

AFAICT this was my misunderstanding of the situation.  Apparenty btrfs
can rebalance the disk space in other partitions so as to create raid0
blocks during removal.  However, in my case it didn't because there was
some metadata inconsistency in the partition I was trying to remove that
led to block tree checksum errors being printed when it hit that part of
the partition, aborting the removal.  The checksum errors were likely
caused by the bio too big problem.

> it appears to be impossible to go back from RAID1 to DUP metadata once
> you temporarily add a second disk, and any metadata block group
> happens to be allocated before you remove it (why couldn't it go back
> to DUP, rather than refusing the removal outright, which prevents even
> single block groups from being moved?)

FWIW, I disabled the test that refuses to shrink a filesystem containing
RAID1 to a single disk and issued such a request while running this
modified kernel, and it completed successfully and perfectly.  Can we
change it from hard error to warning?

> 5. This long message reminded me that another machine that has been
> running 3.0 seems to have got *much* slower recently.  I thought it had
> to do with the 98% full filesystem (though 40GB available for new block
> group allocations would seem to be plenty), and the constant metadata
> activity caused by ceph creating and removing snapshots all the time.

AFAICT it had to do with extended attributes (heavily used by ceph),
that caused a large number of metadata block groups to be allocated,
even though only a tiny fraction of the space in them ended up being
used.  I've observed this in two of the ceph object stores.

I've also noticed that rsyncing the OSDs with all extended attributes
(-A -X) caused the source to use up a *lot* of CPU and far longer than
without.  I don't know why that is, but getfattr --dump at the source
and setfattr --restore at the target does pretty much the same, without
incurring such large CPU and time costs, so there's something to be
improved somewhere, in rsync and/or in btrfs.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
