Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965866AbdEXFI5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 01:08:57 -0400
Date: Wed, 24 May 2017 13:08:54 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: common: Make _test_mount to include
 MOUNT_OPTIONS to allow consistent _test_cycle_mount
Message-ID: <20170524050854.GI7250@eguan.usersys.redhat.com>
References: <20170523080205.12556-1-quwenruo@cn.fujitsu.com>
 <20170523111350.GZ7250@eguan.usersys.redhat.com>
 <68cba4cb-538a-c689-e13a-70028ca0fc0a@cn.fujitsu.com>
 <20170524042434.GH7250@eguan.usersys.redhat.com>
 <ee8c072d-cc4d-1023-bd8c-ac7adb4f301c@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ee8c072d-cc4d-1023-bd8c-ac7adb4f301c@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 24, 2017 at 12:28:34PM +0800, Qu Wenruo wrote:
> 
> 
> At 05/24/2017 12:24 PM, Eryu Guan wrote:
> > On Wed, May 24, 2017 at 08:22:25AM +0800, Qu Wenruo wrote:
> > > 
> > > 
> > > At 05/23/2017 07:13 PM, Eryu Guan wrote:
> > > > On Tue, May 23, 2017 at 04:02:05PM +0800, Qu Wenruo wrote:
> > > > > [BUG]
> > > > > If using MOUNT_OPTIONS="-o nodatasum" and btrfs to run genierc/142
> > > > > generic/143 and generic/154, it will cause false alert like:
> > > > > cp: failed to clone '/mnt/test/test-154/file2' from '/mnt/test/test-154/file1': Invalid argument
> > > > 
> > > > MOUNT_OPTIONS is for scratch mount, and TEST_FS_MOUNT_OPTS is for test
> > > > dev mount, so I think setting TEST_FS_MOUNT_OPTS to "-o nodatasum"
> > > > should fix your problem.
> > > 
> > > Nope, the problem is the inconsistent of TEST_MNT setup.
> > 
> > It does fix the failure for me, did I miss anything?
> > 
> > # MOUNT_OPTIONS="-o nodatasum" TEST_FS_MOUNT_OPTS="-o nodatasum" ./check generic/142 generic/143 generic/154
> > FSTYP         -- btrfs
> > PLATFORM      -- Linux/x86_64 dhcp-66-86-11 4.12.0-rc1
> > MKFS_OPTIONS  -- /dev/sda6
> > MOUNT_OPTIONS -- -o nodatasum -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/testarea/scratch
> > 
> > generic/142 2s ... 1s
> > generic/143      18s
> > generic/154      1s
> > Ran: generic/142 generic/143 generic/154
> > Passed all 3 tests
> > 
> 
> But if you only export MOUNT_OPTIONS, it will fail, due to the different
> mount options between test_cycle_mount().

That's correct. Sorry, I didn't make it clear in my first reply. I meant
that you should set both TEST_FS_MOUNT_OPTS and MOUNT_OPTIONS to
"-onodatasum", for both test dev and scratch dev.

> 
> To make it clear:
> If test mount follows TEST_FS_MOUNT_OPTS, then both the first mount and
> test_cycle_mount should follow TEST_FS_MOUNT_OPTS.

_test_mount does follow TEST_FS_MOUNT_OPTS, not MOUNT_OPTIONS, no matter
which mount it is.

Thanks,
Eryu
