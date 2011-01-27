From: "Jim Schutt" <jaschut@sandia.gov>
Subject: btrfs BUG during Ceph cosd truncate() syscall
Date: Thu, 27 Jan 2011 09:05:15 -0700
Message-ID: <1296144315.23762.91.camel@sale659.sandia.gov>
References: <1296057606.23762.56.camel@sale659.sandia.gov>
 <1296064793.23762.70.camel@sale659.sandia.gov>
 <1296067685.23762.74.camel@sale659.sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1296067685.23762.74.camel@sale659.sandia.gov>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I got this kernel BUG on a server running multiple Ceph
cosd instances.  I'm not sure what was going on at the
time, as I just noticed this on my serial console for
this node.

It looks like another example of the truncate issue in
Matt Weil's report.

Please let me know what other information is needed to 
make this report useful.

Thanks -- Jim

an4 login: [62397.925080] ------------[ cut here ]------------
[62397.926012] kernel BUG at fs/btrfs/inode.c:6403!
[62397.926012] invalid opcode: 0000 [#1] SMP 
[62397.926012] last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
[62397.926012] CPU 1 
[62397.926012] Modules linked in: loop btrfs zlib_deflate ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_tcpudp iptable_filter ip_tables x_tables bridge ]
[62397.994828] 
[62397.994828] Pid: 10514, comm: cosd Not tainted 2.6.37-00017-ga3f5274 #4 0DT097/PowerEdge 1950
[62397.994828] RIP: 0010:[<ffffffffa07834ff>]  [<ffffffffa07834ff>] btrfs_truncate+0x444/0x47a [btrfs]
[62397.994828] RSP: 0018:ffff8801a2e61d48  EFLAGS: 00010286
[62397.994828] RAX: 00000000ffffffe4 RBX: ffff88018c9c3a50 RCX: ffff8802136e9240
[62397.994828] RDX: ffff8802136e97e0 RSI: ffffea00074402f8 RDI: 0000000000000090
[62397.994828] RBP: ffff8801a2e61dd8 R08: ffffe8ffffc4ebe8 R09: 00000001e2a6a8c0
[62397.994828] R10: 0000000000000008 R11: 0000000000000016 R12: ffff8801e2a6a8c0
[62397.994828] R13: 0000000000000000 R14: ffff88018c9c3a50 R15: ffff880223b56800
[62397.994828] FS:  00007f6122b2e940(0000) GS:ffff8800cfc40000(0000) knlGS:0000000000000000
[62397.994828] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[62397.994828] CR2: 00007f7c1c7580a0 CR3: 00000001fc864000 CR4: 00000000000006e0
[62397.994828] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[62397.994828] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[62397.994828] Process cosd (pid: 10514, threadinfo ffff8801a2e60000, task ffff8801da311610)
[62397.994828] Stack:
[62397.994828]  0000000000000000 0000000000000000 0000000000000000 ffffffff00001000
[62397.994828]  ffff88018c9c38b8 ffff88018c9c3a50 ffff88018c9c3b78 0000000000000000
[62397.994828]  ffff88018c9c38e8 ffff88018c9c3b78 0000000000000000 ffffffff810b4960
[62397.994828] Call Trace:
[62397.994828]  [<ffffffff810b4960>] ? truncate_pagecache+0x52/0x5a
[62397.994828]  [<ffffffff810b49ca>] vmtruncate+0x44/0x50
[62397.994828]  [<ffffffffa078482c>] btrfs_setattr+0x205/0x24e [btrfs]
[62397.994828]  [<ffffffff810fe7fc>] notify_change+0x194/0x285
[62397.994828]  [<ffffffff810e9c0a>] do_truncate+0x71/0x90
[62397.994828]  [<ffffffff810f34f1>] ? generic_permission+0x1c/0x91
[62397.994828]  [<ffffffff810f3317>] ? get_write_access+0x1d/0x47
[62397.994828]  [<ffffffff810e9df7>] sys_truncate+0x112/0x124
[62397.994828]  [<ffffffff81002c2b>] system_call_fastpath+0x16/0x1b
[62397.994828] Code: 83 7e 5c 00 74 13 4c 89 f6 4c 89 e7 e8 00 cd ff ff 85 c0 74 04 0f 0b eb fe 4c 89 f2 4c 89 fe 4c 89 e7 e8 22 f6 ff ff 85 c0 74 04 <0f> 0b eb fe 4c 89 fe 4c 89 e7 49 8b 5c 24 20 e8 47 9e ff  
[62397.994828] RIP  [<ffffffffa07834ff>] btrfs_truncate+0x444/0x47a [btrfs]
[62397.994828]  RSP <ffff8801a2e61d48>
Jan 27 08:47:39 [62398.251586] ---[ end trace c4d86802177b259b ]---
an4 [62397.925080] ------------[ cut here ]------------
Jan 27 08:47:39 an4 [62397.926012] invalid opcode: 0000 [#1] SMP 
Jan 27 08:47:39 an4 [62397.926012] last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
Jan 27 08:47:39 an4 [62397.994828] Stack:
Jan 27 08:47:39 an4 [62397.994828] Call Trace:
Jan 27 08:47:39 an4 [62397.994828] Code: 83 7e 5c 00 74 13 4c 89 f6 4c 89 e7 e8 00 cd ff ff 85 c0 74 04 0f 0b eb fe 4c 89 f2 4c 89 fe 4c 89 e7 e8 22 f6 ff ff 85 c0 74 04 <0f> 0b eb fe 4c 89 fe 4c 89 e7 49 8b 5 



