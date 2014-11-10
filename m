Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2239 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751788AbaKJDMS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Nov 2014 22:12:18 -0500
Message-ID: <54602CF8.6030902@cn.fujitsu.com>
Date: Mon, 10 Nov 2014 11:11:52 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Matt McKinnon <matt@techsquare.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: corruption, bad block, input/output errors - do i run --repair?
References: <545CD848.8070308@techsquare.com>
In-Reply-To: <545CD848.8070308@techsquare.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: corruption, bad block, input/output errors - do i run --repair?
From: Matt McKinnon <matt@techsquare.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年11月07日 22:33
> Hi All,
>
> I'm running into some corruption and I wanted to seek out advice on 
> whether or not to run btrfs check --repair, or if I should fall back 
> to my backup file server, or both.
>
> The system is mountable, and usable.
>
> # uname -a
> Linux cbmm-fs 3.17.2-custom #1 SMP Thu Oct 30 14:09:57 EDT 2014 x86_64 
> x86_64 x86_64 GNU/Linux
>
> # btrfs --version
> Btrfs v3.14.2
> # btrfs fi show
> Label: none  uuid: 30c15060-8fb4-4926-87d4-f7d08c3033c5
>     Total devices 1 FS bytes used 58.92TiB
>     devid    1 size 76.40TiB used 59.05TiB path /dev/sda1
>
> # btrfs fi df /home
> Data, single: total=58.75TiB, used=58.75TiB
> System, DUP: total=32.00MiB, used=2.66MiB
> System, single: total=4.00MiB, used=3.68MiB
> Metadata, DUP: total=119.00GiB, used=116.63GiB
> Metadata, single: total=64.01GiB, used=57.68GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
>
> I did run into some RO snapshot corruption which caused me to run 
> btrfs check:
This is a known bug in 3.17 with RO snapshot.
It's fixable but not with your old 3.14 btrfs-progs.

Please update to 3.17 btrfs-progs, and re-run btrfsck(without --repair), 
and it will prompt you to
use --repair if this is the exact bug.
Then run with --repair should fix it.

Thanks,
Qu
>
> parent transid verify failed on 20809493159936 wanted 
> 4486137218058286914 found
> 390978
> parent transid verify failed on 20809493159936 wanted 
> 4486137218058286914 found
> 390978
> Ignoring transid failure
> Checking filesystem on /dev/sda1
> UUID: 30c15060-8fb4-4926-87d4-f7d08c3033c5
> checking extents
> bad block 69290357067776
> Errors found in extent allocation tree or chunk allocation
> checking free space cache
> checking fs roots
>
> ...
>
> "dir isize wrong" 1 error
> "errors 500, file extent discount, nbytes wrong" 14 errors
> "errors 2001, no inode item, link count wrong" 257302 errors
>
> ...
>
> found 185063071745 bytes used err is 1
> total csum bytes: 8428
> total tree bytes: 1889284096
> total fs tree bytes: 962678784
> total extent tree bytes: 159297536
> btree space waste bytes: 340014684
> file data blocks allocated: 57344
>  referenced 57344
> Btrfs v3.14.2
>
> Output of a scrub:
>
> ERROR: scrubbing /home failed for device id 1 (Input/output error)
> scrub canceled for 30c15060-8fb4-4926-87d4-f7d08c3033c5
>         scrub started at Mon Nov  3 06:43:58 2014 and was aborted 
> after 7613 seconds
>         data_extents_scrubbed: 248507555
>         tree_extents_scrubbed: 10870729
>         data_bytes_scrubbed: 15375990317056
>         tree_bytes_scrubbed: 44526505984
>         read_errors: 0
>         csum_errors: 0
>         verify_errors: 0
>         no_csum: 15712
>         csum_discards: 988018
>         super_errors: 0
>         malloc_errors: 0
>         uncorrectable_errors: 0
>         unverified_errors: 0
>         corrected_errors: 0
>         last_physical: 15425663205376
>
> Output of a balance:
>
> ERROR: error during balancing '/home' - Input/output error
> There may be more info in syslog - try dmesg | tail
>
> [501087.506642] ------------[ cut here ]------------
> [501087.543971] WARNING: CPU: 5 PID: 31885 at 
> fs/btrfs/relocation.c:925 build_backref_tree+0x11f0/0x1230 [btrfs]()
> [501087.543991] Modules linked in: ipmi_devintf(E) autofs4(E) 
> sb_edac(E) edac_core(E) joydev(E) mei_me(E) mei(E) lpc_ich(E) 
> ioatdma(E) ipmi_si(E) wmi(E) mac_hid(E) bnep(E) rfcomm(E) bluetooth(E) 
> lp(E) parport(E) nfsd(E) nfs_acl(E) auth_rpcgss(E) nfs(E) fscache(E) 
> lockd(E) sunrpc(E) ses(E) enclosure(E) hid_generic(E) ahci(E) 
> libahci(E) usbhid(E) hid(E) igb(E) dca(E) i2c_algo_bit(E) ptp(E) 
> pps_core(E) megaraid_sas(E) btrfs(E) raid6_pq(E) xor(E) libcrc32c(E)
> [501087.543995] CPU: 5 PID: 31885 Comm: btrfs Tainted: G D     E 
> 3.17.2-custom #1
> [501087.543997] Hardware name: Supermicro 
> X9DRH-7TF/7F/iTF/iF/X9DRH-7TF/7F/iTF/iF, BIOS 3.0a 12/27/2013
> [501087.543999]  000000000000039d ffff88000eadb808 ffffffff8176733c 
> 0000000000000282
> [501087.544001]  0000000000000000 ffff88000eadb848 ffffffff8107163c 
> 0000000000001000
> [501087.544003]  ffff8801d0d9acf0 ffff880497c70380 0000000000000001 
> 0000000000000001
> [501087.544004] Call Trace:
> [501087.544014]  [<ffffffff8176733c>] dump_stack+0x46/0x58
> [501087.544022]  [<ffffffff8107163c>] warn_slowpath_common+0x8c/0xc0
> [501087.544024]  [<ffffffff8107168a>] warn_slowpath_null+0x1a/0x20
> [501087.544039]  [<ffffffffa00b4020>] build_backref_tree+0x11f0/0x1230 
> [btrfs]
> [501087.544052]  [<ffffffffa00b4331>] relocate_tree_blocks+0x2d1/0x690 
> [btrfs]
> [501087.544060]  [<ffffffff811c1609>] ? kmem_cache_alloc_trace+0x39/0x1f0
> [501087.544072]  [<ffffffffa00b54a2>] relocate_block_group+0x202/0x5f0 
> [btrfs]
> [501087.544083]  [<ffffffffa00b5a40>] 
> btrfs_relocate_block_group+0x1b0/0x2d0 [btrfs]
> [501087.544098]  [<ffffffffa0088cf5>] 
> btrfs_relocate_chunk.isra.62+0x75/0x760 [btrfs]
> [501087.544111]  [<ffffffffa0084d86>] ? 
> release_extent_buffer+0x36/0xe0 [btrfs]
> [501087.544124]  [<ffffffffa0085281>] ? free_extent_buffer+0x61/0xc0 
> [btrfs]
> [501087.544136]  [<ffffffffa008d7db>] btrfs_balance+0x8ab/0xf50 [btrfs]
> [501087.544150]  [<ffffffffa00985ac>] btrfs_ioctl_balance+0x1cc/0x530 
> [btrfs]
> [501087.544156]  [<ffffffff811786eb>] ? 
> lru_cache_add_active_or_unevictable+0x2b/0xa0
> [501087.544168]  [<ffffffffa009aa82>] btrfs_ioctl+0x562/0x1f00 [btrfs]
> [501087.544173]  [<ffffffff811e9c0b>] ? putname+0x2b/0x40
> [501087.544176]  [<ffffffff811ef193>] ? user_path_at_empty+0x63/0xa0
> [501087.544183]  [<ffffffff8105f59c>] ? __do_page_fault+0x28c/0x550
> [501087.544187]  [<ffffffff8112528c>] ? acct_account_cputime+0x1c/0x20
> [501087.544189]  [<ffffffff811f1106>] do_vfs_ioctl+0x86/0x4f0
> [501087.544192]  [<ffffffff810244a5>] ? syscall_trace_enter+0x165/0x280
> [501087.544193]  [<ffffffff811f1601>] SyS_ioctl+0x91/0xb0
> [501087.544198]  [<ffffffff8176fc7f>] tracesys+0xe1/0xe6
> [501087.544199] ---[ end trace e2a77238816656f5 ]---
> [501087.579519] parent transid verify failed on 20809493159936 wanted 
> 4486137218058286914 found 390978
>
>
> I have been sending incremental snapshot dumps over to an identical 
> file server as backups.  Everything checks out OK there.  Do I try to 
> run check with --repair first, and fall back to my backup if that fails?
>
> -Matt
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

