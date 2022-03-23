Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9417FC433F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Mar 2022 06:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241398AbiCWGLZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Mar 2022 02:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbiCWGLY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Mar 2022 02:11:24 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4210C6E8F0;
        Tue, 22 Mar 2022 23:09:56 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9F9C168AFE; Wed, 23 Mar 2022 07:09:53 +0100 (CET)
Date:   Wed, 23 Mar 2022 07:09:53 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Naohiro Aota <naohiro.aota@wdc.com>,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/40] btrfs: cleanup btrfs_submit_dio_bio
Message-ID: <20220323060953.GF24302@lst.de>
References: <20220322155606.1267165-1-hch@lst.de> <20220322155606.1267165-23-hch@lst.de> <ae266050-6bd4-96a9-1476-2c42fd8cb5c1@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae266050-6bd4-96a9-1476-2c42fd8cb5c1@gmx.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 23, 2022 at 08:50:44AM +0800, Qu Wenruo wrote:
> Can we just put btrfs_map_bio() call into each read/write branch?

We could - that being said I find this version a lot cleaner as it
has a self-explanatory flow.
