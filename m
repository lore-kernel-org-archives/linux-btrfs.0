Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:40975 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243AbcCSBRn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 21:17:43 -0400
Received: by mail-vk0-f44.google.com with SMTP id e185so161327099vkb.1
        for <linux-btrfs@vger.kernel.org>; Fri, 18 Mar 2016 18:17:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160318193937.GA21352@jek-Latitude-E7440>
References: <20160318193937.GA21352@jek-Latitude-E7440>
Date: Fri, 18 Mar 2016 18:17:38 -0700
Message-ID: <CAKWEGV5zqsDaBtGJQQrp359mCT4gZP861xj+_LFzf8FOaevCaA@mail.gmail.com>
Subject: Re: Global hotspare functionality
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: linux-btrfs@vger.kernel.org
Cc: Anand Jain <Anand.Jain@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Issue 5:

Race between close_ctree() and casualty_kthread():

close_ctree():
        if (fs_info->casualty_kthread)
                kthread_stop(fs_info->casualty_kthread);

casualty_kthread():
out:
        fs_info->casualty_kthread = NULL;


At SMP system, kthread_stop() argument can be changed to NULL after
check in if (). Some kind of synchronization is needed.

Oops:

[48878.674314] BUG: unable to handle kernel paging request at 0000000000001347
[48878.686252] IP: [<ffffffff810a73a4>] kthread_stop+0x54/0x280
[48878.687530] PGD 5f2c6067 PUD 62c63067 PMD 0
[48878.688780] Oops: 0002 [#1] SMP
[48878.689701] Modules linked in: cpuid cpufreq_powersave
cpufreq_stats cpufreq_userspace cpufreq_conservative softdog nfsd
auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc
ipmi_devintf ipmi_msghandler iosf_mbi crct10dif_pclmul crc32_pclmul
sha256_ssse3 sha256_generic hmac drbg ansi_cprng iTCO_wdt
iTCO_vendor_support snd_pcm snd_timer snd soundcore aesni_intel
aes_x86_64 lrw gf128mul glue_helper ablk_helper lpc_ich cryptd
mfd_core psmouse serio_raw 8250_fintek parport_pc evdev parport video
pcspkr ac battery acpi_cpufreq tpm_tis tpm processor i2c_piix4
rng_core button btrfs xor raid6_pq dm_mod raid1 md_mod sg sd_mod ahci
libahci libata pcnet32 crc32c_intel scsi_mod mii
[48879.282797] CPU: 1 PID: 24369 Comm: umount Not tainted 4.4.5-scst31x+ #16
[48879.283976] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[48879.285532] task: ffff880036438440 ti: ffff88006242c000 task.ti:
ffff88006242c000
[48879.288022] RIP: 0010:[<ffffffff810a73a4>]  [<ffffffff810a73a4>]
kthread_stop+0x54/0x280
[48879.289681] RSP: 0018:ffff88006242fd78  EFLAGS: 00010206
[48879.290678] RAX: 0000000000000001 RBX: 00000000000013af RCX: 0000000000000003
[48879.291889] RDX: 0000000000000000 RSI: 0000000000001347 RDI: 0000000000000246
[48879.293096] RBP: ffff88006242fd90 R08: ffff88006242fd38 R09: 0000000000000000
[48879.449616] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88002642e840
[48879.494970] R13: ffff880036438440 R14: 0000000000000000 R15: ffff880048b7f000
[48879.496219] FS:  00007f95236c27e0(0000) GS:ffff880066b00000(0000)
knlGS:0000000000000000
[48879.497767] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[48879.498806] CR2: 0000000000001347 CR3: 000000005ed74000 CR4: 00000000000406e0
[48879.500027] Stack:
[48879.500603]  ffff880027f4a2d0 ffff880027f48000 ffff880036438440
ffff88006242fdf0
[48879.502516]  ffffffffa016713d ffff88006242fe00 ffffffff81239ff5
ffff880039cf2000
[48879.505658]  ffff880039cf2a40 ffff880062430000 ffff880039cf2000
ffffffffa01edae0
[48879.507584] Call Trace:
[48879.508239]  [<ffffffffa016713d>] close_ctree+0x13d/0x390 [btrfs]
[48879.509328]  [<ffffffff81239ff5>] ? evict_inodes+0x165/0x180
[48879.510360]  [<ffffffffa0135f99>] btrfs_put_super+0x19/0x20 [btrfs]
[48879.511467]  [<ffffffff8121d0ff>] generic_shutdown_super+0x6f/0xf0
[48879.512570]  [<ffffffff8121d3f2>] kill_anon_super+0x12/0x20
[48879.594205]  [<ffffffffa0136a88>] btrfs_kill_super+0x18/0x120 [btrfs]
[48879.714563]  [<ffffffff8121d66e>] deactivate_locked_super+0x3e/0x70
[48879.715691]  [<ffffffff8121dabc>] deactivate_super+0x5c/0x60
[48879.716720]  [<ffffffff8123e07f>] cleanup_mnt+0x3f/0x90
[48879.717695]  [<ffffffff8123e112>] __cleanup_mnt+0x12/0x20
[48879.718695]  [<ffffffff810a5423>] task_work_run+0x73/0xa0
[48879.719692]  [<ffffffff810032ac>] exit_to_usermode_loop+0xcc/0xd0
[48879.720773]  [<ffffffff81003e0c>] syscall_return_slowpath+0xcc/0xe0
[48879.721880]  [<ffffffff81634022>] int_ret_from_sys_call+0x25/0x9f
[48879.722962] Code: 85 c0 0f 85 90 01 00 00 65 ff 0d 48 4b f6 7e f0
41 ff 44 24 10 49 8b 9c 24 38 04 00 00 48 85 db 74 26 48 89 de 48 83
ee 68 74 1d <f0> 80 4b 98 02 4c 89 e7 e8 ff fe ff ff 4c 89 e7 e8 a7 ca
00 00
[48879.891283] RIP  [<ffffffff810a73a4>] kthread_stop+0x54/0x280
[48880.019550]  RSP <ffff88006242fd78>
[48880.091281] CR2: 0000000000001347
[48880.133312] ---[ end trace 8f0228d92754702e ]---
