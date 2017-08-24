Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:46210 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbdHXOKl (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 10:10:41 -0400
Date: Thu, 24 Aug 2017 07:10:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not reset bio->bi_ops while writing bio
Message-ID: <20170824141041.GA25871@infradead.org>
References: <20170823181509.19816-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170823181509.19816-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 23, 2017 at 12:15:09PM -0600, Liu Bo wrote:
> flush_epd_write_bio() sets bio->bi_ops by itself to honor REQ_SYNC,
> but it's not needed at all since bio->bi_ops has set up properly in
> both __extent_writepage() and write_one_eb(), and in the case of
> write_one_eb(), it also sets REQ_META, which we will lose in
> flush_epd_write_bio().
> 
> This remove this unnecessary bio->bi_ops setting.

Nitpick: it's bi_op, not bi_ops.
