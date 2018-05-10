Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42836 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934609AbeEJNEO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 09:04:14 -0400
Date: Thu, 10 May 2018 15:01:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: robbieko <robbieko@synology.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix invalid memory access with journal_info
Message-ID: <20180510130135.GF6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1525862125-15228-1-git-send-email-robbieko@synology.com>
 <20180510045303.GA14694@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180510045303.GA14694@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 09, 2018 at 09:53:03PM -0700, Omar Sandoval wrote:
> On Wed, May 09, 2018 at 06:35:25PM +0800, robbieko wrote:
> > From: Robbie Ko <robbieko@synology.com>
> > 
> > When send process requires memory allocation, shrinker may be triggered
> > due to insufficient memory.
> > Then evict_inode gets called when inode is freed, and this function
> > may need to start transaction.
> > However, the journal_info is already points to BTRFS_SEND_TRANS_STUB, it
> > passed the if condition,
> > and the following use yields illegal memory access.
> > 
> >   if (current->journal_info) {
> >       WARN_ON(type & TRANS_EXTWRITERS);
> >       h = current->journal_info;
> >       refcount_inc(&h->use_count);
> >       WARN_ON(refcount_read(&h->use_count) > 2);
> >       h->orig_rsv = h->block_rsv;
> >       h->block_rsv = NULL;
> >       goto got_it;
> >   }
> 
> start_transaction() has
> 
>     ASSERT(current->journal_info != BTRFS_SEND_TRANS_STUB);
> 
> Are you saying that's wrong? Are there other cases where the shrinker
> can end up starting a transaction?
> 
> > Direct IO has a similar problem, journal_info will store btrfs_dio_data,
> > which will lead to illegal memory access.
> 
> I have patches getting rid of this for direct I/O here:
> https://github.com/osandov/linux/tree/btrfs-journal-info-abuse
> 
> I originally did that for btrfs swapfile support, but if it actually
> fixes an existing bug it should be easy to get merged.

Yes please.
