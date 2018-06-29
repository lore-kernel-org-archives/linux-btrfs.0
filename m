Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:34312 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753683AbeF2GKK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 02:10:10 -0400
Date: Thu, 28 Jun 2018 23:10:01 -0700
From: Marc MERLIN <marc@merlins.org>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <20180629061001.kkmgvdgqfhz23kll@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 02:02:19PM +0800, Su Yue wrote:
> I have figured out the bug is lowmem check can't deal with shared tree block
> in reloc tree. The fix is simple, you can try the follow repo:
> 
> https://github.com/Damenly/btrfs-progs/tree/tmp1

Not sure if I undertand that you meant, here.

> Please run lowmem check "without =--repair" first to be sure whether
> your filesystem is fine.
 
The filesystem is not fine, it caused btrfs balance to hang, whether
balance actually broke it further or caused the breakage, I can't say.

Then mount hangs, even with recovery, unless I use ro.

This filesystem is trash to me and will require over a week to rebuild
manually if I can't repair it.
Running check without repair for likely several days just to know that
my filesystem is not clear (I already know this) isn't useful :)
Or am I missing something?

> Though the bug and phenomenon are clear enough, before sending my patch,
> I have to make a test image. I have spent a week to study btrfs balance
> but it seems a liitle hard for me.

thanks for having a look, either way.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
