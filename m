Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42338 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728365AbeIUU20 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 21 Sep 2018 16:28:26 -0400
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5B0D1AEAE
        for <linux-btrfs@vger.kernel.org>; Fri, 21 Sep 2018 14:39:15 +0000 (UTC)
Date: Fri, 21 Sep 2018 16:39:14 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: refactor __btrfs_run_delayed_refs loop
Message-ID: <20180921143914.GH5847@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1534318796-23111-1-git-send-email-nborisov@suse.com>
 <1534318796-23111-4-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1534318796-23111-4-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 15, 2018 at 10:39:56AM +0300, Nikolay Borisov wrote:
> Refactor the delayed refs loop by using the newly introduced
> btrfs_run_delayed_refs_for_head function. This greatly simplifies
> __btrfs_run_delayed_refs and makes it more obvious what is happening.
> We now have 1 loop which iterates the existing delayed_heads and then
> each selected ref head is processed by the new helper. All existing
> semantics of the code are preserved so no functional changes.

What a mess, took me some time to understand and find the hidden loop,
this is a perfect counter example. Thanks for fixing it up.

Reviewed-by: David Sterba <dsterba@suse.com>


> -		rb_erase(&ref->ref_node, &locked_ref->ref_tree);

There was a merge conflict with the rb_root_cached tree update, but the
fixup was trivial.

> +	} while ((nr != -1 && count < nr) || locked_ref);

I can't be the first to notice that the '-1' is signed long compared to
an unsigned long. This part is not obvious as this means to process all
delayed refs, called from the contexts like commit.  Replacing that with
something more explicit would be good.
