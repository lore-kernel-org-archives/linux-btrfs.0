Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57090 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751599AbdINR0j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 13:26:39 -0400
Date: Thu, 14 Sep 2017 19:25:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: fix confusing worker helper info
Message-ID: <20170914172507.GW29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170913180928.22498-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170913180928.22498-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 13, 2017 at 12:09:28PM -0600, Liu Bo wrote:
> We've seen the following backtrace stack in ftrace or dmesg log,
> 
>   kworker/u16:10-4244  [000] 241942.480955: function:             btrfs_put_ordered_extent
>   kworker/u16:10-4244  [000] 241942.480956: kernel_stack:         <stack trace>
> => finish_ordered_fn (ffffffffa0384475)
> => btrfs_scrubparity_helper (ffffffffa03ca577)        <-----"incorrect"
> => btrfs_freespace_write_helper (ffffffffa03ca98e)    <-----"correct"
> => process_one_work (ffffffff81117b2f)
> => worker_thread (ffffffff81118c2a)
> => kthread (ffffffff81121de0)
> => ret_from_fork (ffffffff81d7087a)
> 
> btrfs_freespace_write_helper is actually calling normal_worker_helper
> instead of btrfs_scrubparity_helper, so somehow kernel has parsed the
> incorrect function address while unwinding the stack,
> btrfs_scrubparity_helper really shouldn't be shown up.
> 
> It's caused by compiler doing inline for our helper function, adding a
> noinline tag can fix that.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> cc: David Sterba <dsterba@suse.cz>

Ok, understood now, thanks. I suggest to use noinline_for_stack, that is
made exactly for this situation (I'll change it so you don't need to
resend).

Reviewed-by: David Sterba <dsterba@suse.com>
