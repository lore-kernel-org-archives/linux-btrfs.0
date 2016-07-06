Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:23601 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbcGFWqH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 18:46:07 -0400
Date: Wed, 6 Jul 2016 15:44:16 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH v6 00/20] xfstests: minor fixes for the reflink/dedupe
 tests
Message-ID: <20160706224416.GA26279@birch.djwong.org>
References: <146612796204.25024.18254357523133394284.stgit@birch.djwong.org>
 <20160705043130.GF23649@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160705043130.GF23649@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 05, 2016 at 12:31:30PM +0800, Eryu Guan wrote:
> Hi Darrick,
> 
> On Thu, Jun 16, 2016 at 06:46:02PM -0700, Darrick J. Wong wrote:
> > Hi all,
> > 
> > This is the sixth revision of a patchset that adds to xfstests
> > support for testing reverse-mappings of physical blocks to file and
> > metadata (rmap); support for testing multiple file logical blocks to
> > the same physical block (reflink); and implements the beginnings of
> > online metadata scrubbing.
> > 
> > The first eight patches are in Eryu Guan's pull request on 2016-06-15.
> > Those patches haven't changed, but they're not yet in the upstream
> > repo.
> > 
> > If you're going to start using this mess, you probably ought to just
> > pull from my github trees for kernel[1], xfsprogs[2], and xfstests[3].
> > There are also updates for xfs-docs[4].  The kernel patches should
> > apply to dchinner's for-next; xfsprogs patches to for-next; and
> > xfstest to master.  The kernel git tree already has for-next included.
> > 
> > The patches have been xfstested with x64, i386, and armv7l--arm64,
> > ppc64, and ppc64le no longer boot in qemu.  All three architectures
> > pass all 'clone' group tests except xfs/128 (which is the swapext
> > test), and AFAICT don't cause any new failures for the 'auto' group.
> > 
> > This is an extraordinary way to eat your data.  Enjoy! 
> > Comments and questions are, as always, welcome.
> 
> I tested your xfstests patches with your kernel(HEAD f0b34b6 xfs: add
> btree scrub tracepoints) and xfsprogs(HEAD 34bd754 xfs_scrub: create
> online filesystem scrub program), with x86_64 host & 4k block size XFS.
> 
> A './check -g auto' run looked fine overall. Besides the comments I
> replied to some patches, other common minor issues are:
> - space indention in _cleanup not tab
> - bare 'umount $SCRATCH_MNT' not _scratch_unmount
> - whitespace issues in _test|scratch_inject_error
> 
> (I can fix all these minor issues at commit time, if you don't have
> other major updates to these patches).

I don't have any major updates to any of those patches; go ahead.

FWIW I usually have unposted patches at all points in time, so if you want to
fix minor nits in things I've already posted for review and commit them to
upstream, that's fine.  I pull down the latest xfstest git and rebase prior to
sending a new patch series, so I'll absorb whatever you change. :)

When I'm getting ready to do another big release, I inquire with the
maintainers if they're about to push commits upstream to avoid the race
post patches -> upstream push -> rebase patches -> repost patches.

> And the review of changes to xfs/122 needs help from other XFS
> developers :) (09/20 and 10/20)

09/20 (remove rmapx cruft) should be pretty straightforward, since I withdrew
'rmapx' and related changes from xfs.

10/20 (new log items) will probably remain outstanding for a while since
those changes haven't really made it upstream yet.

> And besides the first 8 patches, 15/20 has been in upstream as well.

Oh, ok.

> Thanks,
> Eryu
> 
> P.S.
> The failed tests I saw when testing with reflink-enabled kernel &
> xfsprogs:
> 
> Failures: generic/054 generic/055 generic/108 generic/204 generic/356 generic/357 xfs/004 xfs/096 xfs/122 xfs/293
> 
> generic/108 generic/204 and xfs/004 are new failures compared to stock
> kernel and xfsprogs (kernel 4.7-rc5, xfsprogs 4.7-rc1).

I think I have fixes for some of those that will go out during the next
patchbomb.  But thanks for the heads up, I'll have a look at a -g auto
run before I submit again.

--D

> 
> Just FYI.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
