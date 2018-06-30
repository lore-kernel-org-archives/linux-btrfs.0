Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:47010 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933794AbeF3Co0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 22:44:26 -0400
Date: Fri, 29 Jun 2018 19:44:19 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, suy.fnst@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20180630024419.tzupddsw627iyhaz@merlins.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180629171044.yudgzzwpgpetim5q@merlins.org>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Well, there goes that. After about 18H:
ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 21872, owner: 374857, offset: 235175936) wanted: 1, have: 1452 
backref.c:466: __add_missing_keys: Assertion `ref->root_id` failed, value 0 
btrfs(+0x3a232)[0x56091704f232] 
btrfs(+0x3ab46)[0x56091704fb46] 
btrfs(+0x3b9f5)[0x5609170509f5] 
btrfs(btrfs_find_all_roots+0x9)[0x560917050a45] 
btrfs(+0x572ff)[0x56091706c2ff] 
btrfs(+0x60b13)[0x560917075b13] 
btrfs(cmd_check+0x2634)[0x56091707d431] 
btrfs(main+0x88)[0x560917027260] 
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f93aa508561] 
btrfs(_start+0x2a)[0x560917026dfa] 
Aborted 

That's https://github.com/Damenly/btrfs-progs.git

Whoops, I didn't use the tmp1 branch, let me try again with that and
report back, although the problem above is still going to be there since
I think the only difference will be this, correct?
https://github.com/Damenly/btrfs-progs/commit/b5851513a12237b3e19a3e71f3ad00b966d25b3a

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
