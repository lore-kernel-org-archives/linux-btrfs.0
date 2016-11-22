Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33836 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756034AbcKVS6u (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Nov 2016 13:58:50 -0500
Received: by mail-pf0-f174.google.com with SMTP id c4so5397712pfb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Nov 2016 10:58:44 -0800 (PST)
Date: Tue, 22 Nov 2016 10:58:42 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/9] btrfs: calculate end of bio offset properly
Message-ID: <20161122185842.GA17735@vader.DHCP.thefacebook.com>
References: <1479300736-9724-1-git-send-email-hch@lst.de>
 <1479300736-9724-7-git-send-email-hch@lst.de>
 <20161118200438.GF19038@vader.DHCP.thefacebook.com>
 <20161122094240.GA15407@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161122094240.GA15407@lst.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 22, 2016 at 10:42:40AM +0100, Christoph Hellwig wrote:
> On Fri, Nov 18, 2016 at 12:04:38PM -0800, Omar Sandoval wrote:
> > > +static u64 bio_end_offset(struct bio *bio)
> > > +{
> > > +	struct bio_vec *last = &bio->bi_io_vec[bio->bi_vcnt - 1];
> > > +
> > > +	return page_offset(last->bv_page) + last->bv_len - last->bv_offset;
> > 
> > Why is this minus bv_offset and not plus? Am I misunderstanding
> > bv_offset?
> 
> This should be a plus, thanks.
> 
> Can anyone help me on how to get test coverage for the compression
> code?

I'm not surprised xfstests missed this one since it's just readahead.
You might be able to get better coverage with

export MOUNT_OPTS="-o compress-force"

-- 
Omar
