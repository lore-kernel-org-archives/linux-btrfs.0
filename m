Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.211]:45689 "EHLO newverein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753324AbcKVJml (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 04:42:41 -0500
Date: Tue, 22 Nov 2016 10:42:40 +0100
From: Christoph Hellwig <hch@lst.de>
To: Omar Sandoval <osandov@osandov.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/9] btrfs: calculate end of bio offset properly
Message-ID: <20161122094240.GA15407@lst.de>
References: <1479300736-9724-1-git-send-email-hch@lst.de> <1479300736-9724-7-git-send-email-hch@lst.de> <20161118200438.GF19038@vader.DHCP.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161118200438.GF19038@vader.DHCP.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 18, 2016 at 12:04:38PM -0800, Omar Sandoval wrote:
> > +static u64 bio_end_offset(struct bio *bio)
> > +{
> > +	struct bio_vec *last = &bio->bi_io_vec[bio->bi_vcnt - 1];
> > +
> > +	return page_offset(last->bv_page) + last->bv_len - last->bv_offset;
> 
> Why is this minus bv_offset and not plus? Am I misunderstanding
> bv_offset?

This should be a plus, thanks.

Can anyone help me on how to get test coverage for the compression
code?
