Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44746 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S942707AbdEYQtm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 May 2017 12:49:42 -0400
Date: Thu, 25 May 2017 18:48:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: bo.li.liu@oracle.com, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: work around maybe-uninitialized warning
Message-ID: <20170525164842.GF4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170518133351.1867577-1-arnd@arndb.de>
 <20170519181009.GA10137@lim.localdomain>
 <CAK8P3a27VTFWp=kGusXDcwy7tU2FHJc63K65p7OR1RExdpVHCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAK8P3a27VTFWp=kGusXDcwy7tU2FHJc63K65p7OR1RExdpVHCA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 19, 2017 at 09:20:53PM +0200, Arnd Bergmann wrote:
> On Fri, May 19, 2017 at 8:10 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > On Thu, May 18, 2017 at 03:33:29PM +0200, Arnd Bergmann wrote:
> >> A rewrite of btrfs_submit_direct_hook appears to have introduced a warning:
> >>
> >> fs/btrfs/inode.c: In function 'btrfs_submit_direct_hook':
> >> fs/btrfs/inode.c:8467:14: error: 'bio' may be used uninitialized in this function [-Werror=maybe-uninitialized]
> >>
> >> Where the 'bio' variable was previously initialized unconditionally, it
> >> is now set in the "while (submit_len > 0)" loop that would never execute
> >> if submit_len is zero.
> >>
> >> Assuming this cannot happen in practice, we can avoid the warning
> >> by simply replacing the while{} loop with a do{}while() loop so
> >> the compiler knows that it will always be entered at least once.
> >>
> >
> > Thanks for the fix.  I think it's a false positve one and I've updated it in v2
> > with a 'struct bio *bio = NULL' to make compiler happy, could you please help
> > reveiw it?
> 
> Right, it is a false positive and adding the =NULL initialization shuts up the
> warning. The reason my patch used a different approach is to make the
> code more robust, see https://rusty.ozlabs.org/?p=232
> 
> Generally speaking initializing a local variable to an illegal value, and later
> using the variable without a check for that original value is error-prone.
> Even though the code is correct at the moment, someone else might
> modify it later. My first (broken) solution avoided this by checking for
> the condition that led to the warning, my newer solution is nicer as it
> makes it much clearer to the reader what is going on, compared to
> the NULL initialization that does not help readability but makes
> it slightly harder to understand why you wrote the code specifically that
> way.

I like this approach better, so I'll undo "= NULL" and apply your patch.
Thanks.
