Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:40375 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750708AbeDPPMd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Apr 2018 11:12:33 -0400
Received: by mail-qk0-f193.google.com with SMTP id o64so16884292qkl.7
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Apr 2018 08:12:33 -0700 (PDT)
Date: Mon, 16 Apr 2018 11:12:31 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: David Sterba <dsterba@suse.cz>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: don't bug_on with enomem in __clear_state_bit
Message-ID: <20180416151230.5ts2t5j23haik4ep@destiny>
References: <20180413202855.10453-1-josef@toxicpanda.com>
 <20180414004952.GP21272@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180414004952.GP21272@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 14, 2018 at 02:49:52AM +0200, David Sterba wrote:
> On Fri, Apr 13, 2018 at 04:28:55PM -0400, Josef Bacik wrote:
> > From: Josef Bacik <jbacik@fb.com>
> > 
> > Since we're allocating under atomic we could every easily enomem, so if
> > that's the case and we can block then loop around and try to allocate
> > the prealloc not under a lock.
> > 
> > We also saw this happen during try_to_release_page in production, in
> > which case it's completely valid to return ENOMEM so we can tell
> > try_to_release_page that we can't release this page.
> > 
> > Signed-off-by: Josef Bacik <jbacik@fb.com>
> 
> Exactly same patch as
> 
> https://patchwork.kernel.org/patch/10053319/
> 
> so the same comment applies.

Moving the bugon just makes the same problem happen again.
try_to_release_page() will call with whatever arbitrary gfp mask it has, so if
it's GFP_ATOMIC we _want_ it to return -ENOMEM.  Everybody else that calls that
doesn't check the return value calls with a gfp mask that's will allow retrying
the allocation.  If they fail it's because the box is super out of memory and
we'll have larger problems than us not handling the case properly.  Thanks,

Josef
