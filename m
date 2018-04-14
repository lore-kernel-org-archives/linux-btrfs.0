Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44818 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751630AbeDNAwX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Apr 2018 20:52:23 -0400
Date: Sat, 14 Apr 2018 02:49:52 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH] btrfs: don't bug_on with enomem in __clear_state_bit
Message-ID: <20180414004952.GP21272@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180413202855.10453-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180413202855.10453-1-josef@toxicpanda.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 13, 2018 at 04:28:55PM -0400, Josef Bacik wrote:
> From: Josef Bacik <jbacik@fb.com>
> 
> Since we're allocating under atomic we could every easily enomem, so if
> that's the case and we can block then loop around and try to allocate
> the prealloc not under a lock.
> 
> We also saw this happen during try_to_release_page in production, in
> which case it's completely valid to return ENOMEM so we can tell
> try_to_release_page that we can't release this page.
> 
> Signed-off-by: Josef Bacik <jbacik@fb.com>

Exactly same patch as

https://patchwork.kernel.org/patch/10053319/

so the same comment applies.
