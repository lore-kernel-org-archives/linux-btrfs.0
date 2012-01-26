From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] btrfs: Fix busyloops in transaction waiting code
Date: Thu, 26 Jan 2012 12:38:05 -0500
Message-ID: <20120126173805.GU15866@shiny>
References: <1327594296-23688-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1327594296-23688-1-git-send-email-jack@suse.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 26, 2012 at 05:11:36PM +0100, Jan Kara wrote:
> wait_log_commit() and wait_for_writer() were using slightly different
> conditions for deciding whether they should call schedule() and whether they
> should continue in the wait loop. Thus it could happen that we busylooped when
> the first condition was not true while the second one was. That is burning CPU
> cycles needlessly and is deadly on UP machines...

Thanks Jan, I'll pull this in.

-chris
