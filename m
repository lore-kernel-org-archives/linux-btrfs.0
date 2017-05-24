Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37514 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761625AbdEXEYh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 May 2017 00:24:37 -0400
Date: Wed, 24 May 2017 12:24:34 +0800
From: Eryu Guan <eguan@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] fstests: common: Make _test_mount to include
 MOUNT_OPTIONS to allow consistent _test_cycle_mount
Message-ID: <20170524042434.GH7250@eguan.usersys.redhat.com>
References: <20170523080205.12556-1-quwenruo@cn.fujitsu.com>
 <20170523111350.GZ7250@eguan.usersys.redhat.com>
 <68cba4cb-538a-c689-e13a-70028ca0fc0a@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <68cba4cb-538a-c689-e13a-70028ca0fc0a@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 24, 2017 at 08:22:25AM +0800, Qu Wenruo wrote:
> 
> 
> At 05/23/2017 07:13 PM, Eryu Guan wrote:
> > On Tue, May 23, 2017 at 04:02:05PM +0800, Qu Wenruo wrote:
> > > [BUG]
> > > If using MOUNT_OPTIONS="-o nodatasum" and btrfs to run genierc/142
> > > generic/143 and generic/154, it will cause false alert like:
> > > cp: failed to clone '/mnt/test/test-154/file2' from '/mnt/test/test-154/file1': Invalid argument
> > 
> > MOUNT_OPTIONS is for scratch mount, and TEST_FS_MOUNT_OPTS is for test
> > dev mount, so I think setting TEST_FS_MOUNT_OPTS to "-o nodatasum"
> > should fix your problem.
> 
> Nope, the problem is the inconsistent of TEST_MNT setup.

It does fix the failure for me, did I miss anything?

# MOUNT_OPTIONS="-o nodatasum" TEST_FS_MOUNT_OPTS="-o nodatasum" ./check generic/142 generic/143 generic/154
FSTYP         -- btrfs
PLATFORM      -- Linux/x86_64 dhcp-66-86-11 4.12.0-rc1
MKFS_OPTIONS  -- /dev/sda6
MOUNT_OPTIONS -- -o nodatasum -o context=system_u:object_r:root_t:s0 /dev/sda6 /mnt/testarea/scratch

generic/142 2s ... 1s
generic/143      18s
generic/154      1s
Ran: generic/142 generic/143 generic/154
Passed all 3 tests

Thanks,
Eryu

> 
> As I described, the TEST_MNT is setup *with* MOUNT_OPTIONS for the 1st time,
> maybe by "check" script.
> 
> But _test_cycle_mount() uses TEST_FS_MOUNT_OPTS otherthan MOUNT_OPTIONS, and
> leads to the problem.
> 
> If using TEST_FS_MOUNT_OPTS, then 1st setup should also use
> TEST_FS_MOUNT_OPTS.
> 
> Thanks,
> Qu
> 
> > 
> > Yeah, MOUNT_OPTIONS and TEST_FS_MOUNT_OPTS (and almost all other global
> > variables) are not documented properly..
> > 
> > Thanks,
> > Eryu
> > 
> > > 
> > > [REASON]
> > > It is caused by _test_cycle_mount function, which unmount test device,
> > > but when trying to re-mount it again using _test_mount(), we don't pass
> > > $MOUNT_OPTIONS.
> > > 
> > > So this makes mount options differs between _test_cycle_mount().
> > > 
> > > And btrfs doesn't allow different csum flags between reflink source and
> > > destination inodes, so it returns -EINVAL for reflink operation.
> > > 
> > > [FIX]
> > > Fix it by passing $MOUNT_OPTIONS to _test_mount(), so that
> > > _test_cycle_mount() won't cause different mount options.
> > > So btrfs with "-o nodatasum" mount option can pass generic/14[23]
> > > and generic/154 without false alert.
> > > 
> > > Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> > > ---
> > >   common/rc | 3 ++-
> > >   1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/common/rc b/common/rc
> > > index ba215961..a591907c 100644
> > > --- a/common/rc
> > > +++ b/common/rc
> > > @@ -522,7 +522,8 @@ _test_mount()
> > >           return $?
> > >       fi
> > >       _test_options mount
> > > -    _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS $* $TEST_DEV $TEST_DIR
> > > +    _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS \
> > > +		$MOUNT_OPTIONS $* $TEST_DEV $TEST_DIR
> > >   }
> > >   _test_unmount()
> > > -- 
> > > 2.13.0
> > > 
> > > 
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe fstests" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
