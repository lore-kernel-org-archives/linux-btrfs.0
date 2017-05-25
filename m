Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941405AbdEYD0n (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 23:26:43 -0400
Date: Thu, 25 May 2017 11:26:41 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: common: Make _test_mount to include
 MOUNT_OPTIONS to allow consistent _test_cycle_mount
Message-ID: <20170525032641.GA23805@eguan.usersys.redhat.com>
References: <20170523080205.12556-1-quwenruo@cn.fujitsu.com>
 <20170523111350.GZ7250@eguan.usersys.redhat.com>
 <68cba4cb-538a-c689-e13a-70028ca0fc0a@cn.fujitsu.com>
 <20170524042434.GH7250@eguan.usersys.redhat.com>
 <ee8c072d-cc4d-1023-bd8c-ac7adb4f301c@cn.fujitsu.com>
 <20170524050854.GI7250@eguan.usersys.redhat.com>
 <77036fc6-4cfa-0a00-3a0c-30a235c779fb@cn.fujitsu.com>
 <05c560e7-342b-0935-ae38-055e2f40b75e@cn.fujitsu.com>
 <20170524092254.GL7250@eguan.usersys.redhat.com>
 <faab19a8-d021-d74e-8ee9-3f66d131da3e@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <faab19a8-d021-d74e-8ee9-3f66d131da3e@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 24, 2017 at 05:27:24PM +0800, Qu Wenruo wrote:
> 
> 
> At 05/24/2017 05:22 PM, Eryu Guan wrote:
> > On Wed, May 24, 2017 at 03:58:11PM +0800, Qu Wenruo wrote:
> > > 
> > > 
> > > At 05/24/2017 01:16 PM, Qu Wenruo wrote:
> > > > 
> > > > 
> > > > At 05/24/2017 01:08 PM, Eryu Guan wrote:
> > > > > On Wed, May 24, 2017 at 12:28:34PM +0800, Qu Wenruo wrote:
> > > > > > 
> > > > > > 
> > > > > > At 05/24/2017 12:24 PM, Eryu Guan wrote:
> > > > > > > On Wed, May 24, 2017 at 08:22:25AM +0800, Qu Wenruo wrote:
> > > > > > > > 
> > > > > > > > 
> > > > > > > > At 05/23/2017 07:13 PM, Eryu Guan wrote:
> > > > > > > > > On Tue, May 23, 2017 at 04:02:05PM +0800, Qu Wenruo wrote:
> > > > > > > > > > [BUG]
> > > > > > > > > > If using MOUNT_OPTIONS="-o nodatasum" and btrfs to run genierc/142
> > > > > > > > > > generic/143 and generic/154, it will cause false alert like:
> > > > > > > > > > cp: failed to clone '/mnt/test/test-154/file2'
> > > > > > > > > > from '/mnt/test/test-154/file1': Invalid
> > > > > > > > > > argument
> > > > > > > > > 
> > > > > > > > > MOUNT_OPTIONS is for scratch mount, and
> > > > > > > > > TEST_FS_MOUNT_OPTS is for test
> > > > > > > > > dev mount, so I think setting TEST_FS_MOUNT_OPTS to "-o nodatasum"
> > > > > > > > > should fix your problem.
> > > > > > > > 
> > > > > > > > Nope, the problem is the inconsistent of TEST_MNT setup.
> > > > > > > 
> > > > > > > It does fix the failure for me, did I miss anything?
> > > > > > > 
> > > > > > > # MOUNT_OPTIONS="-o nodatasum" TEST_FS_MOUNT_OPTS="-o
> > > > > > > nodatasum" ./check generic/142 generic/143 generic/154
> > > > > > > FSTYP         -- btrfs
> > > > > > > PLATFORM      -- Linux/x86_64 dhcp-66-86-11 4.12.0-rc1
> > > > > > > MKFS_OPTIONS  -- /dev/sda6
> > > > > > > MOUNT_OPTIONS -- -o nodatasum -o
> > > > > > > context=system_u:object_r:root_t:s0 /dev/sda6
> > > > > > > /mnt/testarea/scratch
> > > > > > > 
> > > > > > > generic/142 2s ... 1s
> > > > > > > generic/143      18s
> > > > > > > generic/154      1s
> > > > > > > Ran: generic/142 generic/143 generic/154
> > > > > > > Passed all 3 tests
> > > > > > > 
> > > > > > 
> > > > > > But if you only export MOUNT_OPTIONS, it will fail, due to the different
> > > > > > mount options between test_cycle_mount().
> > > > > 
> > > > > That's correct. Sorry, I didn't make it clear in my first reply. I meant
> > > > > that you should set both TEST_FS_MOUNT_OPTS and MOUNT_OPTIONS to
> > > > > "-onodatasum", for both test dev and scratch dev.
> > > > 
> > > > That's just a workaround, not a root fix.
> > > > 
> > > > Not to mention quite a lot test cases lose its coverage.
> > > > As after _test_cycle_mount(), they are just testing default mount option.
> > > > 
> > > > > 
> > > > > > 
> > > > > > To make it clear:
> > > > > > If test mount follows TEST_FS_MOUNT_OPTS, then both the first mount and
> > > > > > test_cycle_mount should follow TEST_FS_MOUNT_OPTS.
> > > > > 
> > > > > _test_mount does follow TEST_FS_MOUNT_OPTS, not MOUNT_OPTIONS, no matter
> > > > > which mount it is.
> > > > 
> > > > While test mount setup by check script follows MOUNT_OPTIONS.
> > > 
> > > Well, $MOUNT_OPTIONS is appended by check_generic_filsystem() or
> > > check_btrfs_filesystem() for btrfs.
> > 
> > Yeah, you're right, I found it too. The _check_<fs>_filesystem() mounts
> > with MOUNT_OPTIONS unconditionally.
> > 
> > > 
> > > Which will remount the device with $MOUNT_OPTIONS.
> > > Further more, this function doesn't care if it's scratch device or test
> > > device, just use MOUNT_OPTIONS.
> > > 
> > > So either we split it for scratch and test device, and follows different
> > > mount options,
> > > or just like my submitted patch, to make _test_mount() to follow
> > > MOUNT_OPTIONS.
> > 
> > Fixing _check_<fs>_filesystem() is the correct way. And I guess we can
> > refactor out a common function and call it in
> > _check_[xfs|btrfs|generic]_filesystem.
> 
> BTW, I'm wondering if we should still follow the old
> "TEST_FS_MOUNT_OPTIONS".
> 
> I wonder split MOUNT_OPTIONS and TEST_FS_MOUNT_OPTIONS may reduce the test
> coverage if tester is not aware of these mount options.

There're tests require different mount options between test dev and
scratch, though it's a really rare case, one example is generic/413.
And I think separated mount options provide us flexibility in testing
too.

IMO, at this stage the correct thing to do is to make all these global
variables well documented. I'll see if I have some free cycles to do so
(but I'm not a native English speaker, I'm afraid the document will be
really hard to understand :)

Thanks,
Eryu
> 
> Thanks,
> Qu
> 
> > 
> > Thanks for looking into this!
> > 
> > Eryu
> > 
> > > 
> > > Thanks,
> > > Qu
> > > 
> > > > 
> > > > Just check the following very basic test script:
> > > > ------
> > > > #! /bin/bash
> > > > # FS QA Test 010
> > > > #
> > > > # what am I here for?
> > > > #
> > > > seq=`basename $0`
> > > > seqres=$RESULT_DIR/$seq
> > > > echo "QA output created by $seq"
> > > > 
> > > > here=`pwd`
> > > > tmp=/tmp/$$
> > > > status=1    # failure is the default!
> > > > trap "_cleanup; exit \$status" 0 1 2 3 15
> > > > 
> > > > _cleanup()
> > > > {
> > > >       cd /
> > > >       rm -f $tmp.*
> > > > }
> > > > 
> > > > # get standard environment, filters and checks
> > > > . ./common/rc
> > > > . ./common/filter
> > > > 
> > > > # remove previous $seqres.full before test
> > > > rm -f $seqres.full
> > > > 
> > > > # real QA test starts here
> > > > 
> > > > # Modify as appropriate.
> > > > _supported_fs generic
> > > > _supported_os Linux
> > > > _require_test
> > > > 
> > > > mount > $tmp.mount1
> > > > _test_cycle_mount
> > > > mount > $tmp.mount2
> > > > 
> > > > diff  $tmp.mount1 $tmp.mount2
> > > > 
> > > > echo "Silence is golden"
> > > > # success, all done
> > > > status=0
> > > > exit
> > > > 
> > > > ------
> > > > 
> > > > Thanks,
> > > > Qu
> > > > > 
> > > > > Thanks,
> > > > > Eryu
> > > > > -- 
> > > > > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > > > > the body of a message to majordomo@vger.kernel.org
> > > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > > > 
> > > > > 
> > > 
> > > 
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
