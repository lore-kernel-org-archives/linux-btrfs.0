Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FA9C433FE
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Nov 2022 09:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238019AbiKOJrI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Nov 2022 04:47:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238136AbiKOJqt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Nov 2022 04:46:49 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D5222B0C
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Nov 2022 01:46:47 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 621B767373; Tue, 15 Nov 2022 10:46:44 +0100 (CET)
Date:   Tue, 15 Nov 2022 10:46:44 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     Qu Wenruo <wqu@suse.com>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: move the low-level btrfs_bio code into a separate file v2
Message-ID: <20221115094644.GA25208@lst.de>
References: <20221113162416.883652-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221113162416.883652-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

FYI, I just sent a v3 as the rcu_string changes from last night caused
conflicts:

https://lore.kernel.org/linux-btrfs/20221115094407.1626250-1-hch@lst.de/T/
