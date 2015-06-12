Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:15900 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751163AbbFLHOM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 03:14:12 -0400
Message-ID: <557A8691.6070908@cn.fujitsu.com>
Date: Fri, 12 Jun 2015 15:13:21 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: kernel crashes with btrfs and busy database IO - how to debug?
References: <ae9b9ca434c98509ca6c1ba6dbd84b63@admin.virtall.com>
In-Reply-To: <ae9b9ca434c98509ca6c1ba6dbd84b63@admin.virtall.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: kernel crashes with btrfs and busy database IO - how to debug?
From: Tomasz Chmielewski <tch@virtall.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: 2015年06月11日 19:33

> I have a server where I've installed a couple of LXC guests, btrfs - so
> easy to test things with snapshots. Or so it seems.
>
> Unfortunately the box crashes when I put "too much IO load" - with too
> much load being these two running at the same time:
>
> - quite busy MySQL database (doing up to 100% IO wait when running alone)
> - busy mongo database (doing up to 100% IO wait when running alone)
>
> With both mongo and mysql running at the same time, it crashes after 1-2
> days (tried kernels 4.0.4, 4.0.5, 4.1-rc7 from Ubuntu "kernel-ppa"). It
> does not crash if I only run mongo, or only mysql. There is plenty of
> memory available (just around 2-4 GB used out of 32 GB) when it crashes.
>
> As the box is only reachable remotely, I'm not able to catch a crash.
> Sometimes, I'm able to get a bit of it printed via remote SSH, like here:
>
> [162276.341030] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000008
> [162276.341069] IP: [<ffffffff810c06cd>] prepare_to_wait_event+0xcd/0x100
> [162276.341096] PGD 80a15e067 PUD 6e08c2067 PMD 0
> [162276.341116] Oops: 0002 [#1] SMP
> [162276.341133] Modules linked in: xfs libcrc32c xt_conntrack veth
> xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4
> iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat
> nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc
> intel_rapl iosf_mbi x86_pkg_temp_thermal intel_powerclamp coretemp
> kvm_intel kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
> aesni_intel aes_x86_64 lrw eeepc_wmi gf128mul asus_wmi glue_helper
> sparse_keymap ablk_helper cryptd ie31200_edac shpchp lpc_ich edac_core
> mac_hid 8250_fintek tpm_infineon wmi serio_raw video lp parport btrfs
> raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor
> async_tx xor raid6_pq e1000e raid1 raid0 ahci ptp libahci multipath
> pps_core linear [last unloaded: xfs]
> [162276.341394] CPU: 6 PID: 12853 Comm: mysqld Not tainted
> 4.1.0-040100rc7-generic #201506080035
> [162276.341428] Hardware name: System manufacturer System Product
> Name/P8B WS, BIOS 0904 10/24/2011
> [162276.341463] task: ffff8800730d8a10 ti: ffff88047a0f8000 task.ti:
> ffff88047a0f8000
> [162276.341495] RIP: 0010:[<ffffffff810c06cd>]  [<ffffffff810c06cd>]
> prepare_to_wait_event+0xcd/0x100
> [162276.341532] RSP: 0018:ffff88047a0fbcd8  EFLAGS: 00010046
> [162276.341583] RDX: ffff88047a0fbd48 RSI: ffff8800730d8a10 RDI:
> ffff8801e2f96ee8
> [162276.341615] RBP: ffff88047a0fbd08 R08: 0000000000000000 R09:
> 0000000000000001
> [162276.341646] R10: 0000000000000001 R11: 0000000000000000 R12:
> ffff8801e2f96ee8
> [162276.341678] R13: 0000000000000002 R14: ffff8801e2f96e60 R15:
> ffff8806b513f248
> [162276.341709] FS:  00007f9f2bbd3700(0000) GS:ffff88082fb80000(0000)
> knlGS:0000000000000000
>
> Remote syslog does not capture anything.
No backtrace?

Without backtrace, it's much harder to debug for us.
It's quite possible that some codes go mad and pass a NULL pointer,
and then wait_event() is called on the NULL->some_member.

Anyway, backtrace is needed to debug this.

If syslog can't help, what about kdump + crash to get the backtrace?

Thanks,
Qu
>
> The above crash does not point at btrfs - although the box does not
> crash with the same tests done on ext4. The box passes memtests and is
> generally stable otherwise.
>
> How can I debug this further?
>
>
> "prepare_to_wait_event" can be found here in 4.1-rc7 kernel:
>
> include/linux/wait.h:           long __int = prepare_to_wait_event(&wq,
> &__wait, state);\
> include/linux/wait.h:long prepare_to_wait_event(wait_queue_head_t *q,
> wait_queue_t *wait, int state);
> kernel/sched/wait.c:long prepare_to_wait_event(wait_queue_head_t *q,
> wait_queue_t *wait, int state)
> kernel/sched/wait.c:EXPORT_SYMBOL(prepare_to_wait_event);
>
>
>
