Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41D71C77B73
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Jun 2023 06:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235307AbjFFG02 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Jun 2023 02:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234863AbjFFG0C (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2023 02:26:02 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B201998
        for <linux-btrfs@vger.kernel.org>; Mon,  5 Jun 2023 23:24:51 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 590EB6732D; Tue,  6 Jun 2023 08:24:48 +0200 (CEST)
Date:   Tue, 6 Jun 2023 08:24:48 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     David Sterba <dsterba@suse.cz>
Cc:     Christoph Hellwig <hch@lst.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: writeback fixlets and tidyups v2
Message-ID: <20230606062448.GA27274@lst.de>
References: <20230531060505.468704-1-hch@lst.de> <20230605210159.GF25292@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605210159.GF25292@twin.jikos.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jun 05, 2023 at 11:01:59PM +0200, David Sterba wrote:
> Patches 14, 15 and 16 got postponed, the rest is now in misc-next,
> thanks.

I'll reply to you comments on patch 14.  Why did you not take 15 and 16?
