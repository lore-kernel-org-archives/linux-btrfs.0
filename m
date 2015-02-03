Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:65070 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964961AbbBCLlL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Feb 2015 06:41:11 -0500
Received: by mail-la0-f48.google.com with SMTP id pv20so50489733lab.7
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Feb 2015 03:41:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1422636926.13510.1@mail.thefacebook.com>
References: <1422618132-30272-1-git-send-email-forrestl@synology.com>
	<20150130165110.GN3641@twin.jikos.cz>
	<1422636926.13510.1@mail.thefacebook.com>
Date: Tue, 3 Feb 2015 19:41:10 +0800
Message-ID: <CAJSVwFPwpwugHrNPrkv00h+P2y9bn6Y3HvyDJKZnzbqj5JRwsw@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: add missing blk_finish_plug in btrfs_sync_log()
From: Forrest Liu <forrestl@synology.com>
To: Chris Mason <clm@fb.com>, dsterba@suse.cz
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was a runtime problem, we found the problem by following BUG_ON message

[ 2160.387506] kernel BUG at block/blk-core.c:2838!
[ 2160.392145] invalid opcode: 0000 [#1] SMP
[ 2160.396285] CPU 1
[ 2160.398139] Modules linked in: nfsd exportfs rpcsec_gss_krb5
iscsi_target_mod(O) target_core_mod(O) iscsi_extent_pool(P) configfs
cifs udf isofs loop syno_hddmon(P) usbhid hid usblp usb_storage
bonding cedarview_synobios(P) btrfs synoacl_vfs(P) zlib_deflate
libcrc32c hfsplus md4 hmac igb(O) i2c_algo_bit e1000e(O) fuse vfat fat
ecryptfs sha512_generic sha256_generic sha1_generic ecb aes_x86_64
authenc chainiv des_generic crc32c eseqiv krng ansi_cprng cts rng
aes_generic md5 cbc cryptomgr pcompress aead crypto_hash
crypto_blkcipher crypto_wq crypto_algapi cpufreq_stats freq_table
dm_snapshot crc_itu_t crc_ccitt quota_v2 quota_tree psnap p8022 llc
ipv6 zram(C) sg etxhci_hcd xhci_hcd ehci_hcd uhci_hcd usbcore
usb_common [last unloaded: rpcsec_gss_krb5]
[ 2160.466015]
[ 2160.467513] Pid: 24436, comm: fsstress
[ 2160.477139] RIP: 0010:[<ffffffff811e5458>]  [<ffffffff811e5458>]
blk_flush_plug_list+0x1e8/0x1f0
[ 2160.485961] RSP: 0018:ffff8800034bfd18  EFLAGS: 00010283
[ 2160.491268] RAX: 0000000091827364 RBX: ffff8800116182b0 RCX: ffff8800361d4290
[ 2160.498405] RDX: 0000000000000002 RSI: 0000000000000001 RDI: ffff8800034bfe68
[ 2160.505542] RBP: ffff8800034bfe68 R08: ffff8800034bfc4c R09: 0000000000000000
[ 2160.512716] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8800034bfd18
[ 2160.519895] R13: 0000000000000001 R14: 0000000000180000 R15: ffff88000f9f5590
[ 2160.527051] FS:  0000000000000000(0000) GS:ffff88003e480000(0063)
knlGS:00000000f75d46c0
[ 2160.535174] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[ 2160.540922] CR2: 00000000081c7024 CR3: 0000000021c2c000 CR4: 00000000000006e0
[ 2160.548062] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2160.555191] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2160.562324] Process fsstress (pid: 24436, threadinfo
ffff8800034be000, task ffff8800361d4290)
[ 2160.570853] Stack:
[ 2160.572881]  ffff8800034bfd18 ffff8800034bfd18 ffff88003c0680f8
ffff88002915600f
[ 2160.580357]  ffff8800116182b0 ffff8800034bfd68 ffff88001b3d01e8
0000000000000001
[ 2160.587833]  0000000000180000 ffffffff813eb1f5 ffff88001b3d01e8
ffffffffa02d4581
[ 2160.595326] Call Trace:
[ 2160.597784]  [<ffffffff813eb1f5>] ? schedule+0x35/0x50
[ 2160.602939]  [<ffffffffa02d4581>] ?
wait_current_trans.isra.35+0xb1/0x110 [btrfs]
[ 2160.610420]  [<ffffffff810543e0>] ? finish_wait+0xa0/0xa0
[ 2160.615839]  [<ffffffffa02d5df7>] ? start_transaction+0x447/0x4f0 [btrfs]
[ 2160.622646]  [<ffffffffa02e37fc>] ? btrfs_symlink+0x8c/0x4c0 [btrfs]
[ 2160.629001]  [<ffffffff810cd314>] ? kern_path_create+0x84/0x140
[ 2160.634926]  [<ffffffff810cd5ed>] ? vfs_symlink+0xdd/0x400
[ 2160.640411]  [<ffffffff810c7ce2>] ? getname_flags+0xe2/0x230
[ 2160.646076]  [<ffffffff810d056d>] ? sys_symlinkat+0xbd/0xd0
[ 2160.651655]  [<ffffffff813ee785>] ? sysenter_dispatch+0x7/0x2b
[ 2160.657482] Code: ff 66 90 48 8d 28 eb 91 0f 1f 00 48 c7 c2 e0 21
1e 81 48 8d 34 24 31 ff e8 a6 03 02 00 c7 45 28 00 00 00 00 e9 1d ff
ff ff 0f 0b <0f> 0b 66 0f 1f 44 00 00 53 31 f6 48 8d 1f e8 05 fe ff ff
65 48
[ 2160.677554] RIP  [<ffffffff811e5458>] blk_flush_plug_list+0x1e8/0x1f0
[ 2160.684009]  RSP <ffff8800034bfd18>
[ 2160.687631] ---[ end trace 6e94b8c47322e180 ]---

Thanks,
Forrest

2015-01-31 0:55 GMT+08:00 Chris Mason <clm@fb.com>:
> On Fri, Jan 30, 2015 at 11:51 AM, David Sterba <dsterba@suse.cz> wrote:
>>
>> On Fri, Jan 30, 2015 at 07:42:12PM +0800, Forrest Liu wrote:
>>>
>>>  Add missing blk_finish_plug in btrfs_sync_log()
>>>
>>>  Signed-off-by: Forrest Liu <forrestl@synology.com>
>>
>>
>> Reviewed-by: David Sterba <dsterba@suse.cz>
>>
>> Did you find that by code inspection or was there a runtime problem.
>
>
> I was wondering the same.  I'll send in for 3.19-final
>
> -chris
>
>
>
