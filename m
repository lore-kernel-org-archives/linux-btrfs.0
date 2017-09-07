Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38423 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751884AbdIGTVp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Sep 2017 15:21:45 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 97A92ACC3
        for <linux-btrfs@vger.kernel.org>; Thu,  7 Sep 2017 19:21:44 +0000 (UTC)
Date: Thu, 7 Sep 2017 21:20:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/10] btrfs: Remove unused parameter from
 extent_clear_unlock_delalloc
Message-ID: <20170907192016.GI31874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1503308630-6652-1-git-send-email-nborisov@suse.com>
 <1503308630-6652-8-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1503308630-6652-8-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 21, 2017 at 12:43:47PM +0300, Nikolay Borisov wrote:
> This variable was added as part of ba8b04c1d4ad ("btrfs: extend
> btrfs_set_extent_delalloc and its friends to support in-band dedupe and subpage size patchset")
> however those patchsets haven't materialized yet.
> Let's remove the argument and 
> when the time comes (e.g. whiever patchset lands first) should introduce all of 
> its pre-requisites in the same series. 
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> Hello David, 
> 
> I was a ambivalent whether I should send this one since it removes some
> preparatory work. However, the said patchsets haven't really moved anywhere for
> quite some time and will likely require substantial amount of rebasing effort, 
> so let's remove *possibly* outdated leftovers. But then again, I have no 
> strong opinion on this. 

The parameter extension is there so we have chance to merge both
patchsets for testing purposes, which has happened in the past before it
was known that the subpage would need to depend on the other core
changes.

I haven't looked at the recent in-band patches, but I assume it makes
use of the parameter so I'm not going to remove it. Merging patchset
that touches some core functions means lots of manual conflict
resolutions that we've decided to keep the useless parameter just to
make our lives easier.

So, delalloc_end shall be the most irritating unused parameter for now.
