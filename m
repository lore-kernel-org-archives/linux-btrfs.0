Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F05DC001DF
	for <linux-btrfs@archiver.kernel.org>; Tue,  1 Aug 2023 07:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbjHAH6H (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 1 Aug 2023 03:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbjHAH6E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2023 03:58:04 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF271729
        for <linux-btrfs@vger.kernel.org>; Tue,  1 Aug 2023 00:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FPSu5QsOljdijoztEI4obcwetM0fKbnfTrtht667GzA=; b=juxNWXre0qLsfqAeNbkYVcm83j
        pbJEAvpnOzWaoLCwPd4cD91y4H18fK4AeBmMQNj8B0Q/IA+oigiA9adSgm6CsWj3WEe6gGWFjjWdj
        15aRFRqtGqQzwmnD5GdBvMIZD1C0jRHlqtBUPh8wzKfYgSN2CYgWUJRhutSejeee1X1ruiTJ3lhoM
        ddYnnBhjo0AX1tbOR3Cvx66GcO0Xoax1CzmZwCgM4y/1O+oOJShfulc4CzBlTVD+L2PqayEk8KLo5
        2WSLp/tTS0w2fytK49JmhyuXBWnIy53dFLk/IZr0oCWOrbjpzSjTVUqpHVHhKdsWYhxltyDpE3sML
        5DQ1nL3A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1qQkGa-000bF5-0i;
        Tue, 01 Aug 2023 07:58:04 +0000
Date:   Tue, 1 Aug 2023 00:58:04 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Naohiro Aota <naohiro.aota@wdc.com>
Cc:     linux-btrfs@vger.kernel.org, hch@infradead.org,
        josef@toxicpanda.com, dsterba@suse.cz
Subject: Re: [PATCH v2 04/10] btrfs: zoned: defer advancing meta_write_pointer
Message-ID: <ZMi7DOBQMf2qJwEi@infradead.org>
References: <cover.1690823282.git.naohiro.aota@wdc.com>
 <b33f5b9b41cf80665f8df12c7094e260a38938bb.1690823282.git.naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b33f5b9b41cf80665f8df12c7094e260a38938bb.1690823282.git.naohiro.aota@wdc.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Aug 01, 2023 at 02:17:13AM +0900, Naohiro Aota wrote:
>  	if (!lock_extent_buffer_for_io(eb, wbc)) {
> -		btrfs_revert_meta_write_pointer(ctx->block_group, eb);
>  		free_extent_buffer(eb);
>  		return 0;
>  	}
>  	if (ctx->block_group) {
> -		/*
> -		 * Implies write in zoned mode. Mark the last eb in a block group.
> -		 */
> +		/* Implies write in zoned mode. */

.. maybe ->block_group should be named ->zoned_bg to make this
implication very clear to everyone touching the code?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
