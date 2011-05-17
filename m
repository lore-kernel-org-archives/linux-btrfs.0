From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: fix crash when no drive supports DISCARD
Date: Tue, 17 May 2011 14:49:00 -0400
Message-ID: <1305658043-sup-7384@shiny>
References: <20110517152743.GU12709@twin.jikos.cz> <1305648031-26379-1-git-send-email-dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	lidongyang <lidongyang@novell.com>, stable <stable@kernel.org>
To: David Sterba <dsterba@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1305648031-26379-1-git-send-email-dsterba@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from David Sterba's message of 2011-05-17 12:00:31 -0400:
> xfstests/013 crashes when the test partition is mounted with -o discard:
> 
> walk_up_log_tree
>   btrfs_free_reserved_extent
>     btrfs_discard_extent
>       return -EOPNOTSUPP
>     BUG_ON ret
> 
> btrfs_discard_extent() should be fine when drive does not support the
> DISCARD operation and filter the EOPNOTSUPP retcode, but currently it
> does this only when some bytes were succesfully discarded.

Fair enough, we aren't really doing anything with EOPNOTSUPP now, so we
can just drop it in btrfs_discard_extent.

-chris
