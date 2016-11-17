Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:36676 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750772AbcKQTYn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Nov 2016 14:24:43 -0500
Received: by mail-pg0-f43.google.com with SMTP id f188so93979590pgc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Nov 2016 11:24:43 -0800 (PST)
Date: Thu, 17 Nov 2016 11:24:41 -0800
From: Omar Sandoval <osandov@osandov.com>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: send: fix failure of xfstests btrfs/038
Message-ID: <20161117192441.GA5272@vader.DHCP.thefacebook.com>
References: <201611150816.AA00015@WIN-5MHF4RKU941.jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201611150816.AA00015@WIN-5MHF4RKU941.jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 15, 2016 at 05:16:27PM +0900, Tsutomu Itoh wrote:
> The following patch was imperfect, so xfstests btrfs/038 was failed.
> 
>   6d4fb3d  btrfs-progs: send: fix handling of multiple snapshots (-p option)
> 
> [before]
> | # ./check btrfs/038
> | FSTYP         -- btrfs
> | PLATFORM      -- Linux/x86_64 luna 4.9.0-rc5
> | MKFS_OPTIONS  -- /dev/sdb3
> | MOUNT_OPTIONS -- /dev/sdb3 /test6
> |
> | btrfs/038 1s ... [failed, exit status 1] - output mismatch (see /For_RT/xfstests2/results//btrfs/038.out.bad)
> |     --- tests/btrfs/038.out     2015-08-04 16:09:38.000000000 +0900
> |     +++ /For_RT/xfstests2/results//btrfs/038.out.bad    2016-11-15 13:39:48.589435290 +0900
> |     @@ -7,3 +7,5 @@
> |      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> |      wrote 10000/10000 bytes at offset 300000
> |      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
> |     +failed: '/usr/local/bin/btrfs send -p /test6/mysnap1 -c /test6/clones_snap /test6/mysnap2 -f /tmp/tmp.aLpvAC7lsx/2.snap'
> |     +(see /For_RT/xfstests2/results//btrfs/038.full for details)
> |     ...
> |     (Run 'diff -u tests/btrfs/038.out /For_RT/xfstests2/results//btrfs/038.out.bad'  to see the entire diff)
> | Ran: btrfs/038
> | Failures: btrfs/038
> 
> [after]
> | # ./check btrfs/038
> | FSTYP         -- btrfs
> | PLATFORM      -- Linux/x86_64 luna 4.9.0-rc5
> | MKFS_OPTIONS  -- /dev/sdb3
> | MOUNT_OPTIONS -- /dev/sdb3 /test6
> | 
> | btrfs/038 1s ... 1s
> | Ran: btrfs/038
> | Passed all 1 tests
> 
> Signed-off-by: Tsutomu Itoh <t-itoh@jp.fujitsu.com>

Verified that this fixes both btrfs/038 and btrfs/117.

Tested-by: Omar Sandoval <osandov@fb.com>

-- 
Omar
