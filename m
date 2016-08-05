Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:47455 "EHLO
	blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbcHENPI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Aug 2016 09:15:08 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1bVexk-0007cz-HJ
	for linux-btrfs@vger.kernel.org; Fri, 05 Aug 2016 15:14:56 +0200
To: linux-btrfs@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the "usual"
 problem
Date: Fri, 05 Aug 2016 15:14:39 +0200
Message-ID: <57A4913F.1060406@5t9.de>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com> <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com> <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com> <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com> <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com> <20160109202659.GC6060@carfax.org.uk> <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com> <20160109210429.GD6060@carfax.org.uk> <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com> <5693A8B3.2090508@gmail.com> <CA+9GZUjj8a=drg7--p-f02+QXLo7aWMyZd3O8TA9gTyGWb3MLA@mail.gmail.com> <CA+9GZUg-6WrQTgCw_AmVb2qqr4aL4xeWH6mSq1zQ14qbxextzA@mail.gmail.com> <CA+9GZUgb=h9_t5fXH-qP_-MwKkoN4xLhhYNnCthccA114+KaeQ@mail.gmail.com> <57A372F3.5090400@5t9.de> <CAJCQCtSFcJd+ac+Awfwuzdhuf8xjf8EgMQNwq_aV3udaZmZ=5A@mail.gmail.com> <57A470C7.2080304@5t9.de> <f64a719e-fdca-54d8-7636-9e5ba44e0aef@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <f64a719e-fdca-54d8-7636-9e5ba44e0aef@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/05/2016 02:12 PM, Austin S. Hemmelgarn wrote:

 > If you stick to single disk

We do, all our btrfs filesystems reside on one single block device,
redundancy is provided by a DRBD layer below.

 > don't use quota groups

We don't use any quotas.

 > stick to reasonably sized filesystems (not more than a few TB)

We do, currently 4 TB max, because that's the only way to utilize
different physical storage devices for different filesystem instances
such that we can backup them in parallel within reasonable time.

 > and avoid a couple of specific unconventional storage configurations below it

Configurations like what?

 > The whole issue with
 > databases is often a non-issue for desktop users in my experience

Well, try a "cat" on a sqlite file that has been used by some ordinary
desktop software (like a browser) for a year - and you'll experience
horrible performance, due to the extreme amount of fragments.

(Having to manually "de-fragment" a filesystem periodically is something
that I had considered a thing of the past when I started using BSD's hfs
instead of the Amiga FFS in the late 1980s... ;-)

 > and if you think VM image
 > performance is bad, you should really be looking at using real block storage instead of a file
 > (seriously, this will usually get you a bigger performance boost than using ext4 or XFS
 > over BTRFS as an underlying filesystem will).

Sure, assigning block devices to each VM would be even better, but
also much less convenient for operations. It's a feature here that any
user can start a new VM instance (without root privileges) at any
time, and that the images used by those VMs are part of the incremental
backup that stores only differences, not "whole files that have been changed".

 >> We sure do - actually, the possibility to "run daily backups from a
 >> snapshot while write performance remains acceptable" is the one and
 >> only reason for me to use btrfs rather than xfs for those $HOME dirs.
 >> In every other aspect (stability, performance, suitability for
 >> storing VM-images or database-files) xfs wins for me.
 >> And the btrfs advantage "file system based snapshot being more
 >> performant than block device based snapshot" may fade away
 >> with the replacement of magnetic disks with SSDs in the long run.
 > I'm going to respond to the two parts of this separately:
 > 1. As far as snapshot performance, you'd be surprised. I've got pretty good consumer grade SSD's
 > that can do a sustained 250MB/s write speed, which means that to be as fast as a snapshot,
 > the data set would have to be less than 25MB

No, I'm talking about LVM snapshots, which utilitze Copy-On-Write
on the block device level. Creating such an LVM snapshot is
as quick as creating a btrfs snapshot, regardless of the size.
The only significant draw-back of the LVM snapshot is that whenever
data is written to the filesystem, that causes copy operations from
one part of the (currently magnetic) storage to another part, and
that seriously hurts the write performance.

(Of course, it would not be a reasonable option to take a block device
snapshot by first copying all the data on it.)

 > 2. As far as snapshots being the only advantage of BTRFS, that's just bogus.
 > XFS does have metadata checksumming now, but that provides no protection for
 > data, just metadata.

We check for bit-rot on the block device level, DRBD verifies the integrity
of the data by reading from both redundant storage devices and comparing the
checksums, periodically every week.

So far, we never encountered a single bit-rot error, even though the underlying
physical storage devices are "cheap SATA disks".

 > XFS also doesn't have transparent compression support

I have no use for that. Disk space is relatively cheap, cheap enough
that we don't bother with RAID-5 or such, but use the "full redundancy"
provided by a shared-nothing DRBD setup.

 > filesystems can't be shrunk

I enlarged XFS filesystems multiple times while in use, which worked well.
I never had to shrink a filesystem, and I cannot imagine how such a use case
could occur to me.

 > and it stores no backups of any metadata except super-blocks.

Which is fine with me, as redundancy is provided on the block device level
by DRBD.

 > While the compression and filesystem shrinking may not be needed in
 > your use case, the data integrity features are almost certainly an advantage.

Btrfs sure has some nifty features, and I understand that for some
stuff like "subvolumes" or "deduplication" are important.

But a hundred great features cannot make up for a lack of stability,
therefore I would love to see those ENOSPC-related issues to
be resolved rather than more fancy features being built :-)

Regards,

Lutz Vieweg

