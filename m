Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42496 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934693AbeEJM64 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 May 2018 08:58:56 -0400
Date: Thu, 10 May 2018 14:56:16 +0200
From: David Sterba <dsterba@suse.cz>
To: robbieko <robbieko@synology.com>
Cc: Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        linux-btrfs-owner@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix invalid memory access with journal_info
Message-ID: <20180510125615.GE6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1525862125-15228-1-git-send-email-robbieko@synology.com>
 <20180510045303.GA14694@vader>
 <e39bece9d4b676280c8d2fda12ba33fa@synology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <e39bece9d4b676280c8d2fda12ba33fa@synology.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 10, 2018 at 01:55:45PM +0800, robbieko wrote:
> Omar Sandoval 於 2018-05-10 12:53 寫到:
> > On Wed, May 09, 2018 at 06:35:25PM +0800, robbieko wrote:
> >> From: Robbie Ko <robbieko@synology.com>
> >> 
> >> When send process requires memory allocation, shrinker may be 
> >> triggered
> >> due to insufficient memory.
> >> Then evict_inode gets called when inode is freed, and this function
> >> may need to start transaction.
> >> However, the journal_info is already points to BTRFS_SEND_TRANS_STUB, 
> >> it
> >> passed the if condition,
> >> and the following use yields illegal memory access.
> >> 
> >>   if (current->journal_info) {
> >>       WARN_ON(type & TRANS_EXTWRITERS);
> >>       h = current->journal_info;
> >>       refcount_inc(&h->use_count);
> >>       WARN_ON(refcount_read(&h->use_count) > 2);
> >>       h->orig_rsv = h->block_rsv;
> >>       h->block_rsv = NULL;
> >>       goto got_it;
> >>   }
> > 
> > start_transaction() has
> > 
> >     ASSERT(current->journal_info != BTRFS_SEND_TRANS_STUB);
> 
> I didn't turn on the configuration CONFIG_BTRFS_ASSERT, so this ASSERT 
> has no effect

Asserts are usually turned on, at least during development so we can
catch all sorts of problems early. In this case it caught problem that
needs to be fixed regardless of the assert being on or off.

> 
> 4506 #ifdef CONFIG_BTRFS_ASSERT
> 4507
> 4508 static inline void assfail(char *expr, char *file, int line)
> 4509 {
> 4510     pr_err("BTRFS: assertion failed: %s, file: %s, line: %d",
> 4511            expr, file, line);
> 4512     BUG();
> 4513 }
> 4514
> 4515 #define ASSERT(expr)    \
> 4516     (likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
> 4517 #else
> 4518 #define ASSERT(expr)    ((void)0)
> 4519 #endif
> 
> 
> > 
> > Are you saying that's wrong? Are there other cases where the shrinker
> > can end up starting a transaction?
> 
> I'm not sure if there are other cases where shrinker might trigger 
> start_transaction.
> But I confirm that btrfs_evict_inode triggers strat_transaction

The shrinker and allocator can call to filesystems to let them write
data and free some memory, but this is typically guarded by the GFP_NOFS
so it does not recurse to the same filesystem (and deadlock).

Playing games with the journal_info can fix that but I'd rather not
spread the pattern, Omar's removal of that from dio looks cleaner and
the right way to go.
