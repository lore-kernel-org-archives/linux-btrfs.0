Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:49581 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751541AbdKJRLP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Nov 2017 12:11:15 -0500
Received: by mail-qk0-f176.google.com with SMTP id w125so1890920qkb.6
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Nov 2017 09:11:15 -0800 (PST)
Date: Fri, 10 Nov 2017 12:11:12 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Josef Bacik <josef@toxicpanda.com>, hannes@cmpxchg.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, jack@suse.cz, linux-fsdevel@vger.kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 2/6] writeback: allow for dirty metadata accounting
Message-ID: <20171110171111.idzazbjs26vh7nnb@destiny>
References: <1510255861-8020-1-git-send-email-josef@toxicpanda.com>
 <1510255861-8020-2-git-send-email-josef@toxicpanda.com>
 <20171110042533.GT4094@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171110042533.GT4094@dastard>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 10, 2017 at 03:25:33PM +1100, Dave Chinner wrote:
> On Thu, Nov 09, 2017 at 02:30:57PM -0500, Josef Bacik wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > Provide a mechanism for file systems to indicate how much dirty metadata they
> > are holding.  This introduces a few things
> > 
> > 1) Zone stats for dirty metadata, which is the same as the NR_FILE_DIRTY.
> > 2) WB stat for dirty metadata.  This way we know if we need to try and call into
> > the file system to write out metadata.  This could potentially be used in the
> > future to make balancing of dirty pages smarter.
> 
> Ok, so when you have 64k page size and 4k metadata block size and
> you're using kmalloc() to allocate the storage for the metadata,
> how do we make use of all this page-based metadata accounting
> stuff?

Sigh, I completely fucked this up.  I just found whatever my most recent local
branch was, forward ported it, and have been testing it for a few weeks to make
sure it was rock solid and sent it out.  I completely forgot I had redone all of
this stuff to count with bytes instead of pages specifically for this use case.
I have no idea where those patches went in my local tree but I've pulled down
the most recent versions of the patches from the mailinglist and will start
hammering on those again.  Sorry,

Josef
