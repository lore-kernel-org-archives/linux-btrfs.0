Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:36613 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934043AbcAZLDf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jan 2016 06:03:35 -0500
Subject: Re: UBSAN: Undefined behaviour in fs/btrfs/inode.c:5845:10
To: Chris Bainbridge <chris.bainbridge@gmail.com>,
        linux-kernel@vger.kernel.org
References: <20160126101333.GC5054@localhost>
Cc: aryabinin@virtuozzo.com, clm@fb.com, jbacik@fb.com, dsterba@suse.com,
        linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56A75285.3010502@googlemail.com>
Date: Tue, 26 Jan 2016 12:03:33 +0100
MIME-Version: 1.0
In-Reply-To: <20160126101333.GC5054@localhost>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/26/16 11:13, Chris Bainbridge wrote:
> Booting 4.5.0-rc1 with new UBSAN checker enabled:
> 
> [    3.859690] ================================================================================
> [    3.859694] UBSAN: Undefined behaviour in fs/btrfs/inode.c:5845:10
> [    3.859696] signed integer overflow:
> [    3.859697] 9223372036854775807 + 1 cannot be represented in type 'long long int'
> [    3.859701] CPU: 3 PID: 3237 Comm: polkitd Not tainted 4.5.0-rc1 #252
> [    3.859702] Hardware name: Apple Inc. MacBookPro10,2/Mac-AFD8A9D944EA4843, BIOS MBP102.88Z.0106.B0A.1509130955 09/13/2015
> [    3.859706]  0000000000000000 0000000000000000 0000000000000001 ffff88024d4bfcf8
> [    3.859709]  ffffffff81b2e7d9 0000000000000001 ffff88024d4bfd28 ffff88024d4bfd10
> [    3.859711]  ffffffff81bcb87d ffffffff83aceb48 ffff88024d4bfd98 ffffffff81bcbc4d
> [    3.859712] Call Trace:
> [    3.859719]  [<ffffffff81b2e7d9>] dump_stack+0x45/0x6c
> [    3.859723]  [<ffffffff81bcb87d>] ubsan_epilogue+0xd/0x40
> [    3.859725]  [<ffffffff81bcbc4d>] handle_overflow+0xbd/0xe0
> [    3.859728]  [<ffffffff81bcbc7e>] __ubsan_handle_add_overflow+0xe/0x10
> [    3.859732]  [<ffffffff818c6271>] btrfs_real_readdir+0x881/0xc10
> [    3.859737]  [<ffffffff8148b05d>] iterate_dir+0xdd/0x2d0
> [    3.859740]  [<ffffffff8148bb0b>] SyS_getdents+0x9b/0x110
> [    3.859743]  [<ffffffff8148b250>] ? iterate_dir+0x2d0/0x2d0
> [    3.859747]  [<ffffffff82b40a57>] entry_SYSCALL_64_fastpath+0x12/0x6a
> [    3.859749] ================================================================================

https://patchwork.kernel.org/patch/7611351/

-h

