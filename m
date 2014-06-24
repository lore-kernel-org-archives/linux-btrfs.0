Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750838AbaFXF2u (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Jun 2014 01:28:50 -0400
Date: Tue, 24 Jun 2014 07:28:43 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
To: Dave Chinner <david@fromorbit.com>
cc: Filipe David Borba Manana <fdmanana@gmail.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] generic/017: skip invalid block sizes for btrfs
In-Reply-To: <20140624042646.GD9508@dastard>
Message-ID: <alpine.LFD.2.00.1406240724030.2556@localhost.localdomain>
References: <1403519280-24216-1-git-send-email-fdmanana@gmail.com> <alpine.LFD.2.00.1406231413400.2169@localhost.localdomain> <alpine.LFD.2.00.1406231606570.2169@localhost.localdomain> <20140624042646.GD9508@dastard>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-652543338-1403587727=:2556"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-652543338-1403587727=:2556
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 24 Jun 2014, Dave Chinner wrote:

> Date: Tue, 24 Jun 2014 14:26:46 +1000
> From: Dave Chinner <david@fromorbit.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Filipe David Borba Manana <fdmanana@gmail.com>, fstests@vger.kernel.org,
>     linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] generic/017: skip invalid block sizes for btrfs
> 
> On Mon, Jun 23, 2014 at 04:09:18PM +0200, Lukáš Czerner wrote:
> > On Mon, 23 Jun 2014, Lukáš Czerner wrote:
> > 
> > > Date: Mon, 23 Jun 2014 14:35:50 +0200 (CEST)
> > > From: Lukáš Czerner <lczerner@redhat.com>
> > > To: Filipe David Borba Manana <fdmanana@gmail.com>
> > > Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
> > > Subject: Re: [PATCH] generic/017: skip invalid block sizes for btrfs
> > > 
> > > On Mon, 23 Jun 2014, Filipe David Borba Manana wrote:
> > > 
> > > > Date: Mon, 23 Jun 2014 11:28:00 +0100
> > > > From: Filipe David Borba Manana <fdmanana@gmail.com>
> > > > To: fstests@vger.kernel.org
> > > > Cc: linux-btrfs@vger.kernel.org,
> > > >     Filipe David Borba Manana <fdmanana@gmail.com>
> > > > Subject: [PATCH] generic/017: skip invalid block sizes for btrfs
> > > > 
> > > > In btrfs the block size (called sector size in btrfs) can not be
> > > > smaller then the page size. Therefore skip block sizes smaller
> > > > then page size if the fs is btrfs, so that the test can succeed
> > > > on btrfs (testing only with block sizes of 4kb on systems with a
> > > > page size of 4Kb).
> > > 
> > > The test itself is wrong, it's trying to do _scratch_mkfs with
> > > different block size, but the block size might already be specified
> > > by the user (in fact it should be user responsibility to test
> > > different block sizes). In the case that mkfs can not handle
> > > multiple of the same option like mkfs.xfs for example it will fail,
> > > but the test will go on with the original file system.
> > > 
> > > The test needs to be fixed to just test the file system with options
> > > specified by the user. Also we should change _scratch_mkfs() to fail
> > > the test if the mkfs failed (no one is actually testing mkfs_status
> > > variable anyway.
> > 
> > Correction, _scratch_mkfs_xfs() is actually testing mkfs_status and
> > will attempt to re-run mkfs only with provided options if it failed
> > before. But my point remains the same, block size to test should be
> > in users hands and we should run all tests with different block
> > sizes, if supported.
> 
> Follow that line of reasoning to other options. If we take that
> argument to it's logical conclusion, no test should be able to set
> any mount or mkfs option because that's for the user to control.
> This implies we can't even have quota specific tests because they
> need to override the mount options (and perhaps mkfs options) the
> user has specified to be properly tested.

I acknowledge that there are tests that actually needs to set its
own options. That's usually in the nature of the test, but it's not
the case with this particular test. Here, it's not needed and in my
view it's wrong because it brings unnecessary limitations and
problems.

> 
> Some tests only work on specific configurations and therefore they
> need to be able to control the execution environment directly. Hence
> the behaviour of _scratch_mkfs_xfs(), where it will *attempt* to use
> the user provided options. However, if they conflict with what the
> test requires it will drop the user options and use what the test
> requires.
> 
> It's better that the test overrides user provided options than fail
> due to incompatible configuration. It makes maintenance of the tests
> much easier because we don't have to declare and maintain the
> supported list of user options for every test. Either the test works
> for all configurations (i.e. whatever the user sets in
> MKFS/MOUNT_OPTIONS), or it specifically defines the configuration
> it is testing.

I do agree with that, I do not think I've ever said otherwise. I was
addressing this particular test where the specific configuration is
not needed.

-Lukas

> 
> Cheers,
> 
> Dave.
> 
--8323328-652543338-1403587727=:2556--
