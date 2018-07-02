Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41342 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752110AbeGBOFe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Jul 2018 10:05:34 -0400
Date: Mon, 2 Jul 2018 07:05:27 -0700
From: Marc MERLIN <marc@merlins.org>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, linux-btrfs@vger.kernel.org
Message-ID: <20180702140527.wfbq5jenm67fvvjg@merlins.org>
References: <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <02ba7ad4-b618-85f0-a99f-c43b25d367de@cn.fujitsu.com>
 <20180629061001.kkmgvdgqfhz23kll@merlins.org>
 <a0099769-1622-c428-d47a-0e243f66a8b0@cn.fujitsu.com>
 <20180629064354.kbaepro5ccmm6lkn@merlins.org>
 <20180701232202.vehg7amgyvz3hpxc@merlins.org>
 <5a603d3d-620b-6cb3-106c-9d38e3ca6d02@cn.fujitsu.com>
 <20180702032259.GD5567@merlins.org>
 <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9fbd4b39-fa75-4c30-eea8-e789fd3e4dd5@cn.fujitsu.com>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2018 at 02:22:20PM +0800, Su Yue wrote:
> > Ok, that's 29MB, so it doesn't fit on pastebin:
> > http://marc.merlins.org/tmp/dshelf2_inspect.txt
> > 
> Sorry Marc. After offline communication with Qu, both
> of us think the filesystem is hard to repair.
> The filesystem is too large to debug step by step.
> Every time check and debug spent is too expensive.
> And it already costs serveral days.
> 
> Sadly, I am afarid that you have to recreate filesystem
> and reback up your data. :(
> 
> Sorry again and thanks for you reports and patient.

I appreciate your help. Honestly I only wanted to help you find why the
tools aren't working. Fixing filesystems by hand (and remotely via Email
on top of that), is way too time consuming like you said.

Is the btrfs design flawed in a way that repair tools just cannot repair
on their own? 
I understand that data can be lost, but I don't understand how the tools
just either keep crashing for me, go in infinite loops, or otherwise
fail to give me back a stable filesystem, even if some data is missing
after that.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
