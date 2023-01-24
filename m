Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EBD2C38142
	for <linux-btrfs@archiver.kernel.org>; Tue, 24 Jan 2023 14:11:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbjAXOLB (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 24 Jan 2023 09:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjAXOLA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2023 09:11:00 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 422B342BDF;
        Tue, 24 Jan 2023 06:11:00 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7CCED67373; Tue, 24 Jan 2023 14:44:49 +0100 (CET)
Date:   Tue, 24 Jan 2023 14:44:49 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        David Sterba <dsterba@suse.com>, clm@fb.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 09/14] btrfs: factor out scratching of one
 regular super block
Message-ID: <20230124134449.GA26352@lst.de>
References: <20230124134257.637523-1-sashal@kernel.org> <20230124134257.637523-9-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230124134257.637523-9-sashal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 24, 2023 at 08:42:52AM -0500, Sasha Levin wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> [ Upstream commit 0e0078f72be81bbb2a02b229fd2cec8ad63e4fb1 ]
> 
> btrfs_scratch_superblocks open codes scratching super block of a
> non-zoned super block.  Split the code to read, zero and write the
> superblock for regular devices into a separate helper.

Why is this a stable candidate?
