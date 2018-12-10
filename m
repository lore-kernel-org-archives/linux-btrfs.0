Return-Path: <SRS0=qyTl=OT=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,T_MIXED_ES,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 581EFC5CFFE
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 12:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEA7C2084E
	for <linux-btrfs@archiver.kernel.org>; Mon, 10 Dec 2018 12:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEA7C2084E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cuci.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbeLJMN1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 10 Dec 2018 07:13:27 -0500
Received: from aristoteles.cuci.nl ([212.125.128.18]:38039 "EHLO
        aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbeLJMN1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Dec 2018 07:13:27 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Dec 2018 07:13:23 EST
Received: by aristoteles.cuci.nl (Postfix, from userid 500)
        id A45DB5463; Mon, 10 Dec 2018 13:05:14 +0100 (CET)
Date:   Mon, 10 Dec 2018 13:05:14 +0100
From:   "Stephen R. van den Berg" <srb@cuci.nl>
To:     linux-btrfs@vger.kernel.org
Subject: Kernel traces
Message-ID: <20181210120514.GA14828@cuci.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

For the (roughly) past 12 months, I've been experiencing the following
(repeatable, nightly) kernel traces on btrfs filesystems which are under
heavy (nightly backups) btrfs-receive traffic (over the network).

The problems intensify when the amount of data per second increases.
If the amount of data per second is high enough, either the whole kernel
locks up, or the btrfs filesystem hangs on all operations.
The oopses below were generated under moderate traffic levels and did not
cause a full kernel lockup and did not make the btrfs filesystem permanently
inaccessible (possibly temporarily unresponsive though).

My current way to mitigate this problem is by limiting the amount of network
traffic to below 3MB/s (which is, ridiculously low, I think).
Nonetheless, it should not be possible to lock up a system by increasing
bandwidth to the btrfs filesystem with btrfs-receive.

Any ideas?  I can apply custom patches to either test and get more output
or to test possible fixes.  It is on a production system, so dataloss is not
an option, but I can reboot it several times a day, if necessary.
I can increase the datarate to any desirable level to test if the problem
reoccurs or not.

(The most recent ones are from v4.19.7):

	Total devices 8 FS bytes used 8.98TiB
	devid    1 size 5.46TiB used 2.49TiB path /dev/sdf
	devid    2 size 5.46TiB used 2.49TiB path /dev/sdi
	devid    3 size 5.46TiB used 2.49TiB path /dev/sdh
	devid    4 size 5.46TiB used 2.49TiB path /dev/sdg
	devid    5 size 5.46TiB used 2.49TiB path /dev/sdj
	devid    6 size 5.46TiB used 2.49TiB path /dev/sdc
	devid    7 size 5.46TiB used 2.49TiB path /dev/sda
	devid    8 size 3.64TiB used 689.00GiB path /dev/sdb

[64389.127561] INFO: task btrfs:7518 blocked for more than 120 seconds.
[64389.132750]       Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
[64389.138421] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[64389.145126] btrfs           D    0  7518   7489 0x00000000
[64389.149481] Call Trace:
[64389.150755]  ? __schedule+0x4db/0x524
[64389.153220]  ? schedule+0x60/0x71
[64389.155342]  ? __rwsem_down_read_failed_common+0x180/0x1df
[64389.159679]  ? call_rwsem_down_read_failed+0x14/0x30
[64389.163541]  ? down_read+0x1c/0x2f
[64389.165755]  ? btrfs_ioctl_subvol_getflags+0x67/0xbb
[64389.169592]  ? btrfs_ioctl+0x2d8/0x2a51
[64389.172237]  ? current_time+0x67/0x88
[64389.174705]  ? pipe_write+0x356/0x369
[64389.177222]  ? vfs_ioctl+0x1e/0x2b
[64389.179439]  ? btrfs_ioctl_get_supported_features+0x22/0x22
[64389.183814]  ? vfs_ioctl+0x1e/0x2b
[64389.186048]  ? do_vfs_ioctl+0x523/0x54c
[64389.188742]  ? vfs_write+0xb2/0xdf
[64389.190958]  ? ksys_ioctl+0x3e/0x5d
[64389.193268]  ? __x64_sys_ioctl+0x16/0x19
[64389.196000]  ? do_syscall_64+0x4e/0x5b
[64389.198591]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

[64512.019259] INFO: task btrfs:7828 blocked for more than 120 seconds.
[64512.024455]       Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
[64512.030109] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[64512.036781] btrfs           D    0  7828   7771 0x00000000
[64512.041123] Call Trace:
[64512.042397]  ? __schedule+0x4db/0x524
[64512.044865]  ? schedule+0x60/0x71
[64512.046988]  ? __rwsem_down_write_failed_common+0x2ff/0x382
[64512.051443]  ? update_cfs_rq_load_avg+0x124/0x150
[64512.054964]  ? check_preempt_wakeup+0xfd/0x146
[64512.058222]  ? call_rwsem_down_write_failed+0x13/0x20
[64512.062125]  ? down_write+0x29/0x38
[64512.064429]  ? _btrfs_ioctl_set_received_subvol+0x90/0x2ab
[64512.068725]  ? btrfs_ioctl+0x1572/0x2a51
[64512.071508]  ? current_time+0x67/0x88
[64512.073992]  ? __switch_to_asm+0x40/0x70
[64512.076723]  ? __switch_to_asm+0x34/0x70
[64512.079504]  ? __switch_to_asm+0x40/0x70
[64512.082235]  ? __switch_to_asm+0x34/0x70
[64512.084963]  ? __switch_to_asm+0x40/0x70
[64512.087687]  ? __switch_to_asm+0x34/0x70
[64512.090458]  ? __switch_to_asm+0x40/0x70
[64512.093202]  ? __switch_to_asm+0x34/0x70
[64512.095927]  ? __switch_to_asm+0x40/0x70
[64512.098650]  ? __switch_to_asm+0x34/0x70
[64512.101427]  ? __switch_to_asm+0x40/0x70
[64512.104164]  ? __switch_to_asm+0x34/0x70
[64512.106891]  ? __switch_to_asm+0x40/0x70
[64512.109668]  ? vfs_ioctl+0x1e/0x2b
[64512.111887]  ? btrfs_ioctl_get_supported_features+0x22/0x22
[64512.116274]  ? vfs_ioctl+0x1e/0x2b
[64512.118479]  ? do_vfs_ioctl+0x523/0x54c
[64512.121159]  ? __switch_to_asm+0x34/0x70
[64512.123905]  ? __switch_to_asm+0x40/0x70
[64512.126637]  ? __switch_to+0x1c8/0x37f
[64512.129237]  ? finish_task_switch+0x113/0x1e6
[64512.132413]  ? ksys_ioctl+0x3e/0x5d
[64512.134703]  ? __x64_sys_ioctl+0x16/0x19
[64512.137426]  ? do_syscall_64+0x4e/0x5b
[64512.140043]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[64512.144084] INFO: task btrfs:7840 blocked for more than 120 seconds.
[64512.149282]       Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
[64512.154895] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[64512.161563] btrfs           D    0  7840   7691 0x00000000
[64512.165860] Call Trace:
[64512.167118]  ? __schedule+0x4db/0x524
[64512.169630]  ? schedule+0x60/0x71
[64512.171757]  ? __rwsem_down_read_failed_common+0x180/0x1df
[64512.176045]  ? call_rwsem_down_read_failed+0x14/0x30
[64512.179853]  ? down_read+0x1c/0x2f
[64512.182072]  ? btrfs_ioctl_subvol_getflags+0x67/0xbb
[64512.185858]  ? btrfs_ioctl+0x2d8/0x2a51
[64512.188503]  ? current_time+0x67/0x88
[64512.191026]  ? pipe_write+0x356/0x369
[64512.193505]  ? vfs_ioctl+0x1e/0x2b
[64512.195733]  ? btrfs_ioctl_get_supported_features+0x22/0x22
[64512.200162]  ? vfs_ioctl+0x1e/0x2b
[64512.202376]  ? do_vfs_ioctl+0x523/0x54c
[64512.205035]  ? vfs_write+0xb2/0xdf
[64512.207260]  ? ksys_ioctl+0x3e/0x5d
[64512.209600]  ? __x64_sys_ioctl+0x16/0x19
[64512.212353]  ? do_syscall_64+0x4e/0x5b
[64512.214936]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[64512.219027] INFO: task btrfs:15145 blocked for more than 120 seconds.
[64512.224292]       Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
[64512.229923] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[64512.236564] btrfs           D    0 15145  15124 0x00000000
[64512.240886] Call Trace:
[64512.242157]  ? __schedule+0x4db/0x524
[64512.244638]  ? schedule+0x60/0x71
[64512.246769]  ? __rwsem_down_read_failed_common+0x180/0x1df
[64512.251116]  ? call_rwsem_down_read_failed+0x14/0x30
[64512.254907]  ? down_read+0x1c/0x2f
[64512.257144]  ? btrfs_mksubvol+0x110/0x453
[64512.259997]  ? btrfs_ioctl_snap_create_transid+0x165/0x199
[64512.264301]  ? btrfs_ioctl_snap_create_v2+0xf1/0x154
[64512.268069]  ? btrfs_ioctl+0x87f/0x2a51
[64512.270755]  ? do_filp_open+0x89/0xaf
[64512.273235]  ? get_page+0x5/0xa
[64512.275178]  ? vfs_ioctl+0x1e/0x2b
[64512.277388]  ? btrfs_ioctl_get_supported_features+0x22/0x22
[64512.281811]  ? vfs_ioctl+0x1e/0x2b
[64512.284020]  ? do_vfs_ioctl+0x523/0x54c
[64512.286677]  ? cache_from_obj+0x22/0x57
[64512.289373]  ? ksys_ioctl+0x3e/0x5d
[64512.291673]  ? __x64_sys_ioctl+0x16/0x19
[64512.294400]  ? do_syscall_64+0x4e/0x5b
[64512.296959]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

[64634.890975] INFO: task btrfs:7823 blocked for more than 120 seconds.
[64634.896137]       Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
[64634.901800] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[64634.908461] btrfs           D    0  7823   7641 0x00000000
[64634.912806] Call Trace:
[64634.914070]  ? __schedule+0x4db/0x524
[64634.916540]  ? schedule+0x60/0x71
[64634.918656]  ? __rwsem_down_write_failed_common+0x2ff/0x382
[64634.923081]  ? apic_timer_interrupt+0xa/0x20
[64634.926193]  ? call_rwsem_down_write_failed+0x13/0x20
[64634.930053]  ? down_write+0x29/0x38
[64634.932398]  ? btrfs_ioctl_subvol_setflags+0xc5/0x1fb
[64634.936259]  ? btrfs_ioctl+0x13a/0x2a51
[64634.938943]  ? current_time+0x67/0x88
[64634.941467]  ? pipe_write+0x356/0x369
[64634.943937]  ? vfs_ioctl+0x1e/0x2b
[64634.946174]  ? btrfs_ioctl_get_supported_features+0x22/0x22
[64634.950597]  ? vfs_ioctl+0x1e/0x2b
[64634.952804]  ? do_vfs_ioctl+0x523/0x54c
[64634.965173]  ? vfs_write+0xb2/0xdf
[64634.967417]  ? ksys_ioctl+0x3e/0x5d
[64634.969712]  ? __x64_sys_ioctl+0x16/0x19
[64634.972482]  ? do_syscall_64+0x4e/0x5b
[64634.975043]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[64634.979075] INFO: task btrfs:7831 blocked for more than 120 seconds.
[64634.984266]       Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
[64634.989885] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[64634.996560] btrfs           D    0  7831   7755 0x00000000
[64635.000865] Call Trace:
[64635.002126]  ? __schedule+0x4db/0x524
[64635.004608]  ? schedule+0x60/0x71
[64635.006757]  ? __rwsem_down_read_failed_common+0x180/0x1df
[64635.011092]  ? call_rwsem_down_read_failed+0x14/0x30
[64635.014876]  ? down_read+0x1c/0x2f
[64635.017087]  ? btrfs_ioctl_subvol_getflags+0x67/0xbb
[64635.020893]  ? btrfs_ioctl+0x2d8/0x2a51
[64635.023544]  ? current_time+0x67/0x88
[64635.026012]  ? __switch_to_asm+0x40/0x70
[64635.028770]  ? __switch_to_asm+0x34/0x70
[64635.031529]  ? __switch_to_asm+0x40/0x70
[64635.034261]  ? __switch_to_asm+0x34/0x70
[64635.036993]  ? __switch_to_asm+0x40/0x70
[64635.039720]  ? __switch_to_asm+0x34/0x70
[64635.042476]  ? __switch_to_asm+0x40/0x70
[64635.045210]  ? __switch_to_asm+0x34/0x70
[64635.047964]  ? __switch_to_asm+0x40/0x70
[64635.050731]  ? __switch_to_asm+0x34/0x70
[64635.053459]  ? __switch_to_asm+0x40/0x70
[64635.056188]  ? __switch_to_asm+0x34/0x70
[64635.058910]  ? __switch_to_asm+0x40/0x70
[64635.061670]  ? vfs_ioctl+0x1e/0x2b
[64635.063878]  ? btrfs_ioctl_get_supported_features+0x22/0x22
[64635.068281]  ? vfs_ioctl+0x1e/0x2b
[64635.070491]  ? do_vfs_ioctl+0x523/0x54c
[64635.073179]  ? __switch_to_asm+0x34/0x70
[64635.075913]  ? __switch_to_asm+0x40/0x70
[64635.078636]  ? __switch_to+0x1c8/0x37f
[64635.081219]  ? finish_task_switch+0x113/0x1e6
[64635.084384]  ? ksys_ioctl+0x3e/0x5d
[64635.086679]  ? __x64_sys_ioctl+0x16/0x19
[64635.089418]  ? do_syscall_64+0x4e/0x5b
[64635.092018]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[64635.096062] INFO: task btrfs:7840 blocked for more than 120 seconds.
[64635.101255]       Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
[64635.106866] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[64635.113532] btrfs           D    0  7840   7691 0x00000000
[64635.117827] Call Trace:
[64635.119083]  ? __schedule+0x4db/0x524
[64635.121583]  ? schedule+0x60/0x71
[64635.123715]  ? __rwsem_down_read_failed_common+0x180/0x1df
[64635.128002]  ? call_rwsem_down_read_failed+0x14/0x30
[64635.131810]  ? down_read+0x1c/0x2f
[64635.134031]  ? btrfs_ioctl_subvol_getflags+0x67/0xbb
[64635.137815]  ? btrfs_ioctl+0x2d8/0x2a51
[64635.140457]  ? current_time+0x67/0x88
[64635.142965]  ? pipe_write+0x356/0x369
[64635.145433]  ? vfs_ioctl+0x1e/0x2b
[64635.147643]  ? btrfs_ioctl_get_supported_features+0x22/0x22
[64635.152051]  ? vfs_ioctl+0x1e/0x2b
[64635.154262]  ? do_vfs_ioctl+0x523/0x54c
[64635.156919]  ? vfs_write+0xb2/0xdf
[64635.159126]  ? ksys_ioctl+0x3e/0x5d
[64635.161448]  ? __x64_sys_ioctl+0x16/0x19
[64635.164180]  ? do_syscall_64+0x4e/0x5b
[64635.166736]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[64635.170813] INFO: task btrfs:15145 blocked for more than 120 seconds.
[64635.176068]       Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
[64635.181703] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[64635.188354] btrfs           D    0 15145  15124 0x00000000
[64635.192676] Call Trace:
[64635.193939]  ? __schedule+0x4db/0x524
[64635.196410]  ? schedule+0x60/0x71
[64635.198527]  ? __rwsem_down_read_failed_common+0x180/0x1df
[64635.202854]  ? call_rwsem_down_read_failed+0x14/0x30
[64635.206651]  ? down_read+0x1c/0x2f
[64635.208858]  ? btrfs_mksubvol+0x110/0x453
[64635.211710]  ? btrfs_ioctl_snap_create_transid+0x165/0x199
[64635.216009]  ? btrfs_ioctl_snap_create_v2+0xf1/0x154
[64635.219792]  ? btrfs_ioctl+0x87f/0x2a51
[64635.222484]  ? do_filp_open+0x89/0xaf
[64635.224967]  ? get_page+0x5/0xa
[64635.226911]  ? vfs_ioctl+0x1e/0x2b
[64635.229121]  ? btrfs_ioctl_get_supported_features+0x22/0x22
[64635.233567]  ? vfs_ioctl+0x1e/0x2b
[64635.235778]  ? do_vfs_ioctl+0x523/0x54c
[64635.238443]  ? cache_from_obj+0x22/0x57
[64635.241132]  ? ksys_ioctl+0x3e/0x5d
[64635.243457]  ? __x64_sys_ioctl+0x16/0x19
[64635.246187]  ? do_syscall_64+0x4e/0x5b
[64635.248742]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
[64635.252813] INFO: task btrfs:16588 blocked for more than 120 seconds.
[64635.258065]       Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
[64635.263717] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[64635.270357] btrfs           D    0 16588  16585 0x00000000
[64635.274703] Call Trace:
[64635.275964]  ? __schedule+0x4db/0x524
[64635.278434]  ? mem_cgroup_commit_charge+0xb1/0xf3
[64635.281995]  ? schedule+0x60/0x71
[64635.284121]  ? __rwsem_down_write_failed_common+0x2ff/0x382
[64635.288496]  ? call_rwsem_down_write_failed+0x13/0x20
[64635.292393]  ? down_write+0x29/0x38
[64635.294696]  ? btrfs_delete_subvolume+0x9b/0x4d9
[64635.298116]  ? d_lookup+0x2d/0x3d
[64635.300239]  ? btrfs_ioctl_snap_destroy+0x245/0x2a3
[64635.303984]  ? btrfs_ioctl+0x8aa/0x2a51
[64635.306629]  ? __count_memcg_events+0x11/0x4e
[64635.309792]  ? mem_cgroup_commit_charge+0xb1/0xf3
[64635.313341]  ? get_page+0x5/0xa
[64635.315293]  ? __lru_cache_add+0x1e/0x4d
[64635.318015]  ? __handle_mm_fault+0x5f0/0x9cf
[64635.321123]  ? vfs_ioctl+0x1e/0x2b
[64635.323348]  ? btrfs_ioctl_get_supported_features+0x22/0x22
[64635.327731]  ? vfs_ioctl+0x1e/0x2b
[64635.329932]  ? do_vfs_ioctl+0x523/0x54c
[64635.332619]  ? handle_mm_fault+0x12f/0x17e
[64635.335523]  ? ksys_ioctl+0x3e/0x5d
[64635.337818]  ? __x64_sys_ioctl+0x16/0x19
[64635.340550]  ? do_syscall_64+0x4e/0x5b
[64635.343154]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

[64757.782746] INFO: task btrfs:7823 blocked for more than 120 seconds.
[64757.788007]       Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
[64757.793652] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[64757.800296] btrfs           D    0  7823   7641 0x00000000
[64757.804628] Call Trace:
[64757.805897]  ? __schedule+0x4db/0x524
[64757.808366]  ? schedule+0x60/0x71
[64757.810491]  ? __rwsem_down_write_failed_common+0x2ff/0x382
[64757.814892]  ? apic_timer_interrupt+0xa/0x20
[64757.817971]  ? call_rwsem_down_write_failed+0x13/0x20
[64757.821825]  ? down_write+0x29/0x38
[64757.824139]  ? btrfs_ioctl_subvol_setflags+0xc5/0x1fb
[64757.827999]  ? btrfs_ioctl+0x13a/0x2a51
[64757.830641]  ? current_time+0x67/0x88
[64757.833142]  ? pipe_write+0x356/0x369
[64757.835607]  ? vfs_ioctl+0x1e/0x2b
[64757.837819]  ? btrfs_ioctl_get_supported_features+0x22/0x22
[64757.842202]  ? vfs_ioctl+0x1e/0x2b
[64757.844437]  ? do_vfs_ioctl+0x523/0x54c
[64757.847084]  ? vfs_write+0xb2/0xdf
[64757.849293]  ? ksys_ioctl+0x3e/0x5d
[64757.851590]  ? __x64_sys_ioctl+0x16/0x19
[64757.854346]  ? do_syscall_64+0x4e/0x5b
[64757.856902]  ? entry_SYSCALL_64_after_hwframe+0x44/0xa9

The following ones are from the sister system, starting at an older date,
the older ones are from v4.19.1 and the newer ones from v4.19.7:

	Total devices 5 FS bytes used 2.48TiB
	devid    1 size 5.46TiB used 1.41TiB path /dev/sdb
	devid    2 size 5.46TiB used 1.41TiB path /dev/sdg
	devid    3 size 5.46TiB used 1.41TiB path /dev/sdf
	devid    4 size 5.46TiB used 1.41TiB path /dev/sde
	devid    5 size 3.64TiB used 0.00B path /dev/sda

Nov 11 07:43:15 argos kernel: INFO: task btrfs-transacti:1235 blocked for more than 120 seconds.
Nov 11 07:43:15 argos kernel:      Not tainted 94.19.1-srb-asrock-00001-gdffa15601442 #132
Nov 11 07:43:15 argos kernel: btrfs-transacti D    0  1235      2 0x80000000
Nov 11 07:43:15 argos kernel: Call Trace:
Nov 11 07:43:15 argos kernel: ? __schedule+0x4db/0x524
Nov 11 07:43:15 argos kernel: ? schedule+0x60/0x71
Nov 11 07:45:18 argos kernel: ? btrfs_start_ordered_extent+0xd3/0x105
Nov 11 07:45:18 argos kernel: ? finish_wait+0x60/0x60
Nov 11 07:45:18 argos kernel: ? btrfs_wait_ordered_range+0xa4/0x100
Nov 11 07:45:18 argos kernel: ? __btrfs_wait_cache_io+0x47/0x16d
Nov 11 07:45:18 argos kernel: ? btrfs_start_dirty_block_groups+0x111/0x390
Nov 11 07:45:18 argos kernel: ? btrfs_commit_transaction+0xd3/0x73b
Nov 11 07:47:21 argos kernel: ? kthread+0xeb/0xf0
Nov 11 07:47:21 argos kernel: ? __kthread_cancel_work+0x68/0x68
Nov 11 07:47:21 argos kernel: ? ret_from_fork+0x35/0x40
Nov 11 07:49:23 argos kernel: ? __btrfs_wait_cache_io+0x47/0x16d
Nov 11 07:49:23 argos kernel: ? btrfs_start_dirty_block_groups+0x111/0x390
Nov 11 07:49:23 argos kernel: ? start_transaction+0x2b8/0x329
Nov 11 07:49:23 argos kernel: ? transaction_kthread+0xc6/0x132
Nov 11 07:49:23 argos kernel: ? btrfs_cleanup_transaction+0x3ca/0x3ca
Nov 11 07:51:26 argos kernel: btrfs-transacti D    0  1235      2 0x80000000
Nov 11 07:51:26 argos kernel: Call Trace:
Nov 11 07:51:26 argos kernel: ? __schedule+0x4db/0x524
Nov 11 07:51:26 argos kernel: ? schedule+0x60/0x71
Nov 11 07:51:26 argos kernel: ? __btrfs_wait_cache_io+0x47/0x16d
Nov 11 07:51:26 argos kernel: ? btrfs_start_dirty_block_groups+0x111/0x390
Nov 11 07:51:26 argos kernel: ? btrfs_commit_transaction+0xd3/0x73b
Nov 11 07:51:26 argos kernel: ? kthread+0xeb/0xf0
Nov 11 07:51:26 argos kernel: ? __kthread_cancel_work+0x68/0x68
Nov 11 07:51:26 argos kernel: ? ret_from_fork+0x35/0x40
Nov 11 07:53:29 argos kernel: INFO: task btrfs-transacti:1235 blocked for more than 120 seconds.
Nov 11 07:53:29 argos kernel:      Not tainted 94.19.1-srb-asrock-00001-gdffa15601442 #132
Nov 11 07:53:29 argos kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 11 07:57:35 argos kernel: ? btrfs_start_ordered_extent+0xd3/0x105
Nov 11 07:57:35 argos kernel: ? finish_wait+0x60/0x60
Nov 11 07:57:35 argos kernel: ? btrfs_wait_ordered_range+0xa4/0x100

Nov 13 12:02:01 argos kernel: ? btrfs_start_ordered_extent+0xd3/0x105
Nov 13 12:06:07 argos kernel: INFO: task btrfs:26969 blocked for more than 120 seconds.
Nov 13 12:06:07 argos kernel:      Not tainted 94.19.1-srb-asrock-00001-gdffa15601442 #135
Nov 13 12:08:10 argos kernel: Call Trace:
Nov 13 12:30:06 argos kernel: perf: interrupt took too long (2506 > 2500), lowering kernel.perf_event_max_sample_rate to 79800
Nov 13 14:29:19 argos kernel: perf: interrupt took too long (3144 > 3132), lowering kernel.perf_event_max_sample_rate to 63600

Nov 14 07:41:40 argos kernel: ? btrfs_wait_ordered_range+0xa4/0x100
Nov 14 07:47:49 argos kernel: ? ret_from_fork+0x35/0x40

Nov 14 13:34:18 argos kernel: INFO: task btrfs:6654 blocked for more than 120 seconds.
Nov 14 13:34:18 argos kernel:      Not tainted 94.19.1-srb-asrock-00001-gdffa15601442 #135
Nov 14 13:34:18 argos kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 14 13:34:19 argos kernel: btrfs           D    0  6654   6649 0x00000000
Nov 14 13:34:19 argos kernel: Call Trace:
Nov 14 13:34:19 argos kernel: ? do_truncate+0x82/0xb6
Nov 14 13:34:19 argos kernel: ? kmem_cache_alloc+0x9a/0x100
Nov 14 13:34:19 argos kernel: ? vfs_truncate+0xbc/0xda
Nov 14 13:34:19 argos kernel: ? do_sys_truncate+0x60/0xa9
Nov 14 13:34:19 argos kernel: ? do_syscall_64+0x4e/0x5b
Nov 14 13:34:19 argos kernel: ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov 14 13:36:21 argos kernel: ? btrfs_wait_ordered_range+0xa4/0x100
Nov 14 13:36:21 argos kernel: ? unmap_mapping_pages+0x64/0x113
Nov 14 13:36:21 argos kernel: ? btrfs_setattr+0x20b/0x499

Nov 18 09:48:00 argos kernel: btrfs           D    0 26152  26147 0x00000000
Nov 18 09:48:00 argos kernel: ? __schedule+0x4db/0x524
Nov 18 09:48:00 argos kernel: ? finish_wait+0x60/0x60
Nov 18 09:48:00 argos kernel: ? notify_change+0x268/0x347
Nov 18 09:48:00 argos kernel: ? do_truncate+0x82/0xb6
Nov 18 09:48:00 argos kernel: ? kmem_cache_alloc+0x9a/0x100
Nov 18 09:48:00 argos kernel: ? vfs_truncate+0xbc/0xda
Nov 19 10:02:05 argos kernel: ? do_sys_truncate+0x60/0xa9
Nov 19 10:02:05 argos kernel: ? do_syscall_64+0x4e/0x5b
Nov 19 10:02:05 argos kernel: ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov 19 10:04:08 argos kernel: ? vfs_truncate+0xbc/0xda

Nov 22 12:22:53 argos kernel: INFO: task btrfs:19688 blocked for more than 120 seconds.
Nov 22 12:22:53 argos kernel:      Not tainted 94.19.1-srb-asrock-00001-gdffa15601442 #135
Nov 22 12:22:53 argos kernel: btrfs           D    0 19688  19683 0x00000000
Nov 22 12:22:53 argos kernel: Call Trace:
Nov 22 12:22:53 argos kernel: ? btrfs_wait_ordered_range+0xa4/0x100
Nov 22 12:22:53 argos kernel: ? unmap_mapping_pages+0x64/0x113

Nov 23 07:46:09 argos kernel: INFO: task btrfs-transacti:1234 blocked for more than 120 seconds.
Nov 23 07:46:09 argos kernel:      Not tainted 94.19.1-srb-asrock-00001-gdffa15601442 #135
Nov 23 07:46:09 argos kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 07:46:09 argos kernel: btrfs-transacti D    0  1234      2 0x80000000
Nov 23 07:46:09 argos kernel: ? btrfs_start_ordered_extent+0xd3/0x105
Nov 23 07:46:09 argos kernel: ? finish_wait+0x60/0x60
Nov 23 07:46:09 argos kernel: ? btrfs_wait_ordered_range+0xa4/0x100
Nov 23 07:46:09 argos kernel: ? __kthread_cancel_work+0x68/0x68
Nov 23 07:48:12 argos kernel: INFO: task btrfs-transacti:1234 blocked for more than 120 seconds.
Nov 23 07:48:12 argos kernel:      Not tainted 94.19.1-srb-asrock-00001-gdffa15601442 #135
Nov 23 07:48:12 argos kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 23 07:48:12 argos kernel: btrfs-transacti D    0  1234      2 0x80000000
Nov 23 07:48:12 argos kernel: ? btrfs_start_dirty_block_groups+0x111/0x390
Nov 23 07:48:12 argos kernel: ? btrfs_commit_transaction+0xd3/0x73b
Nov 23 07:50:15 argos kernel: ? btrfs_clean_one_deleted_snapshot+0xa8/0xb2
Nov 23 07:50:15 argos kernel: INFO: task btrfs-transacti:1234 blocked for more than 120 seconds.
Nov 23 07:50:15 argos kernel:      Not tainted 94.19.1-srb-asrock-00001-gdffa15601442 #135
Nov 23 07:52:18 argos kernel: ? finish_wait+0x60/0x60

Nov 25 09:53:44 argos kernel:      Not tainted 94.19.1-srb-asrock-00001-gdffa15601442 #135
Nov 25 09:53:44 argos kernel: btrfs           D    0  7623   7618 0x00000000
Nov 25 09:53:44 argos kernel: ? btrfs_wait_ordered_range+0xa4/0x100
Nov 25 09:53:44 argos kernel: ? unmap_mapping_pages+0x64/0x113
Nov 25 09:53:44 argos kernel: ? btrfs_setattr+0x20b/0x499

Nov 26 10:26:14 argos kernel: INFO: task btrfs:18234 blocked for more than 120 seconds.

Nov 27 10:22:54 argos kernel: ? __schedule+0x4db/0x524
Nov 27 10:22:54 argos kernel: ? schedule+0x60/0x71
Nov 27 10:22:54 argos kernel: ? btrfs_start_ordered_extent+0xd3/0x105
Nov 27 10:22:54 argos kernel: ? notify_change+0x268/0x347
Nov 27 10:22:54 argos kernel: ? do_truncate+0x82/0xb6
Nov 27 10:22:54 argos kernel: ? kmem_cache_alloc+0x9a/0x100
Nov 27 10:22:54 argos kernel: ? vfs_truncate+0xbc/0xda
Nov 27 10:22:54 argos kernel: ? do_sys_truncate+0x60/0xa9
Nov 27 10:22:54 argos kernel: ? do_syscall_64+0x4e/0x5b
Nov 27 10:22:54 argos kernel: ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov 27 10:24:57 argos kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 28 10:04:13 argos kernel: ? __schedule+0x4db/0x524
Nov 28 10:04:13 argos kernel: ? schedule+0x60/0x71
Nov 28 10:04:13 argos kernel: ? btrfs_start_ordered_extent+0xd3/0x105
Nov 28 10:04:13 argos kernel: ? finish_wait+0x60/0x60
Nov 28 10:06:16 argos kernel: ? btrfs_start_ordered_extent+0xd3/0x105
Nov 28 10:06:16 argos kernel: ? finish_wait+0x60/0x60
Nov 28 10:06:16 argos kernel: ? btrfs_setattr+0x20b/0x499
Nov 28 10:08:18 argos kernel: ? vfs_truncate+0xbc/0xda
Nov 29 10:24:26 argos kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 29 10:24:26 argos kernel: ? do_sys_truncate+0x60/0xa9
Nov 29 10:24:26 argos kernel: ? do_syscall_64+0x4e/0x5b
Nov 29 10:24:26 argos kernel: ? entry_SYSCALL_64_after_hwframe+0x44/0xa9
Nov 29 10:26:29 argos kernel: ? btrfs_wait_ordered_range+0xa4/0x100
Nov 29 10:26:29 argos kernel: ? unmap_mapping_pages+0x64/0x113
Nov 29 10:26:29 argos kernel: ? btrfs_setattr+0x20b/0x499
Nov 29 10:28:32 argos kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 29 10:28:32 argos kernel: btrfs           D    0 24965  24960 0x00000000
Nov 29 10:28:32 argos kernel: Call Trace:
Nov 29 13:08:31 argos kernel: Code: 1f 80 00 00 00 00 e9 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 48 81 ec f8 ff 00 00 8b 05 8f 2e 00 00 48 8d 35 40 0e 00 00 <48> 89 3c 24 48 8b 3d 81 2e 00 00 8d 90 00 00 01 00 31 c0 89 15 6f
Nov 30 10:13:56 argos kernel: ? btrfs_setattr+0x20b/0x499
Nov 30 10:13:56 argos kernel: ? vfs_truncate+0xbc/0xda
Dec  3 17:08:40 argos kernel: Code: 1f 80 00 00 00 00 e9 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 48 81 ec f8 ff 00 00 8b 05 8f 2e 00 00 48 8d 35 40 0e 00 00 <48> 89 3c 24 48 8b 3d 81 2e 00 00 8d 90 00 00 01 00 31 c0 89 15 6f

Dec  6 11:41:13 argos kernel: perf: interrupt took too long (2514 > 2500), lowering kernel.perf_event_max_sample_rate to 79500
Dec  6 22:42:18 argos kernel: ? btrfs_wait_ordered_range+0xa4/0x100
Dec  6 22:42:18 argos kernel: ? unmap_mapping_pages+0x64/0x113
Dec  6 22:42:18 argos kernel: ? btrfs_setattr+0x20b/0x499
Dec  6 22:42:18 argos kernel: ? notify_change+0x268/0x347
Dec  6 22:42:18 argos kernel: ? do_truncate+0x82/0xb6
Dec  6 22:42:18 argos kernel: ? kmem_cache_alloc+0x9a/0x100
Dec  6 22:42:18 argos kernel: ? vfs_truncate+0xbc/0xda
Dec  6 22:58:41 argos kernel:      Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
Dec  6 22:58:41 argos kernel: Call Trace:
Dec  6 22:58:41 argos kernel: ? btrfs_setattr+0x20b/0x499

Dec  7 00:26:26 argos kernel: Linux version 94.19.7-srb-asrock-00001-g22c8f45edcaf (root@devel2) (gcc version 8.2.0 (Debian 8.2.0-9)) #137 SMP Thu Dec 6 09:36:50 CET 2018
Dec  7 03:49:45 argos kernel: perf: interrupt took too long (3958 > 3937), lowering kernel.perf_event_max_sample_rate to 50500
Dec  7 11:35:20 argos kernel: ? finish_wait+0x60/0x60
Dec  7 11:39:26 argos kernel: ? notify_change+0x268/0x347
Dec  7 11:39:26 argos kernel: ? do_truncate+0x82/0xb6
Dec  7 11:39:26 argos kernel: ? kmem_cache_alloc+0x9a/0x100
Dec  7 11:39:26 argos kernel: ? vfs_truncate+0xbc/0xda
Dec  7 14:37:55 argos kernel: in libxul.so[7f3f410b2000+3dd6000]
Dec  7 14:37:55 argos kernel: Code: 15 7a 84 a3 04 48 89 10 c7 04 25 00 00 00 00 e0 09 00 00 e8 47 57 ff ff 90 48 8b 05 c7 75 ec 05 48 8d 0d c0 84 a3 04 48 89 08 <c7> 04 25 00 00 00 00 66 0a 00 00 e8 25 57 ff ff e8 2a f3 ff ff 48
Dec  7 14:49:20 argos kernel: Code: 15 7a 84 a3 04 48 89 10 c7 04 25 00 00 00 00 e0 09 00 00 e8 47 57 ff ff 90 48 8b 05 c7 75 ec 05 48 8d 0d c0 84 a3 04 48 89 08 <c7> 04 25 00 00 00 00 66 0a 00 00 e8 25 57 ff ff e8 2a f3 ff ff 48
Dec  8 12:03:45 argos kernel: ? unmap_mapping_pages+0x64/0x113
Dec  8 12:05:48 argos kernel: ? __schedule+0x4db/0x524
Dec  8 12:05:48 argos kernel: ? schedule+0x60/0x71
Dec  8 12:05:48 argos kernel: ? btrfs_start_ordered_extent+0xd3/0x105
Dec  8 12:05:48 argos kernel: ? finish_wait+0x60/0x60
Dec  8 12:07:51 argos kernel: btrfs           D    0 17853  17848 0x00000000
Dec  8 12:07:51 argos kernel: Call Trace:
Dec  8 12:07:51 argos kernel: ? vfs_truncate+0xbc/0xda

Dec  9 10:37:29 argos kernel:      Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
Dec  9 10:37:29 argos kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Dec  9 10:37:29 argos kernel: btrfs           D    0   409    404 0x00000000
Dec  9 10:37:29 argos kernel: Call Trace:
Dec  9 10:37:29 argos kernel: ? vfs_truncate+0xbc/0xda
Dec  9 10:39:32 argos kernel: btrfs           D    0   409    404 0x00000000
Dec  9 10:39:32 argos kernel: Call Trace:
Dec  9 10:39:32 argos kernel: ? btrfs_wait_ordered_range+0xa4/0x100
Dec  9 10:39:32 argos kernel: ? unmap_mapping_pages+0x64/0x113
Dec  9 10:39:32 argos kernel: ? btrfs_setattr+0x20b/0x499
Dec  9 10:39:32 argos kernel: ? notify_change+0x268/0x347
Dec  9 10:39:32 argos kernel: ? do_truncate+0x82/0xb6
Dec  9 10:41:34 argos kernel: ? __schedule+0x4db/0x524
Dec  9 10:41:34 argos kernel: ? schedule+0x60/0x71
Dec  9 10:41:34 argos kernel: ? btrfs_start_ordered_extent+0xd3/0x105
Dec  9 10:41:34 argos kernel: ? finish_wait+0x60/0x60
Dec  9 10:43:37 argos kernel: INFO: task btrfs:409 blocked for more than 120 seconds.
Dec  9 10:43:37 argos kernel:      Not tainted 94.19.7-srb-asrock-00001-g22c8f45edcaf #137
Dec  9 10:43:37 argos kernel: ? finish_wait+0x60/0x60
Dec  9 12:08:42 argos kernel: Code: 1f 80 00 00 00 00 e9 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 48 81 ec f8 ff 00 00 8b 05 8f 2e 00 00 48 8d 35 40 0e 00 00 <48> 89 3c 24 48 8b 3d 81 2e 00 00 8d 90 00 00 01 00 31 c0 89 15 6f
-- 
Stephen.
