Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D0EC43334
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Jul 2022 11:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbiGDL5n (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Jul 2022 07:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbiGDL5m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Jul 2022 07:57:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B8711474
        for <linux-btrfs@vger.kernel.org>; Mon,  4 Jul 2022 04:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QRrC3yhGoumkkFHFlzLCxo8cA4jQFwjnA836bM40MBs=; b=381s1aOO58SGx+/wl+A366cqRa
        hAiBKe9TXCybGCwbU13ShnBN+tS6d9cD4BT32xlEGmfM+7ZvVod4A+20I8ldoqmds7T6Myi2Hq6ho
        E7qT2EaDK9mJH+/7SBYz1ASm3QEZufRt4O+JTCgO/43RP5la3M+xmfk+CdfSoQDXoqMKBcgk+NldX
        G3OisAWCT/7OvjpQlwg+4cujx/kYJhY/MQAY9yPcP0orq6QK4jStE+gIuuuTUc4jn7NamSzBsu5ks
        WQtYXKhFgA7iO6B0pmHXn4Z4CB5lKypjp80FIbTq7NfkSOdE+UrOgxY3CBkBzsIcsYrQtgL5ccG6y
        pgT432XA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o8Khx-008FXo-KL; Mon, 04 Jul 2022 11:57:41 +0000
Date:   Mon, 4 Jul 2022 04:57:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/3] btrfs: return -EAGAIN for NOWAIT dio reads/writes on
 compressed and inline extents
Message-ID: <YsLVtZ+SpKOfiD5Z@infradead.org>
References: <cover.1656934419.git.fdmanana@suse.com>
 <b3864441547e49a69d45c7771aa8cc5e595d18fc.1656934419.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3864441547e49a69d45c7771aa8cc5e595d18fc.1656934419.git.fdmanana@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jul 04, 2022 at 12:42:03PM +0100, fdmanana@kernel.org wrote:
> +		 * filemap_read(), we fail to fault in pages for the read buffer,
> +		 * in which case filemap_read() returns a short read (the number
> +		 * of bytes previously read is > 0, so it does not return -EFAULT).

Two overly long lines here, which are especially annoying in block
comments as they completely break the layout.

> +		ret = (flags & IOMAP_NOWAIT) ? -EAGAIN : -ENOTBLK;

Nit: I'd find this a lot more readable with a good old if / else.

Either way the technical change looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
