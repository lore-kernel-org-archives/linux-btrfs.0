Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbcFOJ0p (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 05:26:45 -0400
Date: Wed, 15 Jun 2016 11:27:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: avoid blocking open_ctree from cleaner_kthread
Message-ID: <20160615092719.GJ6205@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1465789198-8145-1-git-send-email-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1465789198-8145-1-git-send-email-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 12, 2016 at 11:39:58PM -0400, Zygo Blaxell wrote:
> This fixes a problem introduced in commit 2f3165ecf103599f82bf0ea254039db335fb5005
> "btrfs: don't force mounts to wait for cleaner_kthread to delete one or more subvolumes".
> 
> open_ctree eventually calls btrfs_replay_log which in turn calls
> btrfs_commit_super which tries to lock the cleaner_mutex, causing a
> recursive mutex deadlock during mount.
> 
> Instead of playing whack-a-mole trying to keep up with all the
> functions that may want to lock cleaner_mutex, put all the cleaner_mutex
> lockers back where they were, and attack the problem more directly:
> keep cleaner_kthread asleep until the filesystem is mounted.

This approach looks good to me.

> When filesystems are mounted read-only and later remounted read-write,
> open_ctree did not set fs_info->open and neither does anything else.
> Set this flag in btrfs_remount so that neither btrfs_delete_unused_bgs
> nor cleaner_kthread get confused by the common case of "/" filesystem
> read-only mount followed by read-write remount.
> 
> Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>

Reviewed-by: David Sterba <dsterba@suse.com>
