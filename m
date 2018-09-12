Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:33898 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbeILU0w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 16:26:52 -0400
Received: by mail-qt0-f196.google.com with SMTP id m13-v6so2251598qth.1
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 08:21:53 -0700 (PDT)
Date: Wed, 12 Sep 2018 11:21:51 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: wait on caching when putting the bg cache
Message-ID: <20180912152150.eovtjpo44flx5n5g@destiny>
References: <20180912144545.5564-1-josef@toxicpanda.com>
 <d57f676e-f9c8-9aea-f491-9b6a01408149@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <d57f676e-f9c8-9aea-f491-9b6a01408149@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 06:15:41PM +0300, Nikolay Borisov wrote:
> 
> 
> On 12.09.2018 17:45, Josef Bacik wrote:
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
> It's not clear whether this is caused by one of the patches in your
> latest patchbomb or has the issue been there all along?

Been here always, I noticed this on the backport of linus/master before I even
got to pulling my shit ontop of that.  Thanks,

Josef
