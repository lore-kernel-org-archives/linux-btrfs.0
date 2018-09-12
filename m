Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:35507 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728250AbeILS7F (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Sep 2018 14:59:05 -0400
Received: by mail-qt0-f193.google.com with SMTP id j7-v6so1918862qtp.2
        for <linux-btrfs@vger.kernel.org>; Wed, 12 Sep 2018 06:54:27 -0700 (PDT)
Date: Wed, 12 Sep 2018 09:54:25 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org,
        Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH] Btrfs: do not wait after queue async work for delaye refs
Message-ID: <20180912135423.fgl7gbc5lx447h4n@destiny>
References: <1536703587-94565-8-git-send-email-bo.liu@linux.alibaba.com>
 <feaa2619-fdb3-efa3-4e2f-878cd81058c1@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <feaa2619-fdb3-efa3-4e2f-878cd81058c1@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 12, 2018 at 10:19:23AM +0300, Nikolay Borisov wrote:
> [Adding Josef to CC]
> 
> On 12.09.2018 01:06, Liu Bo wrote:
> > If metadata space is hungry, how fast flush_space() can run determines
> > the latency we spend in reserve_metadata_space().
> > 
> > flush_space()
> >    case FLUSH_DELAYED_ITEMS:
> >       ...
> >       btrfs_end_transaction()
> >    case ALLOC_CHUNK:
> >       ...
> >       btrfs_end_transaction()
> > 
> > btrfs_end_transaction()
> >    btrfs_async_run_delayed_refs()
> >        // queue a work to process delayed refs
> >        ...
> >        if (wait)
> >            wait_for_completion()
> > 
> > Although processing delayed refs can add to pinned bytes, pinned bytes
> > can only be used after committing transaction, so waiting async in
> > flush_space() doesn't help.

Nack, but just because I get rid of all of this code in my delayed refs rsv
patchset.  Thanks,

Josef
