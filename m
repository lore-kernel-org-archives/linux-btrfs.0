From: David Sterba <dave@jikos.cz>
Subject: Crash in io_ctl_drop_pages after mount with csum errors
Date: Thu, 5 Jan 2012 17:49:19 +0100
Message-ID: <20120105164919.GP7322@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I mounted a multi-folume fs created not-so-long ago in a 3.1 based
kernel and mounted with v3.2-rc7-83-g115e8e7 , it crashed immediately.
It's quite possible that the disk is to blame, it's an old 160G
SP1614C, but syslog does not contain any error messages. I'm not sure
whether the fs was cleanly unmounted, seems not, but anyway I do not
expect a crash.

Label: none  uuid: 5f06f9eb-9736-49f7-91a2-2f45522512ef
        Total devices 4 FS bytes used 1.38GB
        devid    4 size 34.00GB used 34.00GB path /dev/sdg8
        devid    3 size 34.00GB used 34.00GB path /dev/sdg7
        devid    2 size 34.00GB used 34.00GB path /dev/sdg6
        devid    1 size 34.00GB used 34.00GB path /dev/sdg5

mount options: compress-force=lzo,space_cache,autodefrag,inode_cache

[ 1461.732855] btrfs: force lzo compression
[ 1461.732876] btrfs: enabling auto defrag
[ 1461.732893] btrfs: enabling inode map caching
[ 1461.732907] btrfs: disk space caching is enabled
[ 1499.796181] btrfs: csum mismatch on free space cache
[ 1499.796266] btrfs: failed to load free space cache for block group 29360128
[ 1499.888699] btrfs csum failed ino 18446744073709551604 off 65536 csum 2566472073 private 1925235876
[ 1499.888826] btrfs csum failed ino 18446744073709551604 off 327680 csum 2566472073 private 1925235876
[ 1499.906229] btrfs csum failed ino 18446744073709551604 off 0 csum 1695430581 private 1170642078
[ 1499.906345] btrfs csum failed ino 18446744073709551604 off 262144 csum 2566472073 private 1925235876
[ 1499.906446] btrfs csum failed ino 18446744073709551604 off 524288 csum 2566472073 private 1925235876
[ 1499.924469] btrfs csum failed ino 18446744073709551604 off 196608 csum 2566472073 private 1925235876
[ 1499.924574] btrfs csum failed ino 18446744073709551604 off 458752 csum 2566472073 private 1925235876
[ 1499.946076] btrfs csum failed ino 18446744073709551604 off 131072 csum 2566472073 private 1925235876
[ 1499.946217] btrfs csum failed ino 18446744073709551604 off 393216 csum 2566472073 private 1925235876
[ 1499.946318] btrfs csum failed ino 18446744073709551604 off 0 csum 1695430581 private 1170642078
[ 1499.946362] btrfs: error reading free space cache
[ 1499.946409] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
[ 1499.946437] IP: [<ffffffffa0456dd7>] io_ctl_drop_pages+0x37/0x70 [btrfs]
[ 1499.946515] PGD 125ce4067 PUD 126941067 PMD 0
[ 1499.946539] Oops: 0002 [#1] PREEMPT SMP
[ 1499.946560] CPU 0
[ 1499.946569] Modules linked in: btrfs zlib_deflate aoe nfs lockd fscache auth_rpcgss nfs_acl sunrpc af_packet cpufreq_conservative cpufreq_userspace cpufreq_powersave powernow_k8 mperf snd_hda_codec_analog snd_hda_intel snd
_hda_codec sg sp5100_tco snd_hwdep snd_pcm amd64_edac_mod snd_timer pcspkr edac_core snd edac_mce_amd firewire_ohci firewire_core crc_itu_t i2c_piix4 k8temp asus_atk0110 soundcore snd_page_alloc sky2 autofs4 nouveau ttm drm_k
ms_helper drm processor i2c_algo_bit mxm_wmi wmi video thermal_sys button pata_via sata_promise sata_via ata_generic sata_sil pata_atiixp
[ 1499.946832]
[ 1499.946843] Pid: 2799, comm: rm Not tainted 3.2.0-rc7-1-desktop #1
[ 1499.946880] RIP: 0010:[<ffffffffa0456dd7>]  [<ffffffffa0456dd7>] io_ctl_drop_pages+0x37/0x70 [btrfs]
[ 1499.946936] RSP: 0018:ffff880127c6bc48  EFLAGS: 00010202
[ 1499.946951] RAX: 0000000000000001 RBX: ffff880127c6bcf0 RCX: ffff88012ffa3000
[ 1499.946971] RDX: 0000000000000000 RSI: ffffea0003ec0c80 RDI: ffffea0003ec0c80
[ 1499.946989] RBP: 0000000000000001 R08: 6400000000000000 R09: a8000fb032000000
[ 1499.947008] R10: 57ffda4fd1ec0c80 R11: 0000000000000000 R12: 0000000000000001
[ 1499.947028] R13: ffff880126d519b0 R14: 000000000002005a R15: 0000000000000001
[ 1499.947052] FS:  00007f6a9aa1c700(0000) GS:ffff88012fc00000(0000) knlGS:0000000000000000
[ 1499.947078] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1499.947097] CR2: 0000000000000001 CR3: 00000001275e5000 CR4: 00000000000006f0
[ 1499.947120] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1499.947143] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1499.947167] Process rm (pid: 2799, threadinfo ffff880127c6a000, task ffff880126378280)
[ 1499.947551] Stack:
[ 1499.947551]  0000000000000000 ffff880127c6bcf0 0000000000000000 ffffffffa0457e2e
[ 1499.947551]  0000000000000020 ffffea0003ec0c80 ffff880126d51980 ffff880127c6bd48
[ 1499.947551]  ffff880126d51980 0000000000000de0 ffff880125d13720 ffff8801267e6600
[ 1499.947551] Call Trace:
[ 1499.947551]  [<ffffffffa0457e2e>] io_ctl_prepare_pages.isra.31+0x9e/0x150 [btrfs]
[ 1499.947551]  [<ffffffffa0459d3f>] __load_free_space_cache+0x1ff/0x610 [btrfs]
[ 1499.947551]  [<ffffffffa045b134>] load_free_ino_cache+0xd4/0x100 [btrfs]
[ 1499.947551]  [<ffffffffa041a956>] start_caching+0x86/0x130 [btrfs]
[ 1499.947551]  [<ffffffffa041aab5>] btrfs_return_ino+0xb5/0x170 [btrfs]
[ 1499.947551]  [<ffffffffa042dc6b>] btrfs_evict_inode+0x2cb/0x320 [btrfs]
[ 1499.947551]  [<ffffffff811745af>] evict+0x9f/0x1a0
[ 1499.947551]  [<ffffffff8116968f>] do_unlinkat+0x15f/0x1d0
[ 1499.947551]  [<ffffffff815c7812>] system_call_fastpath+0x16/0x1b
[ 1499.947551]  [<00007f6a9a5539b7>] 0x7f6a9a5539b6
[ 1499.947551] Code: 0f 48 c7 07 00 00 00 00 48 c7 47 08 00 00 00 00 8b 43 34 85 c0 7e 3a 31 ed 0f 1f 00 48 8b 43 18 4c 63 e5 4a 8b 04 e0 48 83 c0 01 <f0> 80 20 fe 48 8b 43 18 83 c5 01 4a 8b 3c e0 e8 75 4f ca e0 48
[ 1499.947551] RIP  [<ffffffffa0456dd7>] io_ctl_drop_pages+0x37/0x70 [btrfs]
[ 1499.947551]  RSP <ffff880127c6bc48>
[ 1499.947551] CR2: 0000000000000001
[ 1499.977841] ---[ end trace 22016411c26ba8c7 ]---

It tries to dereference 0x1, looks like an in return value instead of pointer:

(gdb) l *(io_ctl_drop_pages+0x37)
0x627c7 is in io_ctl_drop_pages (fs/btrfs/free-space-cache.c:321).
316     {
317             int i;
318
319             io_ctl_unmap_page(io_ctl);
320
321             for (i = 0; i < io_ctl->num_pages; i++) {
322                     ClearPageChecked(io_ctl->pages[i]);
323                     unlock_page(io_ctl->pages[i]);
324                     page_cache_release(io_ctl->pages[i]);
325             }

after reboot:

# btrfsck /dev/sdg5
root 5 inode 18446744073709551604 errors 2000
root 5 inode 18446744073709551605 errors 1
found 1482883072 bytes used err is 1
total csum bytes: 30824
total tree bytes: 972619776
total fs tree bytes: 969998336
btree space waste bytes: 192136036
file data blocks allocated: 510263296
 referenced 917307392
Btrfs v0.19+

and "mount /dev/sdg5 /mnt/test" went fine, umount is stuck:

  PID TTY      STAT   TIME COMMAND
 2441 ?        D      0:00 [btrfs-worker-1]
[<ffffffff810fbd19>] sleep_on_page+0x9/0x10
[<ffffffff810fbd02>] __lock_page+0x62/0x70
[<ffffffffa04462b5>] read_extent_buffer_pages+0x275/0x510 [btrfs]
[<ffffffffa041fa80>] btree_read_extent_buffer_pages.isra.101+0x80/0xc0 [btrfs]
[<ffffffffa0421030>] csum_dirty_buffer+0xd0/0x240 [btrfs]
[<ffffffffa04211d5>] __btree_submit_bio_start+0x35/0x70 [btrfs]
[<ffffffffa044ef51>] worker_loop+0xa1/0x2a0 [btrfs]
[<ffffffff8107799e>] kthread+0x7e/0x90
[<ffffffff815c99f4>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff
  PID TTY      STAT   TIME COMMAND
 2457 pts/1    D+     0:00 umount /mnt/test
[<ffffffff810fbd19>] sleep_on_page+0x9/0x10
[<ffffffff810fbe4f>] wait_on_page_bit+0x6f/0x80
[<ffffffffa0444cd5>] extent_write_cache_pages.isra.22.constprop.32+0x295/0x390 [btrfs]
[<ffffffffa0444fff>] extent_writepages+0x3f/0x60 [btrfs]
[<ffffffff810fd8dc>] __filemap_fdatawrite_range+0x4c/0x60
[<ffffffffa0425ac8>] btrfs_write_marked_extents+0x68/0xb0 [btrfs]
[<ffffffffa0425be6>] btrfs_write_and_wait_marked_extents+0x26/0x60 [btrfs]
[<ffffffffa0426371>] btrfs_commit_transaction+0x601/0x860 [btrfs]
[<ffffffff81188538>] __sync_filesystem+0x58/0x90
[<ffffffff8115c924>] generic_shutdown_super+0x34/0xe0
[<ffffffff8115ca59>] kill_anon_super+0x9/0x20
[<ffffffff8115d013>] deactivate_locked_super+0x33/0x90
[<ffffffff8117a3b1>] sys_umount+0x51/0xc0
[<ffffffff815c7812>] system_call_fastpath+0x16/0x1b
[<00007f001aca65d7>] 0x7f001aca65d7
[<ffffffffffffffff>] 0xffffffffffffffff


david
