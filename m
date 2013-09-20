Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204Ab3ITRXu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Sep 2013 13:23:50 -0400
Date: Fri, 20 Sep 2013 19:23:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs-progs: add a bunch of new statistics to
 btrfs-calc-size
Message-ID: <20130920172346.GL6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1379691161-4125-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1379691161-4125-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 20, 2013 at 11:32:41AM -0400, Josef Bacik wrote:
> I've been wanting to get back to the allocator and make some changes to try and
> fix our fragmenation woes with lots of metadata.  But in order to make these
> changes I need to have something to tell me if my changes are making a real
> measurable difference.  So this patch adds a bunch of new statistics to
> btrfs-calc-size.  It will tell me how long it took to read in the trees, how
> many seeks it had (both forward and backward).  It will tell me how far spread
> out the tree is and spit out a nice histogram of the seeks.  Here is some sample
> output

Nice!

> +	/* Make a tick count as 5% of the total seeks */
> +	tick_interval = stat->total_seeks / 20;
> +	printf("\tSeek histogram\n");
> +	for (; n; n = rb_next(n)) {
> +		u64 ticks, gticks = 0;
> +
> +		seek = rb_entry(n, struct seek, n);
> +		ticks = seek->count / tick_interval;
> +		if (group_count)
> +			gticks = group_count / tick_interval;

Divsion by zero, core dumped.

>  		total_size = pretty_sizes(stat.total_bytes);

> +		printf("\tTotal size: %s\n", total_size);

>  		free(total_size);

There's the pretty_size thing that can be used directly in printf and
without free(). I've switched them all and committed to integration.
Please send a separate fix for the 0-division problem.

david
