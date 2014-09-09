Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397AbaIINGT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Sep 2014 09:06:19 -0400
Date: Tue, 9 Sep 2014 21:06:15 +0800
From: Eryu Guan <eguan@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 04/15 v2] btrfs: new case to run btrfs balance and
 remount with different compress algorithms
Message-ID: <20140909130615.GW2977@dhcp-13-216.nay.redhat.com>
References: <1409233676-22787-1-git-send-email-eguan@redhat.com>
 <1409233676-22787-5-git-send-email-eguan@redhat.com>
 <20140908100859.GH30012@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140908100859.GH30012@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 08, 2014 at 08:08:59PM +1000, Dave Chinner wrote:
> On Thu, Aug 28, 2014 at 09:47:45PM +0800, Eryu Guan wrote:
> > Run btrfs balance and remount with different compress algorithms
> > simultaneously, with fsstress running in background.
> > 
> > Signed-off-by: Eryu Guan <eguan@redhat.com>
> > ---
> >  common/rc           |  10 ++++
> >  tests/btrfs/062     | 128 ++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/062.out |   2 +
> >  tests/btrfs/group   |   1 +
> >  4 files changed, 141 insertions(+)
> >  create mode 100755 tests/btrfs/062
> >  create mode 100644 tests/btrfs/062.out
> > 
> > diff --git a/common/rc b/common/rc
> > index b0f5064..b5fc1c8 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -2424,6 +2424,16 @@ _btrfs_stress_defrag()
> >  	done
> >  }
> >  
> > +_btrfs_stress_remount()
> > +{
> > +	local btrfs_mnt=$1
> > +	while true; do
> > +		for algo in no zlib lzo; do
> > +			$MOUNT_PROG -o remount,compress=$algo $btrfs_mnt
> > +		done
> > +	done
> > +}
> 
> This has nothing to do with "stress" - it tries 3
> different compression algorithms. What is the purpose of

Yes, it remount with 3 different compression algorithms, and it keeps
doing this in a loop. With fsstress running at background it may
exercise the compression path and to ensure no deadlock when switching
compression algorithm with constant I/O activity.

> this (comments, please!), and can you us a more descriptive name?

Will try, but I don't think I'm good at this :)

> 
> > +# test case array
> > +tcs=(
> > +	"-m single -d single"
> > +	"-m dup -d single"
> > +	"-m raid0 -d raid0"
> > +	"-m raid1 -d raid0"
> > +	"-m raid1 -d raid1"
> > +	"-m raid10 -d raid10"
> > +	"-m raid5 -d raid5"
> > +	"-m raid6 -d raid6"
> > +)
> 
> This is pretty common, right? Perhaps this should be a config
> variable that can be overridden by the config file configuration?

I'm thinking about adding something like this to common/rc or common/btrfs

_btrfs_get_profile_configs()
{
	# need one argument to tell if device-replace is one of the operations
	# if so, export configs without raid5/raid6, and without "-m dup -d single")

	# export tcs array according to some config variable
	# e.g. BTRFS_PROFILE_CONFIG
	# if the var is set, just export it(and _notrun if the configs are not suitable for the test)
	# if the var is not set, export the default configs
}

And call "_btrfs_get_profile_configs replace" or
"_btrfs_get_profile_configs noreplace" in each test to get the test
array setup.

Any thoughts?

Thanks,
Eryu
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
