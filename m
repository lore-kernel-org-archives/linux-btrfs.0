Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36259 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751083AbdFUTKP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Jun 2017 15:10:15 -0400
Date: Wed, 21 Jun 2017 21:09:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [RFC PATCH v3.2 0/6] Qgroup fixes, Non-stack version
Message-ID: <20170621190908.GL21388@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170517025628.303-1-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170517025628.303-1-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 10:56:22AM +0800, Qu Wenruo wrote:
> The remaining qgroup fixes patches, based on the Chris' for-linus-4.12
> branch with commit 9bcaaea7418d09691f1ffab5c49aacafe3eef9d0 as base.
> 
> Can be fetched from github:
> https://github.com/adam900710/linux/tree/qgroup_fixes_non_stack
> 
> This update is commit message update only.
> 
> v2:
>   Add reviewed-by tag for 2nd patch
>   Update the first patch to follow the new trace point standard
> RFC v3:
>   Use non-stack (dyanamic allocation) for extent_changeset structure, in
>   5th patch, to reduce impact for quota disabled cases.
>   Rebase to latest for-linus-4.12 branch.
> RFC v3.1:
>   Update comment to include the newly introduced parameter
>   Use init/release function to replace open coded ulist_init/release().
> RFC v3.2:
>   Update commit message of 1st and 3rd patch.
> 
> Qu Wenruo (6):
>   btrfs: qgroup: Add quick exit for non-fs extents
>   btrfs: qgroup: Cleanup btrfs_qgroup_prepare_account_extents function
>   btrfs: qgroup: Return actually freed bytes for qgroup release or free
>     data
>   btrfs: qgroup: Fix qgroup reserved space underflow caused by buffered
>     write and quota enable
>   btrfs: qgroup: Introduce extent changeset for qgroup reserve functions
>   btrfs: qgroup: Fix qgroup reserved space underflow by only freeing
>     reserved ranges

Added to 4.13 queue. I haven't seen any new reviews, so I tried to do my
best with my limited understanding. The preparatory look good to me, the
remaining got some review and testing so I rely on that. I made only
some wording adjustments to changelogs or comments. The whole patchset
has been in for-next for the entire dev cycle, I haven't seen any
related failures. Also I think we need to move forward with this
patchset, there was enough time to complain or help.
