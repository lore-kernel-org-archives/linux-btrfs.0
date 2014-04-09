Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:59384 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756355AbaDIANk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Apr 2014 20:13:40 -0400
Date: Wed, 9 Apr 2014 10:12:10 +1000
From: Dave Chinner <david@fromorbit.com>
To: xfs@oss.sgi.com
Cc: linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [ANNOUNCE] xfstests: master branch updated to 610e44c
Message-ID: <20140409001210.GO27017@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi folks,

The xfstests repository at git://oss.sgi.com/xfs/cmds/xfstests has
just been updated. Patches often get missed, so please check if your
outstanding patches were in this update. If they have not been in
this update, please resubmit them to xfs@oss.sgi.com so they can be
picked up in the next update.

This update fixes the SCRATCH_DEV_POOL config file regression.

The new head of the master branch is commit:

610e44c check: fix wallclock wrapping problem

New Commits:

Lukas Czerner (3):
      [f00a444] config: Fix SCRATCH_DEV_POOL handling
      [7407717] config: Unset SCRATCH_DEV when deduced from SCRATCH_DEV_POOL
      [e0f5daf] config: Fix setting FSTYP automatically

Wanlong Gao (1):
      [610e44c] check: fix wallclock wrapping problem


Code Diffstat:

 check         | 10 +---------
 common/config | 33 ++++++++++++++++++++++++++-------
 2 files changed, 27 insertions(+), 16 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
