Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86DE9C77B75
	for <linux-btrfs@archiver.kernel.org>; Wed,  3 May 2023 15:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjECPZU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 3 May 2023 11:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbjECPZT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 May 2023 11:25:19 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7677A6A67
        for <linux-btrfs@vger.kernel.org>; Wed,  3 May 2023 08:25:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3ED6668AA6; Wed,  3 May 2023 17:25:14 +0200 (CEST)
Date:   Wed, 3 May 2023 17:25:14 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     clm@fb.com, josef@toxicpanda.com, dsterba@suse.com
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: remove struct processed_extent
Message-ID: <20230503152514.GA29270@lst.de>
References: <20230404051622.2006302-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230404051622.2006302-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I'll retract this patch for now.  It conflicts with a submitted
series and actually shows a problem with always compression testing
that I need to look into.
