Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24791C433F5
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Apr 2022 05:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233147AbiDWFsp (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 23 Apr 2022 01:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiDWFsn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Apr 2022 01:48:43 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D242E78A2
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Apr 2022 22:45:47 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3203D68AFE; Sat, 23 Apr 2022 07:45:43 +0200 (CEST)
Date:   Sat, 23 Apr 2022 07:45:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: simplify WQ_HIGHPRI handling in struct
 btrfs_workqueue
Message-ID: <20220423054542.GB17823@lst.de>
References: <20220418044311.359720-1-hch@lst.de> <20220418044311.359720-2-hch@lst.de> <03ea07cb-d724-26f6-bfce-99befb3ab15e@suse.com> <20220422210525.GL18596@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422210525.GL18596@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 22, 2022 at 11:05:25PM +0200, David Sterba wrote:
> On Mon, Apr 18, 2022 at 04:03:43PM +0800, Qu Wenruo wrote:
> > > -struct __btrfs_workqueue {
> > > +struct btrfs_workqueue {
> > >   	struct workqueue_struct *normal_wq;
> > 
> > I guess we can also rename @normal_wq here, as there is only one wq in 
> > each btrfs_workqueue, no need to distinguish them in btrfs_workqueue.
> 
> Yeah now the 'normal_' prefix does not make sense.

I though it always was about the btrfs wrapper vs kernel
implementaiton.  I.e. even the hipri one used normal inside the
__btrfs_workqueue.

>         /* size: 88, cachelines: 2, members: 7 */
>         /* last cacheline: 24 bytes */
> };
> 
> The fs_info structure grew a bit but it's a large one and there's still
> enough space before it hits 4K.

The only growth should be a single pointer for thew new hipri submission
work queue.  But if the fs_info size is a concern I'm pretty sure there
is a lot of low hanging fruit.
