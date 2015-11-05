Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53501 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1032931AbbKEO7e (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Nov 2015 09:59:34 -0500
Date: Thu, 5 Nov 2015 09:59:22 -0500
From: Chris Mason <clm@fb.com>
To: <fdmanana@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, Filipe Manana <fdmanana@suse.com>
Subject: Re: [GIT PULL] Btrfs fixes
Message-ID: <20151105145922.GK5458@ret.masoncoding.com>
References: <1446722437-21605-1-git-send-email-fdmanana@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1446722437-21605-1-git-send-email-fdmanana@kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 05, 2015 at 11:20:37AM +0000, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> Hi Chris,
> 
> please consider the following fixes for the 4.4 merge window (they were
> all previously sent to the mailing list already).
> 
> One fixes a sleep inside atomic context issue, introduced by one patch
> in the integration-4.4 branch. Another two fix races regarding waiting
> for qgroup rescan worker to finish and a race between the qgroup rescan
> worker and unmounting the filesystem (leading to crashes). The remaining
> patch fixes an issue with partial direct IO writes, which has been
> introduced in the 4.0 kernel, and results either in an assertion failure
> (BUG_ON) when CONFIG_BTRFS_ASSERT=y or arithmetic underflow of an inode's
> outstanding extents counter (used for proper space reservation) when
> assertions are disabled.
> 
> Two test cases for fstests were sent recently to cover the issues regarding
> the races and the direct IO partial write regression.

Great, thanks Filipe.

I'll send these for my second pull (probably next Wed).

-chris
