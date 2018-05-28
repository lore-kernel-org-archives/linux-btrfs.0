Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32824 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033368AbeE1PWL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 28 May 2018 11:22:11 -0400
Date: Mon, 28 May 2018 16:21:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 4/6] Btrfs: remove unused check of skip_locking
Message-ID: <20180528142107.GA6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1526612424-97061-1-git-send-email-bo.liu@linux.alibaba.com>
 <1526612424-97061-5-git-send-email-bo.liu@linux.alibaba.com>
 <36bc953d-f9c7-fb58-d31e-09f610ad90be@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <36bc953d-f9c7-fb58-d31e-09f610ad90be@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 18, 2018 at 01:27:50PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年05月18日 11:00, Liu Bo wrote:
> > The check is superfluous since all of callers who set search_for_commit
> > also have skip_locking set.
> > 
> > Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
> 
> Reviewed-by: Qu Wenruo <wqu@suse.com>
> 
> Although more obvious comment about search_commit_root and skip_locking
> in ctree.h will be much better.

Not only a comment but also an ASSERT, this is too easy to get wrong.
That all currenct callers do search_commit_root + skip_locking will not
catch any future callers. And there was an example reported.
