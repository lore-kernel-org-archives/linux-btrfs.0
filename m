Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54307 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751083AbdIMPft (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 13 Sep 2017 11:35:49 -0400
Date: Wed, 13 Sep 2017 17:34:19 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] Btrfs: fix confusing worker helper info
Message-ID: <20170913153419.GO29043@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170908213445.1601-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170908213445.1601-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 08, 2017 at 03:34:45PM -0600, Liu Bo wrote:
> We've seen the following backtrace stack in ftrace or dmesg log,
> 
>   kworker/u16:10-4244  [000] 241942.480955: function:             btrfs_put_ordered_extent
>   kworker/u16:10-4244  [000] 241942.480956: kernel_stack:         <stack trace>
> => finish_ordered_fn (ffffffffa0384475)
> => btrfs_scrubparity_helper (ffffffffa03ca577)
> => btrfs_freespace_write_helper (ffffffffa03ca98e)
> => process_one_work (ffffffff81117b2f)
> => worker_thread (ffffffff81118c2a)
> => kthread (ffffffff81121de0)
> => ret_from_fork (ffffffff81d7087a)
> 
> btrfs_scrubparity_helper really shouldn't be shown up.
> 
> It's caused by compiler doing inline for our helper function, adding a
> noinline tag can fix that.

Isn't it the other way around then? Noninline would make the function
object exist separately and then it would appear in the stacktrace. And
I think this is desired, so you see the call stack withtou the shortcuts
that the inlining can cause.
