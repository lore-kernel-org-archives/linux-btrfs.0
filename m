Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:40938 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754009AbaIHUvs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Sep 2014 16:51:48 -0400
Message-ID: <540E16DC.2040708@fb.com>
Date: Mon, 8 Sep 2014 16:51:40 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Filipe Manana <fdmanana@suse.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix data corruption after fast fsync and writeback
 error
References: <1409926479-8870-1-git-send-email-fdmanana@suse.com>
In-Reply-To: <1409926479-8870-1-git-send-email-fdmanana@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/2014 10:14 AM, Filipe Manana wrote:
> When we do a fast fsync, we start all ordered operations and then while
> they're running in parallel we visit the list of modified extent maps
> and construct their matching file extent items and write them to the
> log btree. After that, in btrfs_sync_log() we wait for all the ordered
> operations to finish (via btrfs_wait_logged_extents).
> 
> The problem with this is that we were completely ignoring errors that
> can happen in the extent write path, such as -ENOSPC, a temporary -ENOMEM
> or -EIO errors for example. When such error happens, it means we have parts
> of the on disk extent that weren't written to, and so we end up logging
> file extent items that point to these extents that contain garbage/random
> data - so after a crash/reboot plus log replay, we get our inode's metadata
> pointing to those extents.
> 
> This worked in contrast with the full (non-fast) fsync path, where we
> start all ordered operations, wait for them to finish and then write
> to the log btree. In this path, after each ordered operation completes
> we check if it's flagged with an error (BTRFS_ORDERED_IOERR) and return
> -EIO if so (via btrfs_wait_ordered_range).
> 
> So if an error happens with any ordered operation, just return a -EIO
> error to userspace, so that it knows that not all of its previous writes
> were durably persisted and the application can take proper action (like
> redo the writes for e.g.) - and definitely not leave any file extent items
> in the log refer to non fully written extents.

Thanks Filipe,

I'm pushing this one off for the merge window.  It's not that I think
it's wrong, but we're getting late in the rcs and I want to test it more.

-chris
