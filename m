Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49068 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932238AbeGBDXE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 1 Jul 2018 23:23:04 -0400
Date: Sun, 1 Jul 2018 20:22:59 -0700
From: Marc MERLIN <marc@merlins.org>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Subject: Re: So, does btrfs check lowmem take days? weeks?
Message-ID: <20180702032259.GD5567@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org> <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com> <20180629052825.tifg2aw7oy3qyyvw@merlins.org> <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com> <20180629061001.kkmgvdgqfhz23kll@merlins.org> <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com> <20180629064354.kbaepro5ccmm6lkn@merlins.org> <20180701232202.vehg7amgyvz3hpxc@merlins.org> <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2018 at 10:02:33AM +0800, Su Yue wrote:
> Could you try follow dumps? They shouldn't cost much time.
> 
> #btrfs inspect dump-tree -t 21872 <device> | grep -C 50 "374857 
> EXTENT_DATA "
> 
> #btrfs inspect dump-tree -t 22911 <device> | grep -C 50 "374857 
> EXTENT_DATA "

Ok, that's 29MB, so it doesn't fit on pastebin:
http://marc.merlins.org/tmp/dshelf2_inspect.txt

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
