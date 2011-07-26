From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: btrfs on MIPS with 16K page size
Date: Wed, 27 Jul 2011 01:37:56 +0600
Message-ID: <20110727013756.427c46fc@natsu>
References: <20110627010018.7133192e@natsu>
	<20110727010232.553f8480@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/N0_t2Rz9C=l.a2UOcDG=KKn"; protocol="application/pgp-signature"
Cc: linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110727010232.553f8480@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

--Sig_/N0_t2Rz9C=l.a2UOcDG=KKn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 27 Jul 2011 01:02:32 +0600
Roman Mamedov <rm@romanrm.ru> wrote:

> > - Can this filesystem (nodesize 16384 leafsize 16384 sectorsize 16384) =
be mounted on an
> >   x86 system with page size of 4K at all, if I move the disk there (did=
n't try that yet)?

Just tried on an amd64 system, and 1) it mounts 2) an attempt to write caus=
es a live(?)lock with flush-btrfs-11 taking 100% CPU.
(you can disregard khubd, I had an USB device badly misbehave earlier, and =
/dev/loop7 is not being accessed via USB anyways).

[974527.157345] device fsid 9f986023-3b78-4039-9b7a-f9be4777208a devid 1 tr=
ansid 16 /dev/loop7
[974889.435704] SysRq : Show Blocked State
[974889.435733]   task                        PC stack   pid father
[974889.435740] khubd           D ffff88007fd747d8     0   191      2 0x000=
00000
[974889.435744]  ffff88007f463b60 0000000000000046 ffff880016e22518 0000000=
000000001
[974889.435747]  ffff88007fd74410 ffff88007f463fd8 ffff88007f463fd8 ffff880=
07f463fd8
[974889.435750]  ffff880076432d60 ffff88007fd74410 ffff88007fd74410 ffff880=
07f742080
[974889.435754] Call Trace:
[974889.435762]  [<ffffffff813f9172>] __mutex_lock_slowpath+0xc2/0x130
[974889.435765]  [<ffffffff813f8df5>] mutex_lock+0x25/0x40
[974889.435797]  [<ffffffffa0169c12>] usb_set_interface+0x62/0x250 [usbcore]
[974889.435802]  [<ffffffff81071f06>] ? __cancel_work_timer+0x86/0x140
[974889.435812]  [<ffffffffa016b8eb>] usb_unbind_interface+0xfb/0x170 [usbc=
ore]
[974889.435818]  [<ffffffff812cdc87>] __device_release_driver+0x77/0xd0
[974889.435821]  [<ffffffff812cdd07>] device_release_driver+0x27/0x40
[974889.435824]  [<ffffffff812cd813>] bus_remove_device+0x73/0xa0
[974889.435826]  [<ffffffff812cad75>] device_del+0x125/0x1b0
[974889.435835]  [<ffffffffa016973a>] usb_disable_device+0x7a/0x190 [usbcor=
e]
[974889.435843]  [<ffffffffa0161f3f>] usb_disconnect+0x9f/0x140 [usbcore]
[974889.435852]  [<ffffffffa0163d44>] hub_thread+0x954/0x1300 [usbcore]
[974889.435856]  [<ffffffff81077460>] ? add_wait_queue+0x60/0x60
[974889.435864]  [<ffffffffa01633f0>] ? usb_remote_wakeup+0x40/0x40 [usbcor=
e]
[974889.435867]  [<ffffffff81076bc7>] kthread+0x87/0x90
[974889.435869]  [<ffffffff81402be4>] kernel_thread_helper+0x4/0x10
[974889.435872]  [<ffffffff81076b40>] ? kthread_worker_fn+0x190/0x190
[974889.435874]  [<ffffffff81402be0>] ? gs_change+0x13/0x13
[974889.435931] btrfs-transacti D ffff880000419a78     0 28401      2 0x000=
00000
[974889.435935]  ffff8800029c5d20 0000000000000046 0000000000000004 ffff880=
05ab28600
[974889.435938]  ffff8800004196b0 ffff8800029c5fd8 ffff8800029c5fd8 ffff880=
0029c5fd8
[974889.435941]  ffff880000194410 ffff8800004196b0 ffff8800029c5d10 fffffff=
fa0199412
[974889.435944] Call Trace:
[974889.435964]  [<ffffffffa0199412>] ? btrfs_release_path+0x22/0x80 [btrfs]
[974889.435967]  [<ffffffff813f89ad>] schedule_timeout+0x1ed/0x310
[974889.435970]  [<ffffffff813f8de8>] ? mutex_lock+0x18/0x40
[974889.435983]  [<ffffffffa01bab1c>] btrfs_commit_transaction+0x22c/0x840 =
[btrfs]
[974889.435986]  [<ffffffff81077460>] ? add_wait_queue+0x60/0x60
[974889.435997]  [<ffffffffa01b3d25>] transaction_kthread+0x245/0x260 [btrf=
s]
[974889.436005]  [<ffffffffa01b3ae0>] ? btrfs_congested_fn+0xb0/0xb0 [btrfs]
[974889.436005]  [<ffffffff81076bc7>] kthread+0x87/0x90
[974889.436005]  [<ffffffff81402be4>] kernel_thread_helper+0x4/0x10
[974889.436005]  [<ffffffff81076b40>] ? kthread_worker_fn+0x190/0x190
[974889.436005]  [<ffffffff81402be0>] ? gs_change+0x13/0x13
[974889.436005] cfv             D ffff8800077a5e88     0 28437  28436 0x000=
00004
[974889.436005]  ffff880005335718 0000000000000086 0000000000000000 0000000=
000000000
[974889.436005]  ffff8800077a5ac0 ffff880005335fd8 ffff880005335fd8 ffff880=
005335fd8
[974889.436005]  ffff8800bc2b96b0 ffff8800077a5ac0 ffff8800053356d8 0000000=
1053356d8
[974889.436005] Call Trace:
[974889.436005]  [<ffffffff810e23d0>] ? __lock_page+0x70/0x70
[974889.436005]  [<ffffffff813f824a>] io_schedule+0x8a/0xd0
[974889.436005]  [<ffffffff810e23d9>] sleep_on_page+0x9/0x10
[974889.436005]  [<ffffffff813f8cc7>] __wait_on_bit+0x57/0x80
[974889.436005]  [<ffffffff810e2520>] wait_on_page_bit+0x70/0x80
[974889.436005]  [<ffffffff810774a0>] ? autoremove_wake_function+0x40/0x40
[974889.436005]  [<ffffffffa01dc75d>] extent_write_cache_pages.isra.22.cons=
tprop.31+0x22d/0x310 [btrfs]
[974889.436005]  [<ffffffffa01dcabf>] extent_writepages+0x3f/0x50 [btrfs]
[974889.436005]  [<ffffffffa01be180>] ? acls_after_inode_item+0xf0/0xf0 [bt=
rfs]
[974889.436005]  [<ffffffffa01bd433>] btrfs_writepages+0x23/0x30 [btrfs]
[974889.436005]  [<ffffffff810ed21c>] do_writepages+0x1c/0x30
[974889.436005]  [<ffffffff810e3a13>] __filemap_fdatawrite_range+0x53/0x60
[974889.436005]  [<ffffffff810e48fe>] filemap_fdatawrite_range+0xe/0x10
[974889.436005]  [<ffffffffa01d7dd4>] btrfs_start_ordered_extent+0xe4/0x140=
 [btrfs]
[974889.436005]  [<ffffffffa01db823>] __extent_read_full_page+0xb3/0x6d0 [b=
trfs]
[974889.436005]  [<ffffffffa01be180>] ? acls_after_inode_item+0xf0/0xf0 [bt=
rfs]
[974889.436005]  [<ffffffff810e2ef1>] ? add_to_page_cache_locked+0xa1/0x100
[974889.436005]  [<ffffffffa01dcb8a>] extent_readpages+0xba/0x100 [btrfs]
[974889.436005]  [<ffffffffa01be180>] ? acls_after_inode_item+0xf0/0xf0 [bt=
rfs]
[974889.436005]  [<ffffffffa01bd25a>] btrfs_readpages+0x1a/0x20 [btrfs]
[974889.436005]  [<ffffffff810ed524>] __do_page_cache_readahead+0x184/0x220
[974889.436005]  [<ffffffff810ed8fc>] ra_submit+0x1c/0x20
[974889.436005]  [<ffffffff810eda0d>] ondemand_readahead+0x10d/0x230
[974889.436005]  [<ffffffff810edbfc>] page_cache_sync_readahead+0x2c/0x40
[974889.436005]  [<ffffffff810e4520>] generic_file_aio_read+0x420/0x760
[974889.436005]  [<ffffffff8113418a>] do_sync_read+0xca/0x110
[974889.436005]  [<ffffffff811b87e3>] ? security_file_permission+0x93/0xb0
[974889.436005]  [<ffffffff8113449c>] ? rw_verify_area+0x5c/0xf0
[974889.436005]  [<ffffffff8113494b>] vfs_read+0xab/0x170
[974889.436005]  [<ffffffff81134a55>] sys_read+0x45/0x90
[974889.436005]  [<ffffffff81401ad2>] system_call_fastpath+0x16/0x1b
[974889.436005] Sched Debug Version: v0.10, 3.0.0-rc6-rm1 #1
[974889.436005] ktime                                   : 974889436.233459
[974889.436005] sched_clk                               : 973418187.555893
[974889.436005] cpu_clk                                 : 974889436.005820
[974889.436005] jiffies                                 : 4538614655
[974889.436005] sched_clock_stable                      : 0
[974889.436005]=20
[974889.436005] sysctl_sched
[974889.436005]   .sysctl_sched_latency                    : 12.000000
[974889.436005]   .sysctl_sched_min_granularity            : 1.500000
[974889.436005]   .sysctl_sched_wakeup_granularity         : 2.000000
[974889.436005]   .sysctl_sched_child_runs_first           : 0
[974889.436005]   .sysctl_sched_features                   : 15471
[974889.436005]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[974889.436005]=20
[974889.436005] cpu#0, 2608.460 MHz
[974889.436005]   .nr_running                    : 1
[974889.436005]   .load                          : 1048576
[974889.436005]   .nr_switches                   : 1589801141
[974889.436005]   .nr_load_updates               : 45058534
[974889.436005]   .nr_uninterruptible            : -108843
[974889.436005]   .next_balance                  : 4538.614661
[974889.436005]   .curr->pid                     : 28431
[974889.436005]   .clock                         : 974889436.003849
[974889.436005]   .cpu_load[0]                   : 1048576
[974889.436005]   .cpu_load[1]                   : 1080832
[974889.436005]   .cpu_load[2]                   : 1253125
[974889.436005]   .cpu_load[3]                   : 1326416
[974889.436005]   .cpu_load[4]                   : 1145310
[974889.436005]   .yld_count                     : 2729656
[974889.436005]   .sched_switch                  : 0
[974889.436005]   .sched_count                   : 1592896823
[974889.436005]   .sched_goidle                  : 622852818
[974889.436005]   .avg_idle                      : 968131
[974889.436005]   .ttwu_count                    : 913650959
[974889.436005]   .ttwu_local                    : 888861847
[974889.436005]=20
[974889.436005] cfs_rq[0]:/
[974889.436005]   .exec_clock                    : 76227286.081120
[974889.436005]   .MIN_vruntime                  : 0.000001
[974889.436005]   .min_vruntime                  : 47664648.982054
[974889.436005]   .max_vruntime                  : 0.000001
[974889.436005]   .spread                        : 0.000000
[974889.436005]   .spread0                       : 0.000000
[974889.436005]   .nr_spread_over                : 392899
[974889.436005]   .nr_running                    : 1
[974889.436005]   .load                          : 1048576
[974889.436005]   .load_avg                      : 0.000000
[974889.436005]   .load_period                   : 0.000000
[974889.436005]   .load_contrib                  : 0
[974889.436005]   .load_tg                       : 0
[974889.436005]=20
[974889.436005] rt_rq[0]:
[974889.436005]   .rt_nr_running                 : 0
[974889.436005]   .rt_throttled                  : 0
[974889.436005]   .rt_time                       : 0.000000
[974889.436005]   .rt_runtime                    : 950.000000
[974889.436005]=20
[974889.436005] runnable tasks:
[974889.436005]             task   PID         tree-key  switches  prio    =
 exec-runtime         sum-exec        sum-sleep
[974889.436005] -----------------------------------------------------------=
-----------------------------------------------
[974889.436005] R flush-btrfs-11 28431  47664648.982054    104436   120  47=
664648.982054    257586.768019         0.008630 /
[974889.436005]=20
[974889.436005] cpu#1, 2608.460 MHz
[974889.436005]   .nr_running                    : 4
[974889.436005]   .load                          : 6341632
[974889.436005]   .nr_switches                   : 991159397
[974889.436005]   .nr_load_updates               : 44063436
[974889.436005]   .nr_uninterruptible            : 108846
[974889.436005]   .next_balance                  : 4538.614667
[974889.436005]   .curr->pid                     : 28557
[974889.436005]   .clock                         : 974889435.538713
[974889.436005]   .cpu_load[0]                   : 1048576
[974889.436005]   .cpu_load[1]                   : 983040
[974889.436005]   .cpu_load[2]                   : 718110
[974889.436005]   .cpu_load[3]                   : 474603
[974889.436005]   .cpu_load[4]                   : 446904
[974889.436005]   .yld_count                     : 2299842
[974889.436005]   .sched_switch                  : 0
[974889.436005]   .sched_count                   : 995150206
[974889.436005]   .sched_goidle                  : 355047791
[974889.436005]   .avg_idle                      : 1000000
[974889.436005]   .ttwu_count                    : 555934440
[974889.436005]   .ttwu_local                    : 535910266
[974889.436005]=20
[974889.436005] cfs_rq[1]:/
[974889.436005]   .exec_clock                    : 76923490.644171
[974889.436005]   .MIN_vruntime                  : 55191345.843936
[974889.436005]   .min_vruntime                  : 55191351.836721
[974889.436005]   .max_vruntime                  : 55191351.836721
[974889.436005]   .spread                        : 5.992785
[974889.436005]   .spread0                       : 7526702.854667
[974889.436005]   .nr_spread_over                : 374072
[974889.436005]   .nr_running                    : 4
[974889.436005]   .load                          : 6341632
[974889.436005]   .load_avg                      : 0.000000
[974889.436005]   .load_period                   : 0.000000
[974889.436005]   .load_contrib                  : 0
[974889.436005]   .load_tg                       : 0
[974889.436005]=20
[974889.436005] rt_rq[1]:
[974889.436005]   .rt_nr_running                 : 0
[974889.436005]   .rt_throttled                  : 0
[974889.436005]   .rt_time                       : 0.000000
[974889.436005]   .rt_runtime                    : 950.000000
[974889.436005]=20
[974889.436005] runnable tasks:
[974889.436005]             task   PID         tree-key  switches  prio    =
 exec-runtime         sum-exec        sum-sleep
[974889.436005] -----------------------------------------------------------=
-----------------------------------------------
[974889.436005]            Xvnc4  6356  55191345.882878 106302129   115  55=
191345.882878  13152389.456063 186285384.343167 /
[974889.436005]             java  7020  55191351.836721  20429489   120  55=
191351.836721   3270683.227930 970838137.389486 /
[974889.436005]      kworker/1:1 28330  55191345.843936      3985   120  55=
191345.843936       220.871633    404303.591154 /
[974889.436005] R           bash 28557  55191345.850553        25   120  55=
191345.850553         6.135878      6805.087163 /
[974889.436005]=20

--=20
With respect,
Roman

--Sig_/N0_t2Rz9C=l.a2UOcDG=KKn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4vF5QACgkQTLKSvz+PZwi+mgCfWkQqYb6lMiNXIuSa6L1a1DZo
YdMAoIaAi3oLlvFiDgIfCp6UvODXL0dn
=gZJy
-----END PGP SIGNATURE-----

--Sig_/N0_t2Rz9C=l.a2UOcDG=KKn--
