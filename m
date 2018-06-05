Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49231 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751688AbeFEOKI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Jun 2018 10:10:08 -0400
Date: Tue, 5 Jun 2018 16:07:21 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.de>
Cc: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC ver.B] btrfs: scrub: Don't use inode pages for device
 replace
Message-ID: <20180605140721.GB3539@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180605043656.4006-1-wqu@suse.com>
 <e50c0393-9a5c-3b87-e1e6-830c10f72ae8@gmx.com>
 <20180605134237.GA3539@twin.jikos.cz>
 <bd9b8157-16dc-1369-4409-d24e9e68e154@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <bd9b8157-16dc-1369-4409-d24e9e68e154@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 05, 2018 at 09:47:46PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年06月05日 21:42, David Sterba wrote:
> > On Tue, Jun 05, 2018 at 01:34:03PM +0800, Qu Wenruo wrote:
> >> Hi David,
> >>
> >> It would be pretty nice if we could get this fix (or previous RFC patch)
> >> to get into current release cycle.
> >>
> >> As it's a unrecoverable data corruption, it would be better to get it
> >> fixed as soon as possible.
> > 
> > That we can do, I'm planning to send 2nd pull by the end of the next
> > week as there's at least one patch in the queue now.
> > 
> > This patch seems to big, can you please prepare a minimal version?
> 
> The previous version (a completely different direction though) is much
> smaller.
> https://patchwork.kernel.org/patch/10440541/
> 
> However personally speaking, I still prefer this one, as it's much simpler.

As this will go to older stable kernels, I'd rather split that to more
patches where the first one is

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -2799,7 +2799,7 @@ static int scrub_extent(struct scrub_ctx *sctx, struct map_lookup *map,
                        have_csum = scrub_find_csum(sctx, logical, csum);
                        if (have_csum == 0)
                                ++sctx->stat.no_csum;
-                       if (sctx->is_dev_replace && !have_csum) {
+                       if (0 && sctx->is_dev_replace && !have_csum) {
                                ret = copy_nocow_pages(sctx, logical, l,
                                                       mirror_num,
                                                      physical_for_dev_replace);
---

and then the whole callchain of copy_nocow_pages continues.
