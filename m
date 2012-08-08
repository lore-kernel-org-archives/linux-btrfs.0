Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:44206 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab2HHOI2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Aug 2012 10:08:28 -0400
Date: Wed, 8 Aug 2012 16:08:23 +0200
From: David Sterba <dave@jikos.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [RFC] [PATCH] Btrfs: manage metadata cache ourselves
Message-ID: <20120808140822.GV17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1343855205-25043-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1343855205-25043-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 01, 2012 at 05:06:45PM -0400, Josef Bacik wrote:
> ===================================
> PLEASE REVIEW AND TEST THIS CAREFULLY
> 
> I've dug this patch out of the bin and cleaned it up but who knows what kind of
> crust I've missed.  This makes the create empty files until the file system is
> full run 5 minutes faster on my hardware so it's a pretty awesome improvement,
> plus it lets us get rid of a lot of complexity.  I think it works pretty well,
> and I've been going through and widdling it down, but now I need somebody
> *cough*Dave*cough* to go through it with a fine toothed comb and point out all
> the stupid mistakes I've made.
> 
> ===================================
> This patch moves the management of the metadata cache from pagecache to our own
> internal caching which can choose to evict things based on what is no longer in
> use.  Thanks,

Finished first reading, quite a lot of removed code, nice :) Generally
it looks ok and I don't have any major comments, rather questions if I
understand things correctly and will get to them separately. For one,
the original code had a few corner case fixes that arise from
interaction with the pagecache, those got removed but it looks safe.
Next to verify if the state bits are kept consistent. The (updated)
patch passed xfstests, so you made it to the next level.

david
