Return-Path: <SRS0=ig1K=R7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3205FC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 10:42:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02B38206BA
	for <linux-btrfs@archiver.kernel.org>; Thu, 28 Mar 2019 10:42:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726182AbfC1Kmc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 28 Mar 2019 06:42:32 -0400
Received: from tartarus.angband.pl ([54.37.238.230]:48920 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726108AbfC1Kmc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Mar 2019 06:42:32 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.92)
        (envelope-from <kilobyte@angband.pl>)
        id 1h9SUO-0005yB-2d; Thu, 28 Mar 2019 11:42:28 +0100
Date:   Thu, 28 Mar 2019 11:42:28 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, marcin.slusarz@intel.com
Subject: Re: [PATCH] btrfs: allow MAP_SYNC mmap
Message-ID: <20190328104228.GA22302@angband.pl>
References: <20190327232635.zw4edleqwowxfzej@merlin>
 <20190328102418.5466-1-kilobyte@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190328102418.5466-1-kilobyte@angband.pl>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

[kdave: like the rest of btrfs+DAX patchset, this is WIP of course]

> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 196c8f37ff9d..8efdb040bc1d 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -16,6 +16,7 @@
> +#include <linux/mman.h>

> +	.mmap_supported_flags = MAP_SYNC,

With this, the userspace at least thinks that DAX works.  Whether it's
actually crash-safe, will require a lot of review that's outside of my
areas of knowledge.

Most of the PMDK's test suite passes, but at least pmemspoil test fails.
There's also (not sure if in pmemspoil or earlier):

[  652.053976] RIP: 0010:btrfs_free_reserved_data_space_noquota+0xe6/0xf0
[  652.060683] Code: b8 00 48 8b 45 00 48 85 c0 75 d7 41 c6 45 00 00 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 89 c1 48 f7 d9 48 39 ca 0f 83 6a ff ff ff <0f> 0b 31 c0 e9 64 ff ff ff 90 41 55 49 89 fd 41 54 49 89 f4 55 53
[  652.079767] RSP: 0000:ffff99450807fc38 EFLAGS: 00010287
[  652.085078] RAX: fffffffffffff000 RBX: 0000000000300000 RCX: 0000000000001000
[  652.092330] RDX: 0000000000000000 RSI: 0000000000300000 RDI: ffff89965030a000
[  652.099583] RBP: 0000000000300000 R08: ffff99450807fc28 R09: ffffffffae6bc01a
[  652.106836] R10: ffffc76c9f5f8600 R11: 0000000000000011 R12: 0000000000300fff
[  652.114089] R13: ffff89965030a000 R14: ffff89964a82d000 R15: 0000000000000002
[  652.121342] FS:  00007fee0adcc800(0000) GS:ffff899655bc0000(0000) knlGS:0000000000000000
[  652.129566] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  652.135405] CR2: 00007fee0a700000 CR3: 00000007742d6006 CR4: 00000000003606e0
[  652.142657] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  652.149822] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  652.157149] Call Trace:
[  652.159550]  btrfs_free_reserved_data_space+0x46/0x60
[  652.164755]  btrfs_iomap_end+0xf4/0x150
[  652.168654]  dax_iomap_pte_fault.isra.41+0x201/0x8f0
[  652.173712]  btrfs_dax_fault+0x3c/0xa0
[  652.177523]  __do_fault+0x2f/0x90
[  652.180891]  __handle_mm_fault+0x9fa/0xed0
[  652.185056]  __do_page_fault+0x242/0x4c0
[  652.188955]  ? page_fault+0x8/0x30
[  652.192484]  page_fault+0x1e/0x30
[  652.195854] RIP: 0033:0x7fee0b340efc
[  652.199400] Code: 9d 48 81 fa 80 00 00 00 77 19 c5 fe 7f 07 c5 fe 7f 47 20 c5 fe 7f 44 17 e0 c5 fe 7f 44 17 c0 c5 f8 77 c3 48 8d 8f 80 00 00 00 <c5> fe 7f 07 48 83 e1 80 c5 fe 7f 44 17 e0 c5 fe 7f 47 20 c5 fe 7f
[  652.218563] RSP: 002b:00007ffcd02d58e8 EFLAGS: 00010202
[  652.223786] RAX: 00007fee0a700000 RBX: 00007fee0a6fffc0 RCX: 00007fee0a700080
[  652.231026] RDX: 0000000000000800 RSI: 0000000000000000 RDI: 00007fee0a700000
[  652.238353] RBP: 00007fee0a401b38 R08: 000000000000000f R09: 0000000000000001
[  652.245606] R10: 000000000000000d R11: 00007fee0b360bf0 R12: 0000000000000800
[  652.252865] R13: 00007fee0b4a6eec R14: 00007fee0a700000 R15: 0000000000000180
[  652.260119] ---[ end trace b6545baf6cf711c6 ]---


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁ Did ya know that typing "test -j8" instead of "ctest -j8"
⢿⡄⠘⠷⠚⠋⠀ will make your testsuite pass much faster, and fix bugs?
⠈⠳⣄⠀⠀⠀⠀
