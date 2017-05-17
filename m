Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([192.185.187.5]:24335 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754306AbdEQXAC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 19:00:02 -0400
Received: from cm4.websitewelcome.com (unknown [108.167.139.16])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 6E3594050E1AA
        for <linux-btrfs@vger.kernel.org>; Wed, 17 May 2017 17:37:45 -0500 (CDT)
Date: Wed, 17 May 2017 17:37:44 -0500
Message-ID: <20170517173744.Horde.ZnZtEWjHK8oS0VfIRkwAwkd@gator4166.hostgator.com>
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [fs-btrfs] question about apparent useless function call
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello everybody,

While looking into Coverity ID 1398149 I ran into the following piece  
of code at fs/btrfs/zlib.c:295:

295done:
296        zlib_inflateEnd(&workspace->strm);
297        if (data_in)
298                kunmap(pages_in[page_in_index]);
299        if (!ret)
300                zero_fill_bio(orig_bio);
301        return ret;
302}

The issue here is that calling function zlib_inflateEnd() at line 296  
_seems_ to be useless once this function _seems_ to be only useful for  
its return value, which is ignored. The same for line 388.

Can someone help me understand what is the purpose of these calls?
Should them be removed, or the return value actually evaluated?

I'd really appreciate any comment on this.

Thank you!
--
Gustavo A. R. Silva




