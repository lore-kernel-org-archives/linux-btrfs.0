Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38592 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729754AbeGQVHV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Jul 2018 17:07:21 -0400
Date: Tue, 17 Jul 2018 13:32:57 -0700
From: Marc MERLIN <marc@merlins.org>
To: Su Yue <Damenly_Su@gmx.com>
Cc: Su Yue <suy.fnst@cn.fujitsu.com>, quwenruo.btrfs@gmx.com,
        linux-btrfs@vger.kernel.org
Subject: btrfs check (not lowmem) and OOM-like hangs (4.17.6)
Message-ID: <20180717203257.GA10237@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 17, 2018 at 10:50:32AM -0700, Marc MERLIN wrote:
> I got the following on 4.17.6 while running btrfs check --repair on an
> unmounted filesystem (not the lowmem version)
> 
> I understand that btrfs check is userland only, although it seems that
> it caused these FS hangs on a different filesystem (the trace of course
> does not provide info on which FS)
> 
> Any idea what happened here?
> I'm going to wait a few hours without running btrfs check to see if it
> happens again and then if running btrfs check will re-create this issue,
> but other suggestions (if any), are welcome:

Hi Qu, I know we were talking about this last week and then, btrfs check
just worked for me so I wasn't able to reproduce.
Now I'm able to reproduce again.

I tried again, it's definitely triggered by btrfs check --repair

I tried to capture what happens, and memory didn't dip to 0, but the system
got very slow and things started failing.
btrfs was never killed though while ssh was.
Is there a chance that maybe btrfs is in some kernel OOM exclude list?

Here is what I got when the system was not doing well (it took minutes to run):

             total       used       free     shared    buffers     cached
Mem:      32643788   32070952     572836          0     102160    4378772
-/+ buffers/cache:   27590020    5053768
Swap:     15616764     973596   14643168

gargamel:~# cat /proc/meminfo
MemTotal:       32643788 kB
MemFree:         2726276 kB
MemAvailable:    2502200 kB
Buffers:           12360 kB
Cached:          1676388 kB
SwapCached:     11048580 kB
Active:         16443004 kB
Inactive:       12010456 kB
Active(anon):   16287780 kB
Inactive(anon): 11651692 kB
Active(file):     155224 kB
Inactive(file):   358764 kB
Unevictable:        5776 kB
Mlocked:            5776 kB
SwapTotal:      15616764 kB
SwapFree:         294592 kB
Dirty:              3032 kB
Writeback:         76064 kB
AnonPages:      15723272 kB
Mapped:           612124 kB
Shmem:           1171032 kB
Slab:             399824 kB
SReclaimable:      84568 kB
SUnreclaim:       315256 kB
KernelStack:       20576 kB
PageTables:        94268 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    31938656 kB
Committed_AS:   37909452 kB
VmallocTotal:   34359738367 kB
VmallocUsed:           0 kB
VmallocChunk:          0 kB
HardwareCorrupted:     0 kB
AnonHugePages:     98304 kB
ShmemHugePages:        0 kB
ShmemPmdMapped:        0 kB
CmaTotal:          16384 kB
CmaFree:               0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:               0 kB
DirectMap4k:      355604 kB
DirectMap2M:    32897024 kB

and console:
[ 9184.345329] INFO: task zmtrigger.pl:9981 blocked for more than 120 seconds.
[ 9184.366258]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4
[ 9184.385323] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9184.408803] zmtrigger.pl    D    0  9981   9804 0x20020080
[ 9184.425249] Call Trace:
[ 9184.432580]  ? __schedule+0x53e/0x59b
[ 9184.443551]  schedule+0x7f/0x98
[ 9184.452960]  io_schedule+0x16/0x38
[ 9184.463154]  wait_on_page_bit_common+0x10c/0x199
[ 9184.476996]  ? file_check_and_advance_wb_err+0xd7/0xd7
[ 9184.493339]  shmem_getpage_gfp+0x2dd/0x975
[ 9184.506558]  shmem_fault+0x188/0x1c3
[ 9184.518199]  ? filemap_map_pages+0x6f/0x295
[ 9184.531680]  __do_fault+0x1d/0x6e
[ 9184.542505]  __handle_mm_fault+0x675/0xa61
[ 9184.555653]  ? list_move+0x21/0x3a
[ 9184.566737]  handle_mm_fault+0x11c/0x16b
[ 9184.579355]  __do_page_fault+0x324/0x41c
[ 9184.591996]  ? page_fault+0x8/0x30
[ 9184.603059]  page_fault+0x1e/0x30
[ 9184.613846] RIP: 0023:0xf7d2d022
[ 9184.624366] RSP: 002b:00000000ffeb9fe8 EFLAGS: 00010202
[ 9184.640868] RAX: 00000000f7eed000 RBX: 00000000567e6000 RCX: 0000000000000004
[ 9184.663095] RDX: 00000000587fecb0 RSI: 000000005876538c RDI: 0000000000000004
[ 9184.685308] RBP: 0000000058185160 R08: 0000000000000000 R09: 0000000000000000
[ 9184.707524] R10: 0000000000000000 R11: 0000000000000286 R12: 0000000000000000
[ 9184.729757] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 9184.751988] INFO: task /usr/sbin/apach:11868 blocked for more than 120 seconds.
[ 9184.775106]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4
[ 9184.795072] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9184.819423] /usr/sbin/apach D    0 11868  11311 0x20020080
[ 9184.836748] Call Trace:
[ 9184.844926]  ? __schedule+0x53e/0x59b
[ 9184.856811]  schedule+0x7f/0x98
[ 9184.867075]  io_schedule+0x16/0x38
[ 9184.878114]  wait_on_page_bit_common+0x10c/0x199
[ 9184.892807]  ? file_check_and_advance_wb_err+0xd7/0xd7
[ 9184.909036]  shmem_getpage_gfp+0x2dd/0x975
[ 9184.922157]  shmem_fault+0x188/0x1c3
[ 9184.933667]  ? filemap_map_pages+0x6f/0x295
[ 9184.947504]  __do_fault+0x1d/0x6e
[ 9184.958234]  __handle_mm_fault+0x675/0xa61
[ 9184.971581]  handle_mm_fault+0x11c/0x16b
[ 9184.984114]  __do_page_fault+0x324/0x41c
[ 9184.996584]  ? page_fault+0x8/0x30
[ 9185.007462]  page_fault+0x1e/0x30
[ 9185.018085] RIP: 0023:0xf7aaa89e
[ 9185.028414] RSP: 002b:00000000ffb26f70 EFLAGS: 00210297
[ 9185.044686] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000f7eb9ed8
[ 9185.066697] RDX: 00000000f3664820 RSI: 0000000056e8ad20 RDI: 00000000f7aaee40
[ 9185.088720] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 9185.110713] R10: 0000000000000000 R11: 0000000000200282 R12: 0000000000000000
[ 9185.132677] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 9305.182796] INFO: task atop:6459 blocked for more than 120 seconds.
[ 9305.202538]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4
[ 9305.222445] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9305.246536] atop            D    0  6459      1 0x20020080
[ 9305.263597] Call Trace:
[ 9305.271548]  ? __schedule+0x53e/0x59b
[ 9305.283242]  schedule+0x7f/0x98
[ 9305.293336]  io_schedule+0x16/0x38
[ 9305.304602]  wait_on_page_bit_common+0x10c/0x199
[ 9305.319074]  ? file_check_and_advance_wb_err+0xd7/0xd7
[ 9305.335182]  __lock_page_or_retry+0x6c/0x75
[ 9305.348811]  do_swap_page+0x21f/0x511
[ 9305.360470]  __handle_mm_fault+0x9c2/0xa61
[ 9305.373441]  ? zone_statistics+0x4c/0x60
[ 9305.385854]  handle_mm_fault+0x11c/0x16b
[ 9305.398797]  __get_user_pages+0x364/0x505
[ 9305.411513]  get_user_pages_remote+0x8e/0x18d
[ 9305.425209]  __access_remote_vm+0x8c/0x1b4
[ 9305.438135]  proc_pid_cmdline_read+0x13b/0x3dd
[ 9305.452150]  ? do_filp_open+0x99/0xc6
[ 9305.463786]  ? __vfs_read+0x33/0xcc
[ 9305.474901]  __vfs_read+0x33/0xcc
[ 9305.485476]  ? current_kernel_time64+0x10/0x36
[ 9305.499916]  vfs_read+0x97/0xcc
[ 9305.510013]  ksys_read+0x5c/0x9f
[ 9305.520301]  do_fast_syscall_32+0xaf/0xf3
[ 9305.533157]  entry_SYSENTER_compat+0x7f/0x91
[ 9305.546619] INFO: task zmtrigger.pl:9981 blocked for more than 120 seconds.
[ 9305.568354]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4
[ 9305.588237] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9305.612340] zmtrigger.pl    D    0  9981   9804 0x20020080
[ 9305.629607] Call Trace:
[ 9305.637714]  ? __schedule+0x53e/0x59b
[ 9305.649350]  schedule+0x7f/0x98
[ 9305.659441]  io_schedule+0x16/0x38
[ 9305.670283]  wait_on_page_bit_common+0x10c/0x199
[ 9305.684771]  ? file_check_and_advance_wb_err+0xd7/0xd7
[ 9305.700839]  shmem_getpage_gfp+0x2dd/0x975
[ 9305.713854]  shmem_fault+0x188/0x1c3
[ 9305.725230]  ? filemap_map_pages+0x6f/0x295
[ 9305.738416]  __do_fault+0x1d/0x6e
[ 9305.749000]  __handle_mm_fault+0x675/0xa61
[ 9305.761923]  ? list_move+0x21/0x3a
[ 9305.772857]  handle_mm_fault+0x11c/0x16b
[ 9305.785262]  __do_page_fault+0x324/0x41c
[ 9305.797733]  ? page_fault+0x8/0x30
[ 9305.808581]  page_fault+0x1e/0x30
[ 9305.819429] RIP: 0023:0xf7d2d022
[ 9305.829797] RSP: 002b:00000000ffeb9fe8 EFLAGS: 00010202
[ 9305.846085] RAX: 00000000f7eed000 RBX: 00000000567e6000 RCX: 0000000000000004
[ 9305.868212] RDX: 00000000587fecb0 RSI: 000000005876538c RDI: 0000000000000004
[ 9305.890279] RBP: 0000000058185160 R08: 0000000000000000 R09: 0000000000000000
[ 9305.912266] R10: 0000000000000000 R11: 0000000000000286 R12: 0000000000000000
[ 9305.934291] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 9305.956295] INFO: task /usr/sbin/apach:11868 blocked for more than 120 seconds.
[ 9305.978927]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4
[ 9305.998652] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9306.022742] /usr/sbin/apach D    0 11868  11311 0x20020080
[ 9306.040041] Call Trace:
[ 9306.048029]  ? __schedule+0x53e/0x59b
[ 9306.059703]  schedule+0x7f/0x98
[ 9306.069772]  io_schedule+0x16/0x38
[ 9306.080615]  wait_on_page_bit_common+0x10c/0x199
[ 9306.095146]  ? file_check_and_advance_wb_err+0xd7/0xd7
[ 9306.111423]  shmem_getpage_gfp+0x2dd/0x975
[ 9306.124384]  shmem_fault+0x188/0x1c3
[ 9306.135746]  ? filemap_map_pages+0x6f/0x295
[ 9306.148943]  __do_fault+0x1d/0x6e
[ 9306.159540]  __handle_mm_fault+0x675/0xa61
[ 9306.172531]  handle_mm_fault+0x11c/0x16b
[ 9306.184947]  __do_page_fault+0x324/0x41c
[ 9306.197544]  ? page_fault+0x8/0x30
[ 9306.208405]  page_fault+0x1e/0x30
[ 9306.219016] RIP: 0023:0xf7aaa89e
[ 9306.229524] RSP: 002b:00000000ffb26f70 EFLAGS: 00210297
[ 9306.245994] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000f7eb9ed8
[ 9306.268285] RDX: 00000000f3664820 RSI: 0000000056e8ad20 RDI: 00000000f7aaee40
[ 9306.290641] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[ 9306.313028] R10: 0000000000000000 R11: 0000000000200282 R12: 0000000000000000
[ 9306.335441] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 9306.357849] INFO: task pgrep:5570 blocked for more than 120 seconds.
[ 9306.377918]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4
[ 9306.397989] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9306.422282] pgrep           D    0  5570   5567 0x20020080
[ 9306.439795] Call Trace:
[ 9306.447754]  ? __schedule+0x53e/0x59b
[ 9306.459419]  schedule+0x7f/0x98
[ 9306.469460]  io_schedule+0x16/0x38
[ 9306.480275]  wait_on_page_bit_common+0x10c/0x199
[ 9306.494738]  ? file_check_and_advance_wb_err+0xd7/0xd7
[ 9306.510783]  __lock_page_or_retry+0x6c/0x75
[ 9306.523970]  do_swap_page+0x21f/0x511
[ 9306.535593]  ? btrfs_bio_counter_sub+0x1e/0x4c
[ 9306.549560]  __handle_mm_fault+0x9c2/0xa61
[ 9306.562483]  ? ktime_get+0x31/0x41
[ 9306.573324]  handle_mm_fault+0x11c/0x16b
[ 9306.585723]  __get_user_pages+0x364/0x505
[ 9306.598377]  get_user_pages_remote+0x8e/0x18d
[ 9306.612083]  __access_remote_vm+0x8c/0x1b4
[ 9306.625009]  proc_pid_cmdline_read+0x13b/0x3dd
[ 9306.638977]  ? do_filp_open+0x99/0xc6
[ 9306.650599]  ? __vfs_read+0x33/0xcc
[ 9306.661690]  __vfs_read+0x33/0xcc
[ 9306.672257]  ? current_kernel_time64+0x10/0x36
[ 9306.686182]  vfs_read+0x97/0xcc
[ 9306.696363]  ksys_read+0x5c/0x9f
[ 9306.706638]  do_fast_syscall_32+0xaf/0xf3
[ 9306.719293]  entry_SYSENTER_compat+0x7f/0x91
[ 9306.732717] INFO: task pgrep:5579 blocked for more than 120 seconds.
[ 9306.752547]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4
[ 9306.772223] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9306.796319] pgrep           D    0  5579   4327 0x20020080
[ 9306.813577] Call Trace:
[ 9306.821562]  ? __schedule+0x53e/0x59b
[ 9306.833180]  schedule+0x7f/0x98
[ 9306.843275]  io_schedule+0x16/0x38
[ 9306.854164]  wait_on_page_bit_common+0x10c/0x199
[ 9306.868651]  ? file_check_and_advance_wb_err+0xd7/0xd7
[ 9306.884730]  __lock_page_or_retry+0x6c/0x75
[ 9306.897942]  do_swap_page+0x21f/0x511
[ 9306.909566]  ? aac_scsi_cmd+0x455/0x117b [aacraid]
[ 9306.924630]  __handle_mm_fault+0x9c2/0xa61
[ 9306.937594]  ? ktime_get+0x31/0x41
[ 9306.948478]  handle_mm_fault+0x11c/0x16b
[ 9306.961081]  __get_user_pages+0x364/0x505
[ 9306.973748]  get_user_pages_remote+0x8e/0x18d
[ 9306.987598]  __access_remote_vm+0x8c/0x1b4
[ 9307.000744]  proc_pid_cmdline_read+0x13b/0x3dd
[ 9307.014868]  ? do_filp_open+0x99/0xc6
[ 9307.026676]  ? __vfs_read+0x33/0xcc
[ 9307.037927]  __vfs_read+0x33/0xcc
[ 9307.048670]  ? current_kernel_time64+0x10/0x36
[ 9307.062789]  vfs_read+0x97/0xcc
[ 9307.072860]  ksys_read+0x5c/0x9f
[ 9307.083171]  do_fast_syscall_32+0xaf/0xf3
[ 9307.095810]  entry_SYSENTER_compat+0x7f/0x91
[ 9428.060462] INFO: task atop:6459 blocked for more than 120 seconds.
[ 9428.080112]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4
[ 9428.099816] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9428.123975] atop            D    0  6459      1 0x20020080
[ 9428.141515] Call Trace:
[ 9428.149507]  ? __schedule+0x53e/0x59b
[ 9428.161247]  schedule+0x7f/0x98
[ 9428.171320]  io_schedule+0x16/0x38
[ 9428.182181]  wait_on_page_bit_common+0x10c/0x199
[ 9428.196674]  ? file_check_and_advance_wb_err+0xd7/0xd7
[ 9428.212767]  __lock_page_or_retry+0x6c/0x75
[ 9428.225983]  do_swap_page+0x21f/0x511
[ 9428.237625]  __handle_mm_fault+0x9c2/0xa61
[ 9428.250579]  ? zone_statistics+0x4c/0x60
[ 9428.262977]  handle_mm_fault+0x11c/0x16b
[ 9428.275429]  __get_user_pages+0x364/0x505
[ 9428.288117]  get_user_pages_remote+0x8e/0x18d
[ 9428.301873]  __access_remote_vm+0x8c/0x1b4
[ 9428.314854]  proc_pid_cmdline_read+0x13b/0x3dd
[ 9428.328897]  ? do_filp_open+0x99/0xc6
[ 9428.340536]  ? __vfs_read+0x33/0xcc
[ 9428.351626]  __vfs_read+0x33/0xcc
[ 9428.362181]  ? current_kernel_time64+0x10/0x36
[ 9428.376107]  vfs_read+0x97/0xcc
[ 9428.386112]  ksys_read+0x5c/0x9f
[ 9428.396406]  do_fast_syscall_32+0xaf/0xf3
[ 9428.409029]  entry_SYSENTER_compat+0x7f/0x91
[ 9428.422465] INFO: task zmtrigger.pl:9981 blocked for more than 120 seconds.
[ 9428.443947]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4
[ 9428.463635] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9428.487740] zmtrigger.pl    D    0  9981   9804 0x20020080
[ 9428.504827] Call Trace:
[ 9428.512804]  ? __schedule+0x53e/0x59b
[ 9428.524426]  schedule+0x7f/0x98
[ 9428.534486]  io_schedule+0x16/0x38
[ 9428.545325]  wait_on_page_bit_common+0x10c/0x199
[ 9428.559813]  ? file_check_and_advance_wb_err+0xd7/0xd7
[ 9428.575860]  shmem_getpage_gfp+0x2dd/0x975
[ 9428.588802]  shmem_fault+0x188/0x1c3
[ 9428.600161]  ? filemap_map_pages+0x6f/0x295
[ 9428.613348]  __do_fault+0x1d/0x6e
[ 9428.623960]  __handle_mm_fault+0x675/0xa61
[ 9428.636934]  ? list_move+0x21/0x3a
[ 9428.647968]  handle_mm_fault+0x11c/0x16b
[ 9428.660517]  __do_page_fault+0x324/0x41c
[ 9428.672990]  ? page_fault+0x8/0x30
[ 9428.683846]  page_fault+0x1e/0x30
[ 9428.694437] RIP: 0023:0xf7d2d022
[ 9428.704744] RSP: 002b:00000000ffeb9fe8 EFLAGS: 00010202
[ 9428.721025] RAX: 00000000f7eed000 RBX: 00000000567e6000 RCX: 0000000000000004
[ 9428.743062] RDX: 00000000587fecb0 RSI: 000000005876538c RDI: 0000000000000004
[ 9428.765091] RBP: 0000000058185160 R08: 0000000000000000 R09: 0000000000000000
[ 9428.787241] R10: 0000000000000000 R11: 0000000000000286 R12: 0000000000000000
[ 9428.809265] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 9428.831501] INFO: task /usr/sbin/apach:11868 blocked for more than 120 seconds.
[ 9428.854070]       Not tainted 4.17.6-amd64-preempt-sysrq-20180818 #4
[ 9428.873815] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 9428.897937] /usr/sbin/apach D    0 11868  11311 0x20020080
[ 9428.915023] Call Trace:
[ 9428.923002]  ? __schedule+0x53e/0x59b
[ 9428.934625]  schedule+0x7f/0x98
[ 9428.944687]  io_schedule+0x16/0x38
[ 9428.955525]  wait_on_page_bit_common+0x10c/0x199
[ 9428.970014]  ? file_check_and_advance_wb_err+0xd7/0xd7
[ 9428.986074]  shmem_getpage_gfp+0x2dd/0x975
[ 9428.999006]  shmem_fault+0x188/0x1c3
[ 9429.010366]  ? filemap_map_pages+0x6f/0x295
[ 9429.023551]  __do_fault+0x1d/0x6e
[ 9429.034140]  __handle_mm_fault+0x675/0xa61
[ 9429.047056]  handle_mm_fault+0x11c/0x16b
[ 9429.059461]  __do_page_fault+0x324/0x41c
[ 9429.071857]  ? page_fault+0x8/0x30
[ 9429.082703]  page_fault+0x1e/0x30
[ 9429.093276] RIP: 0023:0xf7aaa89e
[ 9429.103591] RSP: 002b:00000000ffb26f70 EFLAGS: 00210297
[ 9429.119892] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 00000000f7eb9ed8

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
