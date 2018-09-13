Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49240 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726919AbeIMRBb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 13:01:31 -0400
Date: Thu, 13 Sep 2018 13:52:21 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: wait on caching when putting the bg cache
Message-ID: <20180913115221.GU2154@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180912144545.5564-1-josef@toxicpanda.com>
 <20180912184044.GQ2154@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180912184044.GQ2154@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 08:40:44PM +0200, David Sterba wrote:
> On Wed, Sep 12, 2018 at 10:45:45AM -0400, Josef Bacik wrote:
> > While testing my backport I noticed there was a panic if I ran
> > generic/416 generic/417 generic/418 all in a row.  This just happened to
> > uncover a race where we had outstanding IO after we destroy all of our
> > workqueues, and then we'd go to queue the endio work on those free'd
> > workqueues.  This is because we aren't waiting for the caching threads
> > to be done before freeing everything up, so to fix this make sure we
> > wait on any outstanding caching that's being done before we free up the
> > block group, so we're sure to be done with all IO by the time we get to
> > btrfs_stop_all_workers().  This fixes the panic I was seeing
> > consistently in testing.
> 
> Can you please attach the stacktrace(s)? I think I've seen similar error
> once or twice but not able to reproduce.

I found at least this one https://patchwork.kernel.org/patch/10495885/,
when the rbio cache is destroyed, there's some in-flight IO. This is not
the example I had in mind before but still roughly matches the symptoms.
