Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7A9C4332F
	for <linux-btrfs@archiver.kernel.org>; Mon, 21 Nov 2022 07:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiKUHFY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 02:05:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKUHFW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 21 Nov 2022 02:05:22 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA5A2980B
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Nov 2022 23:05:21 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9468E68AA6; Mon, 21 Nov 2022 08:05:18 +0100 (CET)
Date:   Mon, 21 Nov 2022 08:05:18 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Christoph Hellwig <hch@lst.de>, clm@fb.com, josef@toxicpanda.com,
        dsterba@suse.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use kvcalloc in btrfs_get_dev_zone_info
Message-ID: <20221121070518.GD23563@lst.de>
References: <20221120124303.17918-1-hch@lst.de> <22167fd3-6a97-8cab-c6b8-a3415da89b3f@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22167fd3-6a97-8cab-c6b8-a3415da89b3f@opensource.wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 21, 2022 at 11:31:01AM +0900, Damien Le Moal wrote:
> Looks good.
> This likely needs a fixes tag though.

git-blame seems to suggest the code has been like this since the
addition of the zone code.  Which is a bit odd as I've not seen
the issue before last week.
