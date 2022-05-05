Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50572C433F5
	for <linux-btrfs@archiver.kernel.org>; Thu,  5 May 2022 15:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349075AbiEEPPM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 5 May 2022 11:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231680AbiEEPPL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 May 2022 11:15:11 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13FCBC0F
        for <linux-btrfs@vger.kernel.org>; Thu,  5 May 2022 08:11:31 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0CEF268AA6; Thu,  5 May 2022 17:11:29 +0200 (CEST)
Date:   Thu, 5 May 2022 17:11:28 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@lst.de>, David Sterba <dsterba@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: cleanup btrfs bio handling, part 2 v3
Message-ID: <20220505151128.GE19810@lst.de>
References: <20220504122524.558088-1-hch@lst.de> <a6952ff4-1e4e-5650-7d57-8fd442e9d5aa@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6952ff4-1e4e-5650-7d57-8fd442e9d5aa@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, May 05, 2022 at 02:56:49PM +0800, Qu Wenruo wrote:
> So do you mind to do some basic benchmark for read and write and see how
> the throughput and latency changed?

I'm not actually seeing any meaningful differences at all.  I think this
will help btrfs to better behave under memory pressure, though.
