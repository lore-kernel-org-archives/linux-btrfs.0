Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754888Ab3ILRhV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Sep 2013 13:37:21 -0400
Date: Thu, 12 Sep 2013 19:37:18 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/9] btrfs: Replace the btrfs_workers with kernel
 workqueue
Message-ID: <20130912173718.GE6810@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1378973304-11693-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1378973304-11693-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 12, 2013 at 04:08:15PM +0800, Qu Wenruo wrote:
> Use kernel workqueue and kernel workqueue based new btrfs_workqueue_struct to replace
> the old btrfs_workers.
> The main goal is to reduce the redundant codes(800 lines vs 200 lines) and
> try to get benefits from the latest workqueue changes.
> 
> About the performance, the test suite I used is bonnie++,
> and there seems no significant regression.

You're replacing a core infrastructure building block, more testing is
absolutely required, but using the available infrastructure is a good
move.

I found a few things that do not replace the current implementation
one-to-one:

* the thread names lost the btrfs- prefix, this makes it hard to
  identify the processes and we want this, either debugging or
  performance monitoring

* od high priority tasks were handled in threads with unchanged priority
  and just prioritized within the queue
  newly addded WQ_HIGHPRI elevates the nice level of the thread, ie.
  it's not the same thing as before -- I need to look closer

* the idle_thresh attribute is not reflected in the new code, I don't
  know if the kernel workqueues have something equivalent


Other random comments:

* you can use the same files for the new helpers, instead of bwq.[ch]

* btrfs_workqueue_struct can drop the _struct suffix

* WQ_MEM_RECLAIM for the scrub thread does not seem right

* WQ_FREEZABLE should be probably set


david
