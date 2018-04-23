Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:63207 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750786AbeDWFTU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Apr 2018 01:19:20 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: Patrick Mitchell <patricklmitchell9@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: btrfs check : check/main.c:3654: check_owner_ref: BUG_ON
 `rec->is_root` triggered, value `
Date: Mon, 23 Apr 2018 05:19:18 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A84EB233@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <CA+2BD2dv4ZCdhB37OvvQsr4mWT84knZ1ahVtuEFsFrSJR6vy8g@mail.gmail.com>
In-Reply-To: <CA+2BD2dv4ZCdhB37OvvQsr4mWT84knZ1ahVtuEFsFrSJR6vy8g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

Thanks for reporting.
May be the same bug reproduced by using 
$sudo TEST=003\* make test-fuzz
in btrfs-progs.

More details in:
https://patchwork.kernel.org/patch/10073937/



> -----Original Message-----
> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-owner@vger.kernel.org] On Behalf Of Patrick Mitchell
> Sent: Monday, April 23, 2018 12:17 PM
> To: linux-btrfs@vger.kernel.org
> Subject: btrfs check : check/main.c:3654: check_owner_ref: BUG_ON `rec->is_root` triggered, value `
> 
> Arch, kernel 4.15.14, btrfs progs 4.15.1.
> 
> Had some SATA drives dropout.  Have a few btrfs volumes with parent transid verify failed errors, that all mount.
> 
> This volume has nothing I care about, so I'm just reporting it since it looks like a bug.  None of my other volumes having issues cause core
> dumps.  Happy to send whatever other info might help track it down.
> 
> 
> # btrfs check /dev/lvm/snapper1
> Checking filesystem on /dev/lvm/snapper1
> UUID: ef6f4923-0a03-4e41-9655-e24a13a1d879
> parent transid verify failed on 862240768 wanted 29524 found 29182 parent transid verify failed on 862240768 wanted 29524 found 29182
> checking extents
> check/main.c:3654: check_owner_ref: BUG_ON `rec->is_root` triggered, value 1 btrfs(+0x5f98c)[0x55ec9db9198c]
> btrfs(+0x12ad6)[0x55ec9db44ad6] btrfs(+0x18c7f)[0x55ec9db4ac7f] btrfs(+0x199c6)[0x55ec9db4b9c6] btrfs(+0x19fc0)[0x55ec9db4bfc0]
> btrfs(cmd_check+0xf63)[0x55ec9db94423]
> btrfs(main+0x81)[0x55ec9db4e441]
> /usr/lib/libc.so.6(__libc_start_main+0xea)[0x7f6923f2ff4a]
> btrfs(_start+0x2a)[0x55ec9db4e55a]
> [1]    9612 abort (core dumped)  btrfs check /dev/lvm/snapper1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in the body of a message to majordomo@vger.kernel.org More
> majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
