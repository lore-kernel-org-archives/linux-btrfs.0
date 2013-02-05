Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41026 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab3BEKBx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Feb 2013 05:01:53 -0500
Date: Tue, 5 Feb 2013 11:01:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: account for orphan inodes properly during cleanup
Message-ID: <20130205100151.GE8462@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1359752717-13540-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359752717-13540-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 01, 2013 at 04:05:17PM -0500, Josef Bacik wrote:
> Dave sent me a panic where we were doing the orphan cleanup and panic'ed
> trying to release our reservation from the orphan block rsv.  The reason for
> this is because our orphan block rsv had been free'd out from underneath us
> because the transaction commit found that there were no orphan inodes
> according to its count and decided to free it.  This is incorrect so make
> sure we inc the orphan inodes count so the accounting is all done properly.
> This would also cause the warning in the orphan commit code normally if you
> had any orphans to cleanup as they would only decrement the orphan count so
> you'd get a negative orphan count which could cause problems during runtime.
> Thanks,

Thanks. I've tried to reproduce it with an unpatched kernel, but was
unsuccesful (the same test was running for 3 days) and can't reliably
verify your fix. Looks like a very tiny race.

david
