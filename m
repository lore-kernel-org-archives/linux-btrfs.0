Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60812 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758Ab3BKOMO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 09:12:14 -0500
Date: Mon, 11 Feb 2013 15:12:13 +0100
From: David Sterba <dsterba@suse.cz>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Deleted subvolume reappears and other cleaner issues
Message-ID: <20130211141212.GQ12339@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAOcd+r3wBX5cYctFOetPm9=Hwx1z87rEkoR=2yHhXf+DmZP7bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOcd+r3wBX5cYctFOetPm9=Hwx1z87rEkoR=2yHhXf+DmZP7bQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 31, 2013 at 03:03:06PM +0200, Alex Lyakas wrote:
> # umount may get delayed because of pending-for-deletion subvolumes:
> btrfs_commit_super() locks the cleaner_mutex, so it will wait for the
> cleaner to complete.
> On the other hand, cleaner will not give up until it completes
> processing all its splice. If currently cleaner is not running, then
> btrfs_commit_super()
> calls btrfs_clean_old_snapshots() directly. So does it make sense:
> - btrfs_commit_super() will not call btrfs_clean_old_snapshots()
> - close_ctree() calls kthread_stop(cleaner_kthread) early, and cleaner
> thread periodically checks if it needs to exit

This is on my list of annoyances for a long time and I have wip patches
to fix that. I'll send what I have for review.

david
