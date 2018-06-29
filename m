Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:56974 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932446AbeF2RKx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 13:10:53 -0400
Date: Fri, 29 Jun 2018 10:10:44 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, suy.fnst@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20180629171044.yudgzzwpgpetim5q@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
 <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
 <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
 <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
 <20180629060657.qrtcxfcy22zkstfw@merlins.org>
 <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
 <20180629065903.xgwpvaa2vuiys75r@merlins.org>
 <6a86d5d5-1d67-f34b-f809-b4e534485f3e@gmx.com>
 <20180629072831.qocyipdvmcm6cbo7@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180629072831.qocyipdvmcm6cbo7@merlins.org>
Subject: Re: So, does btrfs check lowmem take days? weeks?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 29, 2018 at 12:28:31AM -0700, Marc MERLIN wrote:
> So, I rebooted, and will now run Su's btrfs check without repair and
> report back.

As expected, it will likely still take days, here's the start:

gargamel:~# btrfs check --mode=lowmem  -p /dev/mapper/dshelf2  
Checking filesystem on /dev/mapper/dshelf2 
UUID: 0f1a0c9f-4e54-4fa7-8736-fd50818ff73d 
ERROR: extent[84302495744, 69632] referencer count mismatch (root: 21872, owner: 374857, offset: 3407872) wanted: 2, have: 4
ERROR: extent[84302495744, 69632] referencer count mismatch (root: 22911, owner: 374857, offset: 3407872) wanted: 2, have: 4
ERROR: extent[125712527360, 12214272] referencer count mismatch (root: 21872, owner: 374857, offset: 114540544) wanted: 180, have: 240
ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 21872, owner: 374857, offset: 126754816) wanted: 67, have: 115
ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 22911, owner: 374857, offset: 126754816) wanted: 67, have: 115
ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 21872, owner: 374857, offset: 131866624) wanted: 114, have: 143
ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 22911, owner: 374857, offset: 131866624) wanted: 114, have: 143
ERROR: extent[129952120832, 20242432] referencer count mismatch (root: 21872, owner: 374857, offset: 148234240) wanted: 301, have: 431
ERROR: extent[129952120832, 20242432] referencer count mismatch (root: 22911, owner: 374857, offset: 148234240) wanted: 355, have: 433
ERROR: extent[134925357056, 11829248] referencer count mismatch (root: 21872, owner: 374857, offset: 180371456) wanted: 160, have: 240
ERROR: extent[134925357056, 11829248] referencer count mismatch (root: 22911, owner: 374857, offset: 180371456) wanted: 161, have: 240
ERROR: extent[147895111680, 12345344] referencer count mismatch (root: 21872, owner: 374857, offset: 192200704) wanted: 169, have: 249
ERROR: extent[147895111680, 12345344] referencer count mismatch (root: 22911, owner: 374857, offset: 192200704) wanted: 171, have: 251
ERROR: extent[150850146304, 17522688] referencer count mismatch (root: 21872, owner: 374857, offset: 217653248) wanted: 347, have: 418
ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 22911, owner: 374857, offset: 235175936) wanted: 1, have: 1449
ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 21872, owner: 374857, offset: 235175936) wanted: 1, have: 1452

Mmmh, these look similar (but not identical) to the last run earlier in this thread:
ERROR: extent[84302495744, 69632] referencer count mismatch (root: 21872, owner: 374857, offset: 3407872) wanted: 3, have: 4
Created new chunk [18457780224000 1073741824]
Delete backref in extent [84302495744 69632]
ERROR: extent[84302495744, 69632] referencer count mismatch (root: 22911, owner: 374857, offset: 3407872) wanted: 3, have: 4
Delete backref in extent [84302495744 69632]
ERROR: extent[125712527360, 12214272] referencer count mismatch (root: 21872, owner: 374857, offset: 114540544) wanted: 181, have: 240
Delete backref in extent [125712527360 12214272]
ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 21872, owner: 374857, offset: 126754816) wanted: 68, have: 115
Delete backref in extent [125730848768 5111808]
ERROR: extent[125730848768, 5111808] referencer count mismatch (root: 22911, owner: 374857, offset: 126754816) wanted: 68, have: 115
Delete backref in extent [125730848768 5111808]
ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 21872, owner: 374857, offset: 131866624) wanted: 115, have: 143
Delete backref in extent [125736914944 6037504]
ERROR: extent[125736914944, 6037504] referencer count mismatch (root: 22911, owner: 374857, offset: 131866624) wanted: 115, have: 143
Delete backref in extent [125736914944 6037504]
ERROR: extent[129952120832, 20242432] referencer count mismatch (root: 21872, owner: 374857, offset: 148234240) wanted: 302, have: 431
Delete backref in extent [129952120832 20242432]
ERROR: extent[129952120832, 20242432] referencer count mismatch (root: 22911, owner: 374857, offset: 148234240) wanted: 356, have: 433
Delete backref in extent [129952120832 20242432]
ERROR: extent[134925357056, 11829248] referencer count mismatch (root: 21872, owner: 374857, offset: 180371456) wanted: 161, have: 240
Delete backref in extent [134925357056 11829248]
ERROR: extent[134925357056, 11829248] referencer count mismatch (root: 22911, owner: 374857, offset: 180371456) wanted: 162, have: 240
Delete backref in extent [134925357056 11829248]
ERROR: extent[147895111680, 12345344] referencer count mismatch (root: 21872, owner: 374857, offset: 192200704) wanted: 170, have: 249
Delete backref in extent [147895111680 12345344]
ERROR: extent[147895111680, 12345344] referencer count mismatch (root: 22911, owner: 374857, offset: 192200704) wanted: 172, have: 251
Delete backref in extent [147895111680 12345344]
ERROR: extent[150850146304, 17522688] referencer count mismatch (root: 21872, owner: 374857, offset: 217653248) wanted: 348, have: 418
Delete backref in extent [150850146304 17522688]
ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 22911, owner: 374857, offset: 235175936) wanted: 555, have: 1449
Deleted root 2 item[156909494272, 178, 5476627808561673095]
ERROR: extent[156909494272, 55320576] referencer count mismatch (root: 21872, owner: 374857, offset: 235175936) wanted: 556, have: 1452
Deleted root 2 item[156909494272, 178, 7338474132555182983]

I guess the last repair didn't repair things in a way that they're working now?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
