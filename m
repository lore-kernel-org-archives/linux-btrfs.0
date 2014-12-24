Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:33491 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbaLXD2A (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Dec 2014 22:28:00 -0500
Date: Wed, 24 Dec 2014 14:27:25 +1100
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Filipe David Manana <fdmanana@gmail.com>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + corrupt
 script fsck test case.
Message-ID: <20141224032725.GM4521@dastard>
References: <1418615699-18169-1-git-send-email-quwenruo@cn.fujitsu.com>
 <CAL3q7H5TrEGT87by4Zgs_Gy-OagBBEQVdk0A54snC9334wRP1w@mail.gmail.com>
 <CAL3q7H5XAR1UBYeNzcV6AXRFEpN7=gZ2znDycsDDE2opLovK3g@mail.gmail.com>
 <20141215181953.GT27601@twin.jikos.cz>
 <548F8C4E.4020905@cn.fujitsu.com>
 <CAL3q7H4tTSshBauZc8J7OgQhMSf=ks9qt9qLGCVHF9Rep-ULLg@mail.gmail.com>
 <20141224000354.GJ4521@dastard>
 <549A2B44.5020103@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <549A2B44.5020103@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 24, 2014 at 10:56:04AM +0800, Qu Wenruo wrote:
> 
> -------- Original Message --------
> Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image +
> corrupt script fsck test case.
> From: Dave Chinner <david@fromorbit.com>
> To: Filipe David Manana <fdmanana@gmail.com>
> Date: 2014年12月24日 08:03
> >[ Sorry to take some time to get to this, it got caught by a spam
> >filter and I only just noticed. ]
> >
> >On Tue, Dec 16, 2014 at 02:08:53PM +0000, Filipe David Manana wrote:
> >>On Tue, Dec 16, 2014 at 1:35 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> >>>-------- Original Message --------
> >>>Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + corrupt
> >>>script fsck test case.
> >>>From: David Sterba <dsterba@suse.cz>
> >>>To: Filipe David Manana <fdmanana@gmail.com>
> >>>Date: 2014年12月16日 02:19
> >>>>On Mon, Dec 15, 2014 at 10:13:45AM +0000, Filipe David Manana wrote:
> >>>>>>So another thing I would like to see is doing a more comprehensive
> >>>>>>verification that the repair code worked as expected. Currently we
> >>>>>>only check that a readonly fsck, after running fsck --repair, returns
> >>>>>>0.
> >>>>>>
> >>>>>>For the improvements you've been doing, it's equally important to
> >>>>>>verify that --repair recovered the inodes, links, etc to the
> >>>>>>lost+found directory (or whatever is the directory's name).
> >>>>>>
> >>>>>>So perhaps adding a verify.sh script to the tarball for example?
> >>>>>Or, forgot before, it might be better to do such verification/test in
> >>>>>xfstests since we can create the fs and use the new btrfs-progs
> >>>>>programs to corrupt leafs/nodes. xfstests has a lot of infrastructure
> >>>>>already and probably run by a lot more people (compared to the fsck
> >>>>>tests of btrfs-progs).
> >>>>I'm thinking about the best way how to integrate that, but it seems that
> >>>>there will be always some level of code or infrastructure duplication
> >>>>(or other hassle).
> >>>>
> >>>>btrfs-corrupt-block is not installed by default (make install) and it's
> >>>>not a type of utility I'd consider for default installations. The tests
> >>>>would be skipped in absence of the utility, so there will be test
> >>>>environments where "install xfstests, install btrfspprogs" will not add
> >>>>the desired test coverage. Solvable by packaging the extra progs.
> >>>>
> >>>>Adding corrupt-block into xfsprogs is infeasible (IMO too much code from
> >>>>btrfs-progs to be added).
> >>>>
> >>>>I don't know how much infrastructure code we'd have to either write or
> >>>>copy from fstests, but I think it would not be that much. Ideally we
> >>>>could write the tests within btrfs-progs and then submit them to fstests
> >>>>once they're considered reliable. If we keep the same "syntax" of the
> >>>>tests, provide stubs where applicable, the code duplication in test
> >>>>itself would be zero. We'd only have to write the stubs in btrfs-progs
> >>>>and probably extend fstests to provide helpers for preparing/unpacking
> >>>>the images.
> >>>In my wildest idea, if we have a good enough btrfs debugger(maybe even
> >>>stronger than debugfs), which can
> >>>do almost everything from read key/item to corrupt given structure, then we
> >>>can resolve them all.
> >>>No binary image since corruption can be done by it and verify can also done
> >>>by it.
> >>>(OK, it's just a daydream)
> >>>
> >>>But IMHO, isn't xfstests designed to mainly detect kernel defeats?
> >>>I don't see any fsck tool test case in it.
> >>I don't think xfstests is specific to test the kernel implementation
> >>of filesystems. I believe it includes user space code too, but I might
> >>be wrong so I'm CCing fstests and Dave to get an authoritative answer.
> >We use fstests to test everything we ship for XFS - kernel and
> >userspace. i.e. we have tests that corrupt filesystems with xfs_db
> >and then test that xfs_repair can fix them, and once fixed the
> >filesystem can be mounted and used by the kernel...
> >
> >i.e. fstests is for testing both the kernel code and the utilities
> >used to manipulate filesystems.
> That's great.
> 
> But what will happen if some btrfs cases need binary(still huge even
> compressed) or
> btrfs-image dump(some existing dumps are already several MB)?
> Will it be OK for fstests?

No. Random filesystem images don't make a regression test. They are
just different encoding of the game of whack-a-mole. Corruption
recovery tests work best with simple, obvious corruptions. This
makes it easy to make sure correct detection and recovery behaviour
works without any other complications.

e.g. overwriting the primary superblock with zeros is a simple test
that every filesystem recovery tool should be able to handle.

> Or should we wait until btrfs-progs has a good debug tools like
> xfs_db or debugfs and use
> them to generate the corrupted image like xfs testcases do?

You don't need a tool like xfs_db to do repeatable structure
corruption - you can do this with dd by writing to known offsets.

xfs_db just makes that really easy by having a filesystem format
parser that means finding the offset we want to write to is
trivial....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
