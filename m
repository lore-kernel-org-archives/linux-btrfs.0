Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45666 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752650AbeEROI7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 May 2018 10:08:59 -0400
Date: Fri, 18 May 2018 16:06:16 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.liu@linux.alibaba.com>
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix the corruption by reading stale btree blocks
Message-ID: <20180518140616.GO6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526405857-88702-1-git-send-email-bo.liu@linux.alibaba.com>
 <880e75c4-10fa-8487-7bed-29c7c8c380fc@suse.com>
 <20180516141221.GA6649@twin.jikos.cz>
 <20180518131515.n23ysksu5x24kchb@US-160370MP2.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180518131515.n23ysksu5x24kchb@US-160370MP2.local>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 18, 2018 at 09:15:16PM +0800, Liu Bo wrote:
> > > Doesn't this warrant a stable tag and
> > > Fixes: 5bdd3536cbbe ("Btrfs: Fix block generation verification race")
> > 
> > The patch will not apply to < 4.16 as it depends on the addition of
> > &first_key check from 581c1760415c4, but yes we need it for stable.
> 
> True, we can easily fix the conflicts by removing @first_key, can't
> we?

Yes the backport is easy but still needs to be done manually and we
can't and don't expect the stable maintainers to resolve the conflicts
but rather send a adapter version ourselves. Nikolay promised to do
that.
