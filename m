Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43617 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753182AbeAaQQz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 Jan 2018 11:16:55 -0500
Date: Wed, 31 Jan 2018 17:14:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Gu Jinxiang <gujx@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/7] btrfs-progs: Do some clean up to be consistent
Message-ID: <20180131161442.GG18553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1516951566-21777-1-git-send-email-gujx@cn.fujitsu.com>
 <ea189b02-035e-7e27-20f0-08691bf2b83a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <ea189b02-035e-7e27-20f0-08691bf2b83a@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 26, 2018 at 04:18:55PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年01月26日 15:25, Gu Jinxiang wrote:
> > Patch 1~4 and 7: clean up use of btrfs_root.
> > Patch 5: remove redundancy value assignment.
> > Patch 6: remove no longer be used function define.
> 
> Overall it looks good, just one small nitpick, which should not need
> another update.
> 
> > Changelog:
> > v2->v1:
> > Patch 2,4: To be consistent with kernel, change macro to inline function.
> > Patch 3:
> > 	Change macro to inline function to be consistent with kernel.
> > 	And change the function body to match kernel.
> > 
> > Gu Jinxiang (7):
> >   btrfs-progs: Use fs_info instead of root for BTRFS_LEAF_DATA_SIZE
> >   btrfs-progs: Use fs_info instead of root for BTRFS_NODEPTRS_PER_BLOCK
> >   btrfs-progs: Use fs_info instead of root for
> >     BTRFS_MAX_INLINE_DATA_SIZE
> 
> Not only this patch modified the parameter but also sync the code with
> kernel.
> It would be better to mention it in commit message, but anyway, just a
> small nitpick, nothing to worry about.

I've updated the changelogs so it mentions the kernel code sync.

Patches 1-6 applied to devel as they're fairly independend of the other
patchsets waiting fo merge.
