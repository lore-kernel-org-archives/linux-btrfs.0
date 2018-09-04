Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:34784 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbeIDWUZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Sep 2018 18:20:25 -0400
Received: by mail-qt0-f172.google.com with SMTP id m13-v6so5035426qth.1
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Sep 2018 10:54:15 -0700 (PDT)
Date: Tue, 4 Sep 2018 13:54:13 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 21/35] btrfs: only run delayed refs if we're committing
Message-ID: <20180904175412.xjumzejqkh2kfoeq@destiny>
References: <20180830174225.2200-1-josef@toxicpanda.com>
 <20180830174225.2200-22-josef@toxicpanda.com>
 <20180901002809.GE29370@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180901002809.GE29370@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 31, 2018 at 05:28:09PM -0700, Omar Sandoval wrote:
> On Thu, Aug 30, 2018 at 01:42:11PM -0400, Josef Bacik wrote:
> > I noticed in a giant dbench run that we spent a lot of time on lock
> > contention while running transaction commit.  This is because dbench
> > results in a lot of fsync()'s that do a btrfs_transaction_commit(), and
> > they all run the delayed refs first thing, so they all contend with
> > each other.  This leads to seconds of 0 throughput.  Change this to only
> > run the delayed refs if we're the ones committing the transaction.  This
> > makes the latency go away and we get no more lock contention.
> 
> This means that we're going to spend more time running delayed refs
> while in TRANS_STATE_COMMIT_START, so couldn't we end up blocking new
> transactions more than before?
> 

You'd think that, but the lock contention is enough that it makes it
unfuckingpossible for anything to run for several seconds while everybody
competes for either the delayed refs lock or the extent root lock.

With the delayed refs rsv we actually end up running the delayed refs often
enough because of the extra ENOSPC pressure that we don't really end up with
long chunks of time running delayed refs while blocking out START transactions.

If at some point down the line this turns out to be an actual issue we can
revisit the best way to do this.  Off the top of my head we do something like
wrap it in a "run all the delayed refs" mutex so that all the committers just
wait on whoever wins, and we move it back outside of the start logic in order to
make it better all the way around.  But I don't think that's something we need
to do at this point.  Thanks,

Josef
