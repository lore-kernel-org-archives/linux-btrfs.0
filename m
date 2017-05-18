Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45562 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754241AbdERODk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 10:03:40 -0400
Date: Thu, 18 May 2017 16:02:40 +0200
From: David Sterba <dsterba@suse.cz>
To: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [fs-btrfs] question about apparent useless function call
Message-ID: <20170518140240.GQ4065@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170517173744.Horde.ZnZtEWjHK8oS0VfIRkwAwkd@gator4166.hostgator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170517173744.Horde.ZnZtEWjHK8oS0VfIRkwAwkd@gator4166.hostgator.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 05:37:44PM -0500, Gustavo A. R. Silva wrote:
> While looking into Coverity ID 1398149 I ran into the following piece  
> of code at fs/btrfs/zlib.c:295:
> 
> 295done:
> 296        zlib_inflateEnd(&workspace->strm);
> 297        if (data_in)
> 298                kunmap(pages_in[page_in_index]);
> 299        if (!ret)
> 300                zero_fill_bio(orig_bio);
> 301        return ret;
> 302}
> 
> The issue here is that calling function zlib_inflateEnd() at line 296  
> _seems_ to be useless once this function _seems_ to be only useful for  
> its return value, which is ignored. The same for line 388.
> 
> Can someone help me understand what is the purpose of these calls?
> Should them be removed, or the return value actually evaluated?

I don't think that removing the functions is a good idea, even if
they're trivial in the end. The error value needs to be checked but
seems that the only thing we can do at that point is to inform the user
that something bad happen inside the decompressor.  The cleanup (kunmap
or memset) has to be done anyway.
