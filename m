Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25299 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbcCXEuR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Mar 2016 00:50:17 -0400
Date: Wed, 23 Mar 2016 21:52:21 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Eryu Guan <eguan@redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] fstest: btrfs: test single 4k extent after
 subpagesize buffered writes
Message-ID: <20160324045221.GA10085@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1457396879-30572-1-git-send-email-bo.li.liu@oracle.com>
 <1458255398-26833-1-git-send-email-bo.li.liu@oracle.com>
 <20160322040013.GH11419@eguan.usersys.redhat.com>
 <20160322221225.GA6883@localhost.localdomain>
 <20160323115338.GQ11419@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160323115338.GQ11419@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 23, 2016 at 07:53:38PM +0800, Eryu Guan wrote:
> On Tue, Mar 22, 2016 at 03:12:25PM -0700, Liu Bo wrote:
> > On Tue, Mar 22, 2016 at 12:00:13PM +0800, Eryu Guan wrote:
> > > On Thu, Mar 17, 2016 at 03:56:38PM -0700, Liu Bo wrote:
> > > > This is to test if COW enabled btrfs can end up with single 4k extents
> > > > when doing subpagesize buffered writes.
> > > 
> > > What happens if btrfs is mounted with "nodatacow" option? Does it need
> > > to _notrun if cow is disabled?
> > 
> > In my test, the test passes if mounting with "nodatacow".
> > Yes, it makes sense to have a _notrun for nodatacow.
> 
> If "nodatacow" btrfs should pass the test as well, then I don't think
> _notrun is needed, so when it failed, something went wrong.

Ok, and it should pass in theory.

> 
> > 
> > > 
> > > > 
> > > > The patch to fix the problem is
> > > >   https://patchwork.kernel.org/patch/8527991/
> > > > 
> > > > Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> > > > ---
> > > > v2: - Teach awk to know system's pagesize.
> > > >     - Add "Silence is golden" to output.
> > > >     - Use local variables to lower case.
> > > >     - Add comments to make code clear.
> > > 
> > > This should be v3, and this patch was buried in the v2 thread :)
> > 
> > Oops, thanks for pointing it out.
> > 
> > > 
> > > > 
> > > >  tests/btrfs/027     | 102 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> > > >  tests/btrfs/027.out |   2 ++
> > > >  tests/btrfs/group   |   1 +
> > > >  3 files changed, 105 insertions(+)
> > > >  create mode 100755 tests/btrfs/027
> > > >  create mode 100644 tests/btrfs/027.out
> > > > 
> > > > diff --git a/tests/btrfs/027 b/tests/btrfs/027
> > > > new file mode 100755
> > > > index 0000000..19d324b
> > > > --- /dev/null
> > > > +++ b/tests/btrfs/027
> > > > @@ -0,0 +1,102 @@
> > > > +#! /bin/bash
> > > > +# FS QA Test 027
> > > > +#
> > > > +# When btrfs is using cow mode, buffered writes of sub-pagesize can end up with
> > > > +# single 4k extents.
> > > > +# Ref:
> > > > +#     "Stray 4k extents with slow buffered writes"
> > > > +#     https://www.spinics.net/lists/linux-btrfs/msg52628.html
> > > 
> > > After going through this thread, my understanding is that nodatacow
> > > btrfs should pass this test even on unpatched kernel (e.g. v4.5). But
> > > my test on v4.5 kernel failed with nodatacow mount option, pagesize
> > > extent is still found.
> > > 
> > 
> > I verified it again on my kvm box and it passed with a unpatched v4.5 kernel.
> > 
> > Can you please show me the 027.full file?
> > 
> > I can't think of a reason for this..
> 
> I'm using v4.5 kernel and v4.4 btrfs-progs, and it's not reproduced
> everytime.
> 
> SECTION       -- btrfs_nodatacow
> RECREATING    -- btrfs on /dev/sda5
> FSTYP         -- btrfs
> PLATFORM      -- Linux/x86_64 dhcp-66-86-11 4.5.0
> MKFS_OPTIONS  -- /dev/sda6
> MOUNT_OPTIONS -- -o nodatacow -o context=system_u:object_r:nfs_t:s0 /dev/sda6 /mnt/testarea/scratch
> 
> btrfs/027 28s ... - output mismatch (see /root/xfstests/results//btrfs_nodatacow/btrfs/027.out.bad)
>     --- tests/btrfs/027.out     2016-03-23 15:39:41.562000000 +0800
>     +++ /root/xfstests/results//btrfs_nodatacow/btrfs/027.out.bad       2016-03-23 19:37:38.962000000 +0800
>     @@ -1,2 +1,3 @@
>      QA output created by 027
>      Silence is golden
>     +8
>     ...
>     (Run 'diff -u tests/btrfs/027.out /root/xfstests/results//btrfs_nodatacow/btrfs/027.out.bad'  to see the entire diff)
> Ran: btrfs/027
> Failures: btrfs/027
> Failed 1 of 1 tests
> 
> And btrfs/027.full shows:
> 
> /mnt/testarea/scratch/testfile:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..28863]:      2154496..2183359 28864   0x0
>    1: [28864..57751]:  2183360..2212247 28888   0x0
>    2: [57752..85543]:  2212248..2240039 27792   0x0
>    3: [85544..113239]: 2240040..2267735 27696   0x0
>    4: [113240..113247]: 2267736..2267743     8   0x0
>    5: [113248..141999]: 2267744..2296495 28752   0x0
>    6: [142000..142023]: 2296496..2296519    24   0x0
>    7: [142024..159799]: 2296520..2314295 17776   0x1

I can barely reproduce one in 100 runs... but anyway if it is a bug,
it's not a problem in this test case, I'll send a v3 version patch and
work on this nocow case.

Thanks,

-liubo
