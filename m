Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35329 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756266AbdEROTX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 May 2017 10:19:23 -0400
Received: by mail-io0-f173.google.com with SMTP id f102so29157942ioi.2
        for <linux-btrfs@vger.kernel.org>; Thu, 18 May 2017 07:19:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r1ibfLpNgmtti6pTDUOmA=+kOCemg7=ykneKDaJMpx59Q@mail.gmail.com>
References: <20170518134135.sk6dha6kayv6tar3@hopa.kiewit.dartmouth.edu> <CAEtw4r1ibfLpNgmtti6pTDUOmA=+kOCemg7=ykneKDaJMpx59Q@mail.gmail.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Thu, 18 May 2017 16:19:21 +0200
Message-ID: <CAEtw4r1YSqvGCg_7R3yJY+EMZBO2FNjLDuxppLDQtb0qMKvwTQ@mail.gmail.com>
Subject: Fwd: confusing "no space left" -- how to troubleshoot and "be prepared"?
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Yaroslav Halchenko <yoh@onerussian.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-05-18 15:41 GMT+02:00 Yaroslav Halchenko <yoh@onerussian.com>:
>
> our python-based program crashed with
>
>   File "/home/yoh/proj/datalad/datalad/venv-tests/local/lib/python2.7/site-packages/gitdb/stream.py", line 695, in write
>     os.write(self._fd, data)
> OSError: [Errno 28] No space left on device
>
> but as far as I could see there still should be both data and meta data
> space left:
>
> $> sudo btrfs fi df $PWD
> Data, RAID0: total=33.55TiB, used=30.56TiB
> System, RAID1: total=32.00MiB, used=1.81MiB
> Metadata, RAID1: total=83.00GiB, used=64.81GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
>
> $> sudo btrfs fi usage $PWD
> Overall:
>     Device size:                  43.66TiB
>     Device allocated:             33.71TiB
>     Device unallocated:            9.95TiB
>     Device missing:                  0.00B
>     Used:                         30.69TiB
>     Free (estimated):             12.94TiB      (min: 7.96TiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
>
> Data,RAID0: Size:33.55TiB, Used:30.56TiB
>    /dev/md10       8.39TiB
>    /dev/md11       8.39TiB
>    /dev/md12       8.39TiB
>    /dev/md13       8.39TiB
>
> Metadata,RAID1: Size:83.00GiB, Used:64.81GiB
>    /dev/md10      41.00GiB
>    /dev/md11      42.00GiB
>    /dev/md12      41.00GiB
>    /dev/md13      42.00GiB
>
> System,RAID1: Size:32.00MiB, Used:1.81MiB
>    /dev/md10      32.00MiB
>    /dev/md12      32.00MiB
>
> Unallocated:
>    /dev/md10       2.49TiB
>    /dev/md11       2.49TiB
>    /dev/md12       2.49TiB
>    /dev/md13       2.49TiB
>
> (so it is RAID0 for data sitting on top of software RAID5s)
>
> I am running Debian jessie with custom built kernel
> Linux smaug 4.9.0-rc2+ #3 SMP Fri Oct 28 20:59:01 EDT 2016 x86_64 GNU/Linux
> btrfs-tools were 4.6.1-1~bpo8+1 , FWIW upgraded to 4.7.3-1~bpo8+1
> I do have a fair number of subvolumes (794! snapshots + used by docker)
>
> so what could be the catch -- currently can't even touch a new file (can
> touch existing ;-/ )?  meanwhile removing some snapshots, syncing and
> rebooting in attempt to mitigate not usable server
>
>
> looking at the logs, I see that there were some traces logged a day ago:
>
> ...
> May 17 01:47:41 smaug kernel: INFO: task kworker/u33:15:318164 blocked for more than 120 seconds.
> May 17 01:47:41 smaug kernel:       Tainted: G          I  L  4.9.0-rc2+ #3
> May 17 01:47:41 smaug kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> May 17 01:47:41 smaug kernel: kworker/u33:15  D ffffffff815e6fd3     0 318164      2 0x00000000
> May 17 01:47:41 smaug kernel: Workqueue: writeback wb_workfn (flush-btrfs-1)
> May 17 01:47:41 smaug kernel:  ffff88102dba3400 0000000000000000 ffff8810390741c0 ffff88103fc98740
> May 17 01:47:41 smaug kernel:  ffff881036640e80 ffffc9002af334e8 ffffffff815e6fd3 0000000000000000
> May 17 01:47:41 smaug kernel:  ffff881038800668 ffffc9002af33540 ffff881036640e80 ffff881038800668
> May 17 01:47:41 smaug kernel: Call Trace:
> May 17 01:47:41 smaug kernel:  [<ffffffff815e6fd3>] ? __schedule+0x1a3/0x670
> May 17 01:47:41 smaug kernel:  [<ffffffff815e74d2>] ? schedule+0x32/0x80
> May 17 01:47:41 smaug kernel:  [<ffffffffa030d180>] ? raid5_get_active_stripe+0x4f0/0x670 [raid456]
> May 17 01:47:41 smaug kernel:  [<ffffffff810bfc30>] ? wake_up_atomic_t+0x30/0x30
> May 17 01:47:41 smaug kernel:  [<ffffffffa030d48d>] ? raid5_make_request+0x18d/0xc40 [raid456]
> May 17 01:47:41 smaug kernel:  [<ffffffff810bfc30>] ? wake_up_atomic_t+0x30/0x30
> May 17 01:47:41 smaug kernel:  [<ffffffffa00f2f85>] ? md_make_request+0xf5/0x230 [md_mod]
> May 17 01:47:41 smaug kernel:  [<ffffffff812f2566>] ? generic_make_request+0x106/0x1f0
> May 17 01:47:41 smaug kernel:  [<ffffffff812f26c6>] ? submit_bio+0x76/0x150
> May 17 01:47:41 smaug kernel:  [<ffffffffa03a535e>] ? btrfs_map_bio+0x10e/0x370 [btrfs]
> May 17 01:47:41 smaug kernel:  [<ffffffffa0377f18>] ? btrfs_submit_bio_hook+0xb8/0x190 [btrfs]
> May 17 01:47:41 smaug kernel:  [<ffffffffa0393746>] ? submit_one_bio+0x66/0x90 [btrfs]
> May 17 01:47:41 smaug kernel:  [<ffffffffa0397798>] ? submit_extent_page+0x138/0x310 [btrfs]
> May 17 01:47:41 smaug kernel:  [<ffffffffa0397500>] ? end_extent_writepage+0x80/0x80 [btrfs]
> May 17 01:47:41 smaug kernel:  [<ffffffffa0397d90>] ? __extent_writepage_io+0x420/0x4e0 [btrfs]
> May 17 01:47:41 smaug kernel:  [<ffffffffa0397500>] ? end_extent_writepage+0x80/0x80 [btrfs]
> May 17 01:47:41 smaug kernel:  [<ffffffffa0398059>] ? __extent_writepage+0x209/0x340 [btrfs]
> May 17 01:47:41 smaug kernel:  [<ffffffffa0398412>] ? extent_write_cache_pages.isra.40.constprop.51+0x282/0x380 [btrfs]
> May 17 01:47:41 smaug kernel:  [<ffffffffa039a31d>] ? extent_writepages+0x5d/0x90 [btrfs]
> May 17 01:47:41 smaug kernel:  [<ffffffffa037a420>] ? btrfs_set_bit_hook+0x210/0x210 [btrfs]
> May 17 01:47:41 smaug kernel:  [<ffffffff81230d6d>] ? __writeback_single_inode+0x3d/0x330
> May 17 01:47:41 smaug kernel:  [<ffffffff8123152d>] ? writeback_sb_inodes+0x23d/0x470
> May 17 01:47:41 smaug kernel:  [<ffffffff812317e7>] ? __writeback_inodes_wb+0x87/0xb0
> May 17 01:47:41 smaug kernel:  [<ffffffff81231b62>] ? wb_writeback+0x282/0x310
> May 17 01:47:41 smaug kernel:  [<ffffffff812324d8>] ? wb_workfn+0x2b8/0x3e0
> May 17 01:47:41 smaug kernel:  [<ffffffff810968bb>] ? process_one_work+0x14b/0x410
> May 17 01:47:41 smaug kernel:  [<ffffffff81097375>] ? worker_thread+0x65/0x4a0
> May 17 01:47:41 smaug kernel:  [<ffffffff81097310>] ? rescuer_thread+0x340/0x340
> May 17 01:47:41 smaug kernel:  [<ffffffff8109c670>] ? kthread+0xe0/0x100
> May 17 01:47:41 smaug kernel:  [<ffffffff8102b76b>] ? __switch_to+0x2bb/0x700
> May 17 01:47:41 smaug kernel:  [<ffffffff8109c590>] ? kthread_park+0x60/0x60
> May 17 01:47:41 smaug kernel:  [<ffffffff815ec0b5>] ? ret_from_fork+0x25/0x30
> May 17 01:47:59 smaug kernel: NMI watchdog: BUG: soft lockup - CPU#5 stuck for 23s! [kswapd1:126]
> ...
>
> May 17 02:03:08 smaug kernel: NMI watchdog: BUG: soft lockup - CPU#13 stuck for 23s! [kswapd1:126]
> May 17 02:03:08 smaug kernel: Modules linked in: cpufreq_userspace cpufreq_conservative cpufreq_powersave xt_pkttype nf_log_ipv4 nf_log_common xt_tcpudp ip6table_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat xt_TCPMSS xt_LOG ipt_REJECT nf_reject_ipv4 iptable_mangle xt_multiport xt_state xt_limit xt_conntrack nf_conntrack_ftp nf_conntrack ip6table_filter ip6_tables iptable_filter ip_tables x_tables nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc binfmt_misc ipmi_watchdog iTCO_wdt iTCO_vendor_support intel_rapl sb_edac edac_core x86_pkg_temp_thermal coretemp kvm_intel kvm ast irqbypass ttm crct10dif_pclmul drm_kms_helper crc32_pclmul ghash_clmulni_intel snd_pcm drm snd_timer snd i2c_algo_bit soundcore aesni_intel aes_x86_64 lrw mei_me gf128mul joydev pcspkr evdev glue_helperss scsi_transport_sas ahci libahci xhci_pci ehci_pci libata xhci_hcd ehci_hcd usbcore ixgbe scsi_mod dca ptp pps_core mdio fjes name: Supermicro X10DRi/X10DRI-T, BIOS 1.0b 09/17/2014
> May 17 02:03:08 smaug kernel: task: ffff8810365c8f40 task.stack: ffffc9000d26c000
> May 17 02:03:08 smaug kernel: RIP: 0010:[<ffffffff8119731c>]  [<ffffffff8119731c>] shrink_active_list+0x14c/0x360
> May 17 02:03:08 smaug kernel: RSP: 0018:ffffc9000d26fbc0  EFLAGS: 00000206
> May 17 02:03:08 smaug kernel: RAX: 0000000000000064 RBX: ffffc9000d26fe01 RCX: 000000000001bc87
> May 17 02:03:08 smaug kernel: RDX: 0000000000463781 RSI: 0000000000000007 RDI: ffff88207fffc800
> May 17 02:03:08 smaug kernel: RBP: ffffc9000d26fc10 R08: 000000000001bc80 R09: 0000000000000003
> May 17 02:03:08 smaug kernel: R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
> May 17 02:03:08 smaug kernel: R13: ffffc9000d26fe58 R14: ffffc9000d26fc30 R15: ffff88203936d200
> May 17 02:03:08 smaug kernel: FS:  0000000000000000(0000) GS:ffff88207fd40000(0000) knlGS:0000000000000000
> May 17 02:03:08 smaug kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> May 17 02:03:08 smaug kernel: CR2: 00002b64de150000 CR3: 0000000001a07000 CR4: 00000000001406e0
> May 17 02:03:08 smaug kernel: Stack:
> May 17 02:03:08 smaug kernel:  ffff881600000000 ffff882000000003 ffff88207fff9000 ffff88203936d200
> May 17 02:03:08 smaug kernel:  ffff88207fffc800 0000000000000000 0000000600000003 ffff88203936d208
> May 17 02:03:08 smaug kernel:  0000000000463781 0000000000000000 ffffc9000d26fc10 ffffc9000d26fc10
> May 17 02:03:08 smaug kernel: Call Trace:
> May 17 02:03:08 smaug kernel:  [<ffffffff81197b3f>] ? shrink_node_memcg+0x60f/0x780
> May 17 02:03:08 smaug kernel:  [<ffffffff81197d92>] ? shrink_node+0xe2/0x320
> May 17 02:03:08 smaug kernel:  [<ffffffff81198dd8>] ? kswapd+0x318/0x700
> May 17 02:03:08 smaug kernel:  [<ffffffff81198ac0>] ? mem_cgroup_shrink_node+0x180/0x180
> May 17 02:03:08 smaug kernel:  [<ffffffff8109c670>] ? kthread+0xe0/0x100
> May 17 02:03:08 smaug kernel:  [<ffffffff8102b76b>] ? __switch_to+0x2bb/0x700
> May 17 02:03:08 smaug kernel:  [<ffffffff8109c590>] ? kthread_park+0x60/0x60
> May 17 02:03:08 smaug kernel:  [<ffffffff815ec0b5>] ? ret_from_fork+0x25/0x30
> May 17 02:03:08 smaug kernel: Code: 38 4c 01 66 60 49 83 7d 18 00 0f 84 0d 02 00 00 65 48 01 15 4f d3 e7 7e 48 8b 7c 24 20 c6 07 00 0f 1f 40 00 fb 66 0f 1f 44 00 00 <45> 31 e4 48 8b 44 24 50 48 39 c5 0f 84 a3 00 00 00 e8 9e 03 45
>
> not sure if anyhow related but somewhat strange is that swap is not used a tiny bit:
>
> $> free
>              total       used       free     shared    buffers     cached
> Mem:     131934232  124357760    7576472       3816     999100  112204512
> -/+ buffers/cache:   11154148  120780084
> Swap:    140623856          0  140623856
>
> $> cat /proc/swaps
> Filename                                Type            Size    Used    Priority
> /dev/sdp6                               partition       39062524        0       -1
> /dev/sdp5                               partition       31249404        0       -2
> /dev/sdo6                               partition       39062524        0       -4
> /dev/sdo5                               partition       31249404        0       -3
>
>
>
> P.S. Please CC me in replies
> --
> Yaroslav O. Halchenko
> Center for Open Neuroscience     http://centerforopenneuroscience.org
> Dartmouth College, 419 Moore Hall, Hinman Box 6207, Hanover, NH 03755
> Phone: +1 (603) 646-9834                       Fax: +1 (603) 646-1419
> WWW:   http://www.linkedin.com/in/yarik
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

I'm not sure if this would be helpfull but can you post the output
from this script?

cd /tmp
wget https://raw.githubusercontent.com/kdave/btrfs-progs/master/btrfs-debugfs
chmod +x btrfs-debugfs
stats=$(sudo ./btrfs-debugfs -b /)

echo "00-49: " $(echo "$stats" | grep "usage 0.[0-4]" -c)
echo "50-79: " $(echo "$stats" | grep "usage 0.[5-7]" -c)
echo "80-89: " $(echo "$stats" | grep "usage 0.8" -c)
echo "90-99: " $(echo "$stats" | grep "usage 0.9" -c)
echo "100:   " $(echo "$stats" | grep "usage 1." -c)

The btrfs-debugfs script is from the btrfs progs source and report the
usage of each block group. The following script groups the result.

This script should take less than a few minutes to complete.
