Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36140 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751054AbdIMROj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 13:14:39 -0400
Date: Wed, 13 Sep 2017 19:13:07 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove BTRFS_FS_QUOTA_DISABLING flag
Message-ID: <20170913171307.GR29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <f624acec-ac1b-61ca-19c9-e7683fc0b4e2@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f624acec-ac1b-61ca-19c9-e7683fc0b4e2@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 30, 2017 at 04:33:16PM +0900, Misono, Tomohiro wrote:
> Currently, "btrfs quota enable" would fail after "btrfs quota disable" on
> the first time with syslog output "qgroup_rescan_init failed with -22", but
> it would succeed on the second time.
> 
> When "quota disable" is called, BTRFS_FS_QUOTA_DISABLING flag bit will be
> set in fs_info->flags in btrfs_quota_disable(), but it will not be droppd
> in btrfs_run_qgroups() (which is called in btrfs_commit_transaction())
> because quota_root has already been freed. If "quota enable" is called
> after that, both BTRFS_FS_QUOTA_DISABLING and BTRFS_FS_QUOTA_ENABLED flag
> would be dropped in the btrfs_run_qgroups() since quota_root is not NULL.
> This leads to the failure of "quota enable" on the first time.
> 
> BTRFS_FS_QUOTA_DISABLING flag is not used outside of "quota disable"
> context and is equivalent to whether quota_root is NULL or not.
> btrfs_run_qgroups() checks whether quota_root is NULL or not in the first
> place. 
> 
> So, let's remove BTRFS_FS_QUOTA_DISABLING flag.

The state bits and transitions are messy and keeping them consistent
could lead to the problmes you observe. By the analysis above it looks
correct to me to remove the 'disabling' bit.

Reviewed-by: David Sterba <dsterba@suse.com>
