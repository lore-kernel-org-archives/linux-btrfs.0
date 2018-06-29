Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:33452 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753458AbeF2Fqd (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 01:46:33 -0400
Date: Thu, 28 Jun 2018 22:46:26 -0700
From: Marc MERLIN <marc@merlins.org>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <20180629054626.px7uwu7brwksz25j@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <03b45710-7190-8f2c-de8d-51f433d8b2cf@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <03b45710-7190-8f2c-de8d-51f433d8b2cf@cn.fujitsu.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 01:35:06PM +0800, Su Yue wrote:
> > It's hard to estimate, especially when every cross check involves a lot
> > of disk IO.
> > 
> > But at least, we could add such indicator to show we're doing something.
> > Maybe we can account all roots in root tree first, before checking a
> tree, report i/num_roots. So users can see the what is the check doing
> something meaningful or silly dead looping.

Sounds reasonable.
Do you want to submit something in git master for btrfs-progs, I pull
it, and just my btrfs check again?

In the meantime, how sane does the output I just posted, look?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
