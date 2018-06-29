Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35356 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934135AbeF2GoD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 02:44:03 -0400
Date: Thu, 28 Jun 2018 23:43:54 -0700
From: Marc MERLIN <marc@merlins.org>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <20180629064354.kbaepro5ccmm6lkn@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
 <20180629061001.kkmgvdgqfhz23kll@merlins.org>
 <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 02:32:44PM +0800, Su Yue wrote:
> > > https://github.com/Damenly/btrfs-progs/tree/tmp1
> > 
> > Not sure if I undertand that you meant, here.
> > 
> Sorry for my unclear words.
> Simply speaking, I suggest you to stop current running check.
> Then, clone above branch to compile binary then run
> 'btrfs check --mode=lowmem $dev'.
 
I understand, I'll build and try it.

> > This filesystem is trash to me and will require over a week to rebuild
> > manually if I can't repair it.
> 
> Understood your anxiety, a log of check without '--repair' will help
> us to make clear what's wrong with your filesystem.

Ok, I'll run your new code without repair and report back. It will
likely take over a day though.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
