Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40062 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751886AbdHXSIu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 14:08:50 -0400
Date: Thu, 24 Aug 2017 11:04:40 -0700
From: Liu Bo <bo.li.liu@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not reset bio->bi_ops while writing bio
Message-ID: <20170824180440.GA16386@lim.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <20170823181509.19816-1-bo.li.liu@oracle.com>
 <20170824141041.GA25871@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170824141041.GA25871@infradead.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 24, 2017 at 07:10:41AM -0700, Christoph Hellwig wrote:
> On Wed, Aug 23, 2017 at 12:15:09PM -0600, Liu Bo wrote:
> > flush_epd_write_bio() sets bio->bi_ops by itself to honor REQ_SYNC,
> > but it's not needed at all since bio->bi_ops has set up properly in
> > both __extent_writepage() and write_one_eb(), and in the case of
> > write_one_eb(), it also sets REQ_META, which we will lose in
> > flush_epd_write_bio().
> > 
> > This remove this unnecessary bio->bi_ops setting.
> 
> Nitpick: it's bi_op, not bi_ops.

Ah thanks, it's bio->bi_opf ;)

thanks,
-liubo
