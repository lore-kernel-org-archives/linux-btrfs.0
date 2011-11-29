From: Karl Mardoff Kittilsen <karl@kittilsen.org>
Subject: kernel BUG at /build/buildd/linux-3.2.0/fs/btrfs/extent-tree.c:4816!
Date: Tue, 29 Nov 2011 02:39:26 +0100
Message-ID: <4ED437CE.3060909@kittilsen.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Sending a mail on this issue, as advised on IRC.

My /home file system fails to mount and the kernel seem to freeze and I 
need to do the Alt+SysRq RSNEIUB routine to boot it safely.
The corruption happened on a 3.2-rc<something> kernel and Ubuntu 11.10, 
but I am now running on Ubuntu 12.04 with the 3.2.0-2-generic kernel to 
see if that helped, it did not.
btrfsck from the latest btrfs-tools returns:

karl@karl-precise:~/git/btrfs-progs$ sudo ./btrfsck /dev/md0
ref mismatch on [2176962560 8192] extent item 480, found 1
Incorrect local backref count on 2176970752 root 5 owner 2101705 offset 
368640 found 1 wanted 3925868545
backpointer mismatch on [2176970752 4096]
found 1322579566593 bytes used err is 1
total csum bytes: 1288573748
total tree bytes: 3057922048
total fs tree bytes: 862068736
btree space waste bytes: 704584583
file data blocks allocated: 18991122972672
  referenced 1361205268480
Btrfs Btrfs v0.19-dirty

The file system is on a md raid1 device, and the only thing that I have 
done recently that might be related is that I made a script
to run through all my files and defrag them as well as compress them. 
That completed without any errors and I gained about 10% of space :)
This was about 5 days ago, after that I used it like normal without any 
problems.
Mount options are "defaults,compression=zlib"

This is the trace from dmesg when I try to mount it:

Nov 29 01:17:30 karl-precise kernel: [  100.963449] ------------[ cut 
here ]------------
Nov 29 01:17:30 karl-precise kernel: [  100.963478] kernel BUG at 
/build/buildd/linux-3.2.0/fs/btrfs/extent-tree.c:4816!
Nov 29 01:17:30 karl-precise kernel: [  100.963516] invalid opcode: 0000 
[#1] SMP
Nov 29 01:17:30 karl-precise kernel: [  100.963534] CPU 3
Nov 29 01:17:30 karl-precise kernel: [  100.963543] Modules linked in: 
nls_iso8859_1 nls_cp437 vfat fat rfcomm bnep bluetooth parport_pc ppdev 
binfmt_misc snd_hda_codec_hdmi arc4 rt2500usb rt2x00usb rt2x00lib 
mac80211 snd_hda_codec_realtek cfg80211 snd_hda_intel snd_hda_codec 
snd_hwdep snd_pcm snd_seq_midi radeon snd_rawmidi snd_seq_midi_event 
snd_seq psmouse snd_timer snd_seq_device snd ttm sp5100_tco 
drm_kms_helper drm soundcore snd_page_alloc i2c_algo_bit i2c_piix4 
edac_core wmi asus_atk0110 k10temp serio_raw edac_mce_amd lp parport 
raid10 raid456 async_pq async_xor xor async_memcpy async_raid6_recov 
usb_storage uas usbhid hid raid6_pq async_tx raid0 multipath raid1 
linear pata_atiixp btrfs zlib_deflate firewire_ohci firewire_core 
crc_itu_t r8169 libcrc32c
Nov 29 01:17:30 karl-precise kernel: [  100.963855]
Nov 29 01:17:30 karl-precise kernel: [  100.963862] Pid: 2184, comm: 
mount Not tainted 3.2.0-2-generic #4-Ubuntu System manufacturer System 
Product Name/M4A79T Deluxe
Nov 29 01:17:30 karl-precise kernel: [  100.963908] RIP: 
0010:[<ffffffffa0060ef7>]  [<ffffffffa0060ef7>] 
__btrfs_free_extent+0x617/0x650 [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.963958] RSP: 
0018:ffff880404ec9778  EFLAGS: 00010207
Nov 29 01:17:30 karl-precise kernel: [  100.963979] RAX: 
00000000ea000001 RBX: ffff8803e23ce000 RCX: 0000000000000000
Nov 29 01:17:30 karl-precise kernel: [  100.964006] RDX: 
ffff880000000000 RSI: 00000000000007ad RDI: ffff8803e23d0280
Nov 29 01:17:30 karl-precise kernel: [  100.964046] RBP: 
ffff880404ec9838 R08: 00000000000007b1 R09: 0000000000000000
Nov 29 01:17:30 karl-precise kernel: [  100.964078] R10: 
000000000000000d R11: ffff8803dac09840 R12: 000000000000002c
Nov 29 01:17:30 karl-precise kernel: [  100.964109] R13: 
0000000081c1f000 R14: 0000000000001000 R15: 0000000000000000
Nov 29 01:17:30 karl-precise kernel: [  100.964141] FS: 
00007f2290850820(0000) GS:ffff88042fcc0000(0000) knlGS:0000000000000000
Nov 29 01:17:30 karl-precise kernel: [  100.964177] CS:  0010 DS: 0000 
ES: 0000 CR0: 000000008005003b
Nov 29 01:17:30 karl-precise kernel: [  100.964203] CR2: 
00007f641727a000 CR3: 00000003ea2cf000 CR4: 00000000000006e0
Nov 29 01:17:30 karl-precise kernel: [  100.964235] DR0: 
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 29 01:17:30 karl-precise kernel: [  100.964266] DR3: 
0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 29 01:17:30 karl-precise kernel: [  100.964298] Process mount (pid: 
2184, threadinfo ffff880404ec8000, task ffff8803ea29c530)
Nov 29 01:17:30 karl-precise kernel: [  100.964334] Stack:
Nov 29 01:17:30 karl-precise kernel: [  100.964344]  0000000000000000 
0000000000000005 00000000002011c9 000000000005a000
Nov 29 01:17:30 karl-precise kernel: [  100.964386]  ffff880400000035 
ffff880414f52000 0000000100000001 ffff8803e7a0e800
Nov 29 01:17:30 karl-precise kernel: [  100.964417]  ffff8803e7a0fc00 
ffff8803e23cf000 000000000000077c ffff8803e23d0280
Nov 29 01:17:30 karl-precise kernel: [  100.964449] Call Trace:
Nov 29 01:17:30 karl-precise kernel: [  100.964467] 
[<ffffffffa0061180>] run_delayed_data_ref+0xb0/0x1a0 [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.964496] 
[<ffffffff8116087f>] ? kmem_cache_free+0x2f/0x110
Nov 29 01:17:30 karl-precise kernel: [  100.965751] 
[<ffffffffa0064b3e>] run_one_delayed_ref+0x8e/0xf0 [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.966996] 
[<ffffffffa0064c74>] run_clustered_refs+0xd4/0x240 [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffffa0064eaa>] btrfs_run_delayed_refs+0xca/0x220 [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffff8165135d>] ? mutex_lock+0x1d/0x50
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffffa008ede6>] ? btrfs_run_ordered_operations+0x1d6/0x1f0 [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffffa0074f53>] btrfs_commit_transaction+0x93/0x840 [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffff81089c50>] ? add_wait_queue+0x60/0x60
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffff8116087f>] ? kmem_cache_free+0x2f/0x110
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffffa00a8982>] btrfs_recover_log_trees+0x2d2/0x300 [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffffa00a75e0>] ? fixup_inode_link_counts+0x150/0x150 [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffffa0073411>] open_ctree+0x1471/0x1920 [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffff81311d74>] ? snprintf+0x34/0x40
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffffa00c2582>] btrfs_fill_super.isra.38+0x72/0x12c [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffff811e1d7a>] ? disk_name+0xba/0xc0
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffff8130f397>] ? strlcpy+0x47/0x60
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffffa0052807>] btrfs_mount+0x497/0x4e0 [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffff81179b43>] mount_fs+0x43/0x1b0
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffff811941ba>] vfs_kern_mount+0x6a/0xc0
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffff81195664>] do_kern_mount+0x54/0x110
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffff811971b4>] do_mount+0x1a4/0x260
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffff81197690>] sys_mount+0x90/0xe0
Nov 29 01:17:30 karl-precise kernel: [  100.967397] 
[<ffffffff8165ad02>] system_call_fastpath+0x16/0x1b
Nov 29 01:17:30 karl-precise kernel: [  100.967397] Code: 0f 85 94 fa ff 
ff 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 0f 0b 48 8b 55 c8 48 8b 3b 48 8d 73 40 
e8 98 17 06 00 39 45 20 0f 84 e9 fd ff ff <0f> 0b 0f 0b 89 c6 4c 89 ea 
31 c0 48 c7 c7 48 9d 0c a0 e8 7b 93
Nov 29 01:17:30 karl-precise kernel: [  100.967397] RIP 
[<ffffffffa0060ef7>] __btrfs_free_extent+0x617/0x650 [btrfs]
Nov 29 01:17:30 karl-precise kernel: [  100.967397]  RSP <ffff880404ec9778>
Nov 29 01:17:30 karl-precise kernel: [  101.005914] ---[ end trace 
ae54b272e480df0f ]---

--------------- After digging through some log files I found the first 
occurrence of this error, with some new log lines -----------

These lines occurred just before the first time the partition became 
unmountable:

Nov 27 23:45:47 karl-workstation kernel: [211390.634303] btrfs csum 
failed ino 3738022 off 1819189248 csum 318166411 private 1787547189
Nov 27 23:45:54 karl-workstation kernel: [211398.556254] btrfs csum 
failed ino 3738022 off 1819189248 csum 2203380165 private 1787547189
Nov 27 23:45:55 karl-workstation kernel: [211398.676454] btrfs csum 
failed ino 3738022 off 1819189248 csum 2203380165 private 1787547189
Nov 27 23:45:55 karl-workstation kernel: [211398.679193] btrfs csum 
failed ino 3738022 off 1819189248 csum 2203380165 private 1787547189

And then this

Nov 28 00:11:14 karl-workstation kernel: [212918.235045] ------------[ 
cut here ]------------
Nov 28 00:11:14 karl-workstation kernel: [212918.235050] kernel BUG at 
/home/apw/COD/linux/fs/btrfs/extent-tree.c:4775!
Nov 28 00:11:14 karl-workstation kernel: [212918.235052] invalid opcode: 
0000 [#1] SMP
Nov 28 00:11:14 karl-workstation kernel: [212918.235054] CPU 0
Nov 28 00:11:14 karl-workstation kernel: [212918.235056] Modules linked 
in: nls_iso8859_1 nls_cp437 vfat fat bnep rfcomm bluetooth 
ip6table_filter ip6_tables ipt_MASQUERADE iptable_nat nf_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT 
xt_CHECKSUM iptable_mangle xt_tcpudp nfsd iptable_filter lockd ip_tables 
nfs_acl x_tables auth_rpcgss sunrpc bridge stp kvm_amd kvm ppdev 
binfmt_misc arc4 rt2500usb rt2x00usb rt2x00lib mac80211 cfg80211 
snd_hda_codec_hdmi snd_hda_codec_realtek fglrx(P) snd_hda_intel psmouse 
snd_seq_midi snd_hda_codec snd_rawmidi snd_hwdep snd_seq_midi_event 
snd_pcm snd_seq edac_core serio_raw edac_mce_amd k10temp sp5100_tco 
snd_seq_device i2c_piix4 snd_timer asus_atk0110 snd soundcore 
snd_page_alloc wmi lp parport raid10 raid456 async_pq async_xor xor 
async_memcpy async_raid6_recov usb_storage uas usbhid hid raid6_pq 
async_tx raid1 pata_atiixp raid0 firewire_ohci ahci libahci multipath 
firewire_core crc_itu_t linear btrfs r8169 zlib_deflate libcrc32c [last 
unloaded: parport_pc]
Nov 28 00:11:14 karl-workstation kernel: [212918.235092]
Nov 28 00:11:14 karl-workstation kernel: [212918.235094] Pid: 6962, 
comm: btrfs-endio-wri Tainted: P           O 3.2.0-999-generic 
#201111220410 System manufacturer System Product Name/M4A79T Deluxe
Nov 28 00:11:14 karl-workstation kernel: [212918.235098] RIP: 
0010:[<ffffffffa002b910>]  [<ffffffffa002b910>] 
__btrfs_free_extent+0x6c0/0x700 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235117] RSP: 
0018:ffff880380173990  EFLAGS: 00010207
Nov 28 00:11:14 karl-workstation kernel: [212918.235118] RAX: 
00000000ea000001 RBX: ffff880412c3ab40 RCX: ffff880380173900
Nov 28 00:11:14 karl-workstation kernel: [212918.235120] RDX: 
ffff880000000000 RSI: 00000000000007ad RDI: ffff88027db9a8c0
Nov 28 00:11:14 karl-workstation kernel: [212918.235121] RBP: 
ffff880380173a80 R08: 00000000000007b1 R09: ffff8803801738f0
Nov 28 00:11:14 karl-workstation kernel: [212918.235123] R10: 
0000000000000000 R11: 0000000000000000 R12: 000000000000002c
Nov 28 00:11:14 karl-workstation kernel: [212918.235124] R13: 
0000000081c1f000 R14: 0000000000000001 R15: 0000000000000001
Nov 28 00:11:14 karl-workstation kernel: [212918.235126] FS: 
00007fd5b95399c0(0000) GS:ffff88042fc00000(0000) knlGS:00000000f67d8880
Nov 28 00:11:14 karl-workstation kernel: [212918.235127] CS:  0010 DS: 
0000 ES: 0000 CR0: 000000008005003b
Nov 28 00:11:14 karl-workstation kernel: [212918.235129] CR2: 
00007f3a8bbd7000 CR3: 00000003452e1000 CR4: 00000000000006f0
Nov 28 00:11:14 karl-workstation kernel: [212918.235130] DR0: 
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 28 00:11:14 karl-workstation kernel: [212918.235132] DR3: 
0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Nov 28 00:11:14 karl-workstation kernel: [212918.235133] Process 
btrfs-endio-wri (pid: 6962, threadinfo ffff880380172000, task 
ffff8803f47d16f0)
Nov 28 00:11:14 karl-workstation kernel: [212918.235135] Stack:
Nov 28 00:11:14 karl-workstation kernel: [212918.235136] 
0000000000000000 0000000000000005 00000000002011c9 000000000005a000
Nov 28 00:11:14 karl-workstation kernel: [212918.235138] 
0000160000000000 0000000000000000 0000000200000033 ffff880000000035
Nov 28 00:11:14 karl-workstation kernel: [212918.235140] 
0000000112f78030 ffff8804146ee000 0000000100001000 ffff88041194a000
Nov 28 00:11:14 karl-workstation kernel: [212918.235143] Call Trace:
Nov 28 00:11:14 karl-workstation kernel: [212918.235153] 
[<ffffffffa002bc04>] run_delayed_data_ref+0x154/0x160 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235162] 
[<ffffffffa001a203>] ? leaf_space_used+0xc3/0xf0 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235171] 
[<ffffffffa002bcba>] run_one_delayed_ref+0xaa/0xc0 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235180] 
[<ffffffffa002bd90>] run_clustered_refs+0xc0/0x220 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235189] 
[<ffffffffa002bfba>] btrfs_run_delayed_refs+0xca/0x220 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235193] 
[<ffffffff8160f27e>] ? _raw_spin_lock+0xe/0x20
Nov 28 00:11:14 karl-workstation kernel: [212918.235203] 
[<ffffffffa003b08f>] __btrfs_end_transaction+0xbf/0x250 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235213] 
[<ffffffffa003b295>] btrfs_end_transaction+0x15/0x20 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235223] 
[<ffffffffa00403cb>] btrfs_finish_ordered_io+0x16b/0x340 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235233] 
[<ffffffffa00405f1>] btrfs_writepage_end_io_hook+0x51/0xa0 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235244] 
[<ffffffffa0056c8b>] end_bio_extent_writepage+0x13b/0x180 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235247] 
[<ffffffff8160d66b>] ? schedule_timeout+0x18b/0x2e0
Nov 28 00:11:14 karl-workstation kernel: [212918.235250] 
[<ffffffff811ab9dd>] bio_endio+0x1d/0x40
Nov 28 00:11:14 karl-workstation kernel: [212918.235259] 
[<ffffffffa0034ef4>] end_workqueue_fn+0xf4/0x130 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235269] 
[<ffffffffa0063f8c>] worker_loop+0x15c/0x4c0 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235279] 
[<ffffffffa0063e30>] ? check_pending_worker_creates+0xd0/0xd0 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235283] 
[<ffffffff81088536>] kthread+0x96/0xa0
Nov 28 00:11:14 karl-workstation kernel: [212918.235285] 
[<ffffffff816197f4>] kernel_thread_helper+0x4/0x10
Nov 28 00:11:14 karl-workstation kernel: [212918.235288] 
[<ffffffff810884a0>] ? kthread_worker_fn+0x190/0x190
Nov 28 00:11:14 karl-workstation kernel: [212918.235290] 
[<ffffffff816197f0>] ? gs_change+0x13/0x13
Nov 28 00:11:14 karl-workstation kernel: [212918.235291] Code: 8b bd 70 
ff ff ff e8 00 22 00 00 0f 0b eb fe 48 8b 55 c8 48 8b bd 68 ff ff ff 48 
89 de e8 49 b5 ff ff 39 45 20 0f 84 78 fd ff ff <0f> 0b eb fe 0f 0b eb 
fe 0f 0b eb fe 0f 0b eb fe 0f 0b eb fe be
Nov 28 00:11:14 karl-workstation kernel: [212918.235309] RIP 
[<ffffffffa002b910>] __btrfs_free_extent+0x6c0/0x700 [btrfs]
Nov 28 00:11:14 karl-workstation kernel: [212918.235317]  RSP 
<ffff880380173990>
Nov 28 00:11:14 karl-workstation kernel: [212918.235320] ---[ end trace 
7c26e4285890c533 ]---

And then I had to reboot the system as it became unresponsive.
If you need any more info I will be more than happy to help out.

Karl M. Kittilsen
