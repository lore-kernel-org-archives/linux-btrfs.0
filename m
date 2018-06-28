Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40676 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1030600AbeF1TDy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Jun 2018 15:03:54 -0400
Date: Thu, 28 Jun 2018 20:56:37 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, misono.tomohiro@jp.fujitsu.com
Subject: Re: [PATCH v1] btrfs: quota: Set rescan progress to (u64)-1 if we
 hit last leaf
Message-ID: <20180628185637.GL2287@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180627101955.12034-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180627101955.12034-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2018 at 06:19:55PM +0800, Qu Wenruo wrote:
> Commit ff3d27a048d9 ("btrfs: qgroup: Finish rescan when hit the last leaf
> of extent tree") added a new exit for rescan finish.
> 
> However after finishing quota rescan, we set
> fs_info->qgroup_rescan_progress to (u64)-1 before we exit through the
> original exit path.
> While we missed that assignment of (u64)-1 in the new exit path.
> 
> The end result is, the quota status item doesn't have the same value.
> (-1 vs the last bytenr + 1)
> Although it doesn't affect quota accounting, it's still better to keep
> the original behavior.
> 
> Reported-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
> Fixes: ff3d27a048d9 ("btrfs: qgroup: Finish rescan when hit the last leaf of extent tree")
> Signed-off-by: Qu Wenruo <wqu@suse.com>

Thanks, added to 4.18 queue.
