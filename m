Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37944 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410AbaAHVLv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jan 2014 16:11:51 -0500
Received: by mail-pb0-f50.google.com with SMTP id rr13so2090302pbb.37
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jan 2014 13:11:51 -0800 (PST)
Date: Wed, 8 Jan 2014 13:13:07 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Chris Mason <clm@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "eab@gmx.ch" <eab@gmx.ch>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "fmpfeifer@gmail.com" <fmpfeifer@gmail.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>
Subject: Re: btrfs on bcache
Message-ID: <20140108211307.GB7291@kmo-pixel>
References: <CAFvEZVF8J0jbYnTtV7X6uJWL1pBkwG6iFbH-KoNSPGq0Mc7bTw@mail.gmail.com>
 <1387483201.23881.2.camel@ret.masoncoding.com>
 <CABtk0xRbO9BthbOGHGg3cO4H5CZYeDwb_H4gAmspMiKSZMNZtQ@mail.gmail.com>
 <1387554401.9407.0.camel@ret.masoncoding.com>
 <20140106233704.GI9037@kmo>
 <1389209759.23310.27.camel@ret.masoncoding.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389209759.23310.27.camel@ret.masoncoding.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 08, 2014 at 07:35:32PM +0000, Chris Mason wrote:
> On Mon, 2014-01-06 at 15:37 -0800, Kent Overstreet wrote:
> > Ok, I looked again at the relevant btrfs code, I guess I can see how this printk
> > isn't normally triggered. But Chris, _what on earth_ is btrfs trying to check
> > for here? And why is it using bv_offset and bv_len further down in
> > end_bio_extent_readpage()?
> 
> After the IO is done, we're recording the specific logical byte range
> that covered the IO.  In practice its always the full page, we can
> switch to just trusting PAGE_CACHE_SIZE.

Yeah, the code already assumes it was doing PAGE_CACHE_SIZE reads; what
you're effectively checking is that the driver did the bvec all at once,
and that it didn't process half a bvec, update it, then process the rest
- which is a completely fine thing to do.

So for now - yeah, the correct thing to do is to just ignore
bv_offset/bv_len and go by PAGE_CACHE_SIZE. But - after immutable
biovecs is in, _then_ you'll be able to depend on bv_offset/bv_len
remaining unchanged (and you can get rid of your dependency on
PAGE_CACHE_SIZE bvecs).
