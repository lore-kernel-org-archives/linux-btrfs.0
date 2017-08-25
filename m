Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:42955 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754521AbdHYHqV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 03:46:21 -0400
Date: Fri, 25 Aug 2017 00:46:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: do not reset bio->bi_ops while writing bio
Message-ID: <20170825074621.GA32249@infradead.org>
References: <20170823181509.19816-1-bo.li.liu@oracle.com>
 <20170824141041.GA25871@infradead.org>
 <20170824180440.GA16386@lim.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170824180440.GA16386@lim.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 24, 2017 at 11:04:40AM -0700, Liu Bo wrote:
> On Thu, Aug 24, 2017 at 07:10:41AM -0700, Christoph Hellwig wrote:
> > On Wed, Aug 23, 2017 at 12:15:09PM -0600, Liu Bo wrote:
> > > flush_epd_write_bio() sets bio->bi_ops by itself to honor REQ_SYNC,
> > > but it's not needed at all since bio->bi_ops has set up properly in
> > > both __extent_writepage() and write_one_eb(), and in the case of
> > > write_one_eb(), it also sets REQ_META, which we will lose in
> > > flush_epd_write_bio().
> > > 
> > > This remove this unnecessary bio->bi_ops setting.
> > 
> > Nitpick: it's bi_op, not bi_ops.
> 
> Ah thanks, it's bio->bi_opf ;)

Heh.  Of course..
