Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E210EC433F5
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 May 2022 15:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350336AbiEEPNf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 May 2022 11:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiEEPNe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 May 2022 11:13:34 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63FEF38BDA
        for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2022 08:09:55 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C649568AA6; Thu,  5 May 2022 17:09:52 +0200 (CEST)
Date:   Thu, 5 May 2022 17:09:52 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/10] btrfs: remove btrfs_end_io_wq
Message-ID: <20220505150952.GD19810@lst.de>
References: <20220504122524.558088-1-hch@lst.de> <20220504122524.558088-9-hch@lst.de> <02e4d2a3-7e72-1b83-1005-fab13bf50931@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02e4d2a3-7e72-1b83-1005-fab13bf50931@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, May 05, 2022 at 10:34:34AM +0800, Qu Wenruo wrote:
> I did a quick search on other fses, it looks like it's a common pratice
> to queue the work into the workqueue when the last one finished, other
> than making everything happen in workqueue.

Yes.  It is a lot more efficient as queing up lots of items tends to
cause quite some overhead, also due to the dynamic threadpool of the
workqueue.  XFS goes even futher and adds many bios to list at
completion time to be able to batch them up for the workqueue based
completions.
