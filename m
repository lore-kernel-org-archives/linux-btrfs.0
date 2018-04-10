Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-dm3nam03on0133.outbound.protection.outlook.com ([104.47.41.133]:45508
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754204AbeDJNuX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Apr 2018 09:50:23 -0400
From: Sasha Levin <Alexander.Levin@microsoft.com>
To: Sasha Levin <Alexander.Levin@microsoft.com>,
        Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC: "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix loss of prealloc extents past i_size after
 fsync log replay
Date: Tue, 10 Apr 2018 13:50:21 +0000
Message-ID: <DM5PR2101MB103293C63B8465C6B91284C2FBBE0@DM5PR2101MB1032.namprd21.prod.outlook.com>
References: <20180405215512.513-1-fdmanana@kernel.org>
In-Reply-To: <20180405215512.513-1-fdmanana@kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: c71bf099abdd Btrfs: Avoid orphan inodes cleanup while replaying log.

The bot has also determined it's probably a bug fixing patch. (score: 6.2138)

The bot has tested the following trees: v4.16.1, v4.15.16, v4.14.33, v4.9.93, v4.4.127.

v4.16.1: Build OK!
v4.15.16: Build OK!
v4.14.33: Build OK!
v4.9.93: Build failed! Errors:
    tree-log.c:2367:24: error: â€˜struct btrfs_fs_infoâ€™ has no member named â€˜sectorsizeâ€™
    tree-log.c:2367:24: error: â€˜struct btrfs_fs_infoâ€™ has no member named â€˜sectorsizeâ€™
    tree-log.c:4224:13: error: â€˜struct inodeâ€™ has no member named â€˜flagsâ€™; did you mean â€˜i_flagsâ€™?
    tree-log.c:4229:38: error: â€˜struct inodeâ€™ has no member named â€˜vfs_inodeâ€™
    tree-log.c:4239:4: error: implicit declaration of function â€˜refcount_incâ€™; did you mean â€˜i_readcount_incâ€™? [-Werror=implicit-function-declaration]

v4.4.127: Failed to apply! Possible dependencies:
    0132761017e0 ("btrfs: fix string and comment grammatical issues and typos")


--
Thanks,
Sashaÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
