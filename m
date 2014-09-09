Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756601AbaIILxf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Sep 2014 07:53:35 -0400
Date: Tue, 9 Sep 2014 19:53:24 +0800
From: Eryu Guan <eguan@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/15 v2] btrfs: new test to run btrfs balance and
 subvolume test simultaneously
Message-ID: <20140909115324.GU2977@dhcp-13-216.nay.redhat.com>
References: <1409233676-22787-1-git-send-email-eguan@redhat.com>
 <1409233676-22787-2-git-send-email-eguan@redhat.com>
 <20140908100127.GF30012@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140908100127.GF30012@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 08, 2014 at 08:01:27PM +1000, Dave Chinner wrote:
> On Thu, Aug 28, 2014 at 09:47:42PM +0800, Eryu Guan wrote:
> > Run btrfs balance and subvolume create/mount/umount/delete simultaneously,
> > with fsstress running in background.
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> >  common/rc           |  24 ++++++++++
> >  tests/btrfs/059     | 129 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/059.out |   2 +
> >  tests/btrfs/group   |   1 +
> >  4 files changed, 156 insertions(+)
> >  create mode 100755 tests/btrfs/059
> >  create mode 100644 tests/btrfs/059.out
> > 
> > diff --git a/common/rc b/common/rc
> > index 16da898..c1a7b9e 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2375,6 +2375,30 @@ _get_free_inode()
> >  	echo $nr_inode
> >  }
> >  
> > +_btrfs_stress_balance()
> > +{
> > +	local btrfs_mnt=$1
> > +	while true; do
> > +		$BTRFS_UTIL_PROG balance start $btrfs_mnt
> > +	done
> > +}
> > +
> > +_btrfs_stress_subvolume()
> > +{
> > +	local btrfs_dev=$1
> > +	local btrfs_mnt=$2
> > +	local subvol_name=$3
> > +	local subvol_mnt=$4
> > +
> > +	mkdir -p $subvol_mnt
> > +	while true; do
> > +		$BTRFS_UTIL_PROG subvolume create $btrfs_mnt/$subvol_name
> > +		$MOUNT_PROG -o subvol=$subvol_name $btrfs_dev $subvol_mnt
> > +		$UMOUNT_PROG $subvol_mnt
> > +		$BTRFS_UTIL_PROG subvolume delete $btrfs_mnt/$subvol_name
> > +	done
> > +}
> > +
> 
> I'm thinking that we need to start separating common/rc in
> filesystem specific include files. Not necessary for this series,
> but we really need to so using this file as a dumping ground for
> shared code rather than for init and config stuff.

Agreed, maybe I can add one more patch as a last patch to sort out all
btrfs shared code to common/btrfs

> 
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	cd /
> > +	rm -fr $tmp.*
> > +}
> 
> Really dangerous, that. if $tmp is empty, then that will remove
> everything under / (i.e. 'cd /; rm -rf .*'). You shouldn't be using
> subdirs under $tmp - if you need lots of temporary data for the
> test, it should be under $TESTDIR, not on the root filesystem.

Makes much sense! Will change it.

Thanks,
Eryu
> 
> > +run_test()
> > +{
> > +	local mkfs_opts=$1
> > +	local subvol_mnt=$tmp.mnt
> 
> IOWs, don't do this. Mount stuff under $TESTDIR/$seq.mnt. That's
> what the testdir is there for...
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
