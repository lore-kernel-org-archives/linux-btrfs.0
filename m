Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29078C001DF
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Aug 2023 16:42:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjHAQmz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 12:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbjHAQmy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2023 12:42:54 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF6F5269E
        for <linux-btrfs@vger.kernel.org>; Tue,  1 Aug 2023 09:42:45 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5BBA46732D; Tue,  1 Aug 2023 18:42:42 +0200 (CEST)
Date:   Tue, 1 Aug 2023 18:42:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Chris Mason <clm@fb.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com,
        josef@toxicpanda.com, hch@lst.de
Subject: Re: [PATCH v2] Btrfs: only subtract from len_to_oe_boundary when
 it is tracking an extent
Message-ID: <20230801164242.GA13927@lst.de>
References: <20230801162828.1396380-1-clm@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230801162828.1396380-1-clm@fb.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 01, 2023 at 09:28:28AM -0700, Chris Mason wrote:
> +		 * When len_to_oe_boundary is U32_MAX, the cap above would
> +		 * result in a 4095 byte IO for the last page riiiiight before
> +		 * we hit the bio limit of UINT_MAX.  bio_add_page() has all
> +		 * the checks required to make sure we don't overflow the bio,
> +		 * and we should just ignore len_to_oe_boundary completely
> +		 * unless we're using it to track an ordered extent.
> +		 *
> +		 * It's pretty hard to make a bio sized U32_MAX, but it can
> +		 * happen when the page cache is able to feed us contiguous
> +		 * pages for large extents.
> +		 */
> +		if (bio_ctrl->len_to_oe_boundary != U32_MAX)

So I don't know the btrfs extent allocator, but what is the maximum
size of an extent?  Could there be an U32_MAX sized extent that could
be hitting this?  In other words, what about adding an explicit flag
to bio_ctrl when to check the boundary, and just don't bother with
len_to_oe_boundary at all if it isn't set.

