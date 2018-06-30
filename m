Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:60691 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750802AbeF3OtS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Jun 2018 10:49:18 -0400
Subject: Re: So, does btrfs check lowmem take days? weeks?
To: Marc MERLIN <marc@merlins.org>, suy.fnst@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org>
 <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
 <20180629065903.xgwpvaa2vuiys75r@merlins.org>
 <6a86d5d5-1d67-f34b-f809-b4e534485f3e@gmx.com>
 <20180629072831.qocyipdvmcm6cbo7@merlins.org>
 <20180629171044.yudgzzwpgpetim5q@merlins.org>
 <20180630024419.tzupddsw627iyhaz@merlins.org>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <01065a4e-4157-7a42-bffb-4e002defa3ba@gmx.com>
Date: Sat, 30 Jun 2018 22:49:07 +0800
MIME-Version: 1.0
In-Reply-To: <20180630024419.tzupddsw627iyhaz@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年06月30日 10:44, Marc MERLIN wrote:
> Well, there goes that. After about 18H:
> ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 21872, owner: 374857, offset: 235175936) wanted: 1, have: 1452 
> backref.c:466: __add_missing_keys: Assertion `ref->root_id` failed, value 0 
> btrfs(+0x3a232)[0x56091704f232] 
> btrfs(+0x3ab46)[0x56091704fb46] 
> btrfs(+0x3b9f5)[0x5609170509f5] 
> btrfs(btrfs_find_all_roots+0x9)[0x560917050a45] 
> btrfs(+0x572ff)[0x56091706c2ff] 
> btrfs(+0x60b13)[0x560917075b13] 
> btrfs(cmd_check+0x2634)[0x56091707d431] 
> btrfs(main+0x88)[0x560917027260] 
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f93aa508561] 
> btrfs(_start+0x2a)[0x560917026dfa] 
> Aborted 

I think that's the root cause.
Some invalid extent tree backref or bad tree block blow up backref code.

All previous error message may be garbage unless you're using Su's
latest branch, as lowmem mode tends to report false alerts on refrencer
count mismatch.

But the last abort looks pretty possible to be the culprit.

Would you try to dump the extent tree?
# btrfs inspect dump-tree -t extent <device> | grep -A50 156909494272

It should help us locate the culprit and hopefully get some chance to
fix it.

Thanks,
Qu

> 
> That's https://github.com/Damenly/btrfs-progs.git
> 
> Whoops, I didn't use the tmp1 branch, let me try again with that and
> report back, although the problem above is still going to be there since
> I think the only difference will be this, correct?
> https://github.com/Damenly/btrfs-progs/commit/b5851513a12237b3e19a3e71f3ad00b966d25b3a
> 
> Marc
> 
