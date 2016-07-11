Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758976AbcGKPQJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jul 2016 11:16:09 -0400
Date: Mon, 11 Jul 2016 17:16:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: dsterba@suse.cz, Pavel Raiskup <praiskup@redhat.com>,
        linux-btrfs@vger.kernel.org, bug-tar <bug-tar@gnu.org>
Subject: Re: stat() on btrfs reports the st_blocks with delay (data loss in
 archivers)
Message-ID: <20160711151620.GZ13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <2628320.PvJcFm1FZr@unused-4-107.brq.redhat.com>
 <20160711144119.GY13336@twin.jikos.cz>
 <67a9457e-3925-e6b3-65db-ff30c6386678@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <67a9457e-3925-e6b3-65db-ff30c6386678@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 11, 2016 at 11:00:55AM -0400, Chris Mason wrote:
> So, the real bug is that we're letting some delalloc stat hang around 
> after the truncate, probably related to IO in progress.  We do already 
> account for delalloc in what we return to stat, but there's a corner 
> case involving truncate where we screw it up.

So the original testcase:

> >>     a) some "tool" creates sparse file
> >>     b) that tool does not sync explicitly and exits ..
> >>     c) tar is called immediately after that to archive the sparse file
> >>     d) tar considers [2] the file is completely sparse (because st_blocks is
> >>        zero) and archives no data.  Here comes data loss.

will not happen. The application would basically have to mimick the
provided reproducer script and do the truncate/write loop and be lucky
enough to let tar hit the short race window.
