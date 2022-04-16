Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B98C433F5
	for <linux-btrfs@archiver.kernel.org>; Sat, 16 Apr 2022 04:46:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiDPEtH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 16 Apr 2022 00:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiDPEtG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Apr 2022 00:49:06 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69165F94
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2022 21:46:33 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3A6BE68AFE; Sat, 16 Apr 2022 06:46:30 +0200 (CEST)
Date:   Sat, 16 Apr 2022 06:46:29 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: minor bio submission cleanups
Message-ID: <20220416044629.GA6162@lst.de>
References: <20220415143328.349010-1-hch@lst.de> <fc163e9a-ff50-ac31-9b41-fea23913f579@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc163e9a-ff50-ac31-9b41-fea23913f579@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Apr 16, 2022 at 06:44:05AM +0800, Qu Wenruo wrote:
> Mind to share which commit your code are based on?

the misc-next branch as of yesterday.

>
> After patch 3/5 "btrfs: do not return errors from
> btrfs_submit_metadata_bio", I was expecting the same cleanup for
> btrfs_submit_data_bio(), but it doesn't.

patch 5 handles it, but it btrfs_submit_data_bio can't be done standalone
as it is also used as a callback for btrfs_repair_one_sector.
