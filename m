Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8A0BC43334
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jun 2022 17:11:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345672AbiFORK7 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Jun 2022 13:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349993AbiFORK5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Jun 2022 13:10:57 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5110F37030
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Jun 2022 10:10:55 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A671268AA6; Wed, 15 Jun 2022 19:10:51 +0200 (CEST)
Date:   Wed, 15 Jun 2022 19:10:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Boris Burkov <boris@bur.io>
Cc:     Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/5] btrfs: remove the btrfs_map_bio return value
Message-ID: <20220615171051.GA25971@lst.de>
References: <20220615151515.888424-1-hch@lst.de> <20220615151515.888424-4-hch@lst.de> <YqoP+t4bNsgPd6u7@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqoP+t4bNsgPd6u7@zen>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jun 15, 2022 at 09:59:38AM -0700, Boris Burkov wrote:
> One high level question: should we make btrfs_wq_submit_bio follow the
> same API of not having the caller call bio_endio? The names are similar
> enough that having them behave the same seems useful.

If we don't end up killing it in the current form it should eventually
get the same treatment, yes. 
