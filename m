From: Bob McElrath <bob@mcelrath.org>
Subject: kernel BUG at /home/apw/COD/linux/fs/btrfs/inode.c:3962!
Date: Mon, 2 Apr 2012 18:17:57 +0000
Message-ID: <20120402181757.GB31624@mcelrath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

A bug you all might be interested in.  If I can provide any more information,
please let me know.  The command that crashed was find, being run by updatedb
(daily cron job).  I can't tell from below which partition it was looking at,
but I have two raid1 (both data and metadata) btrfs filesystems:
Label: none  uuid: 9479be58-8b01-4c10-b33e-b66ed9c88884
    Total devices 2 FS bytes used 143.43GB
    devid    1 size 372.61GB used 192.04GB path /dev/dm-0
    devid    2 size 372.61GB used 192.03GB path /dev/dm-2

Label: 'video'  uuid: 40d58cae-72ad-46f4-9261-e437bb02d7f1
    Total devices 2 FS bytes used 829.19GB
    devid    1 size 1.05TB used 1.05TB path /dev/dm-1
    devid    2 size 1.05TB used 1.05TB path /dev/dm-3


kernel BUG at /home/apw/COD/linux/fs/btrfs/inode.c:3962!
invalid opcode: 0000 [#1] SMP 
CPU 3 
Modules linked in: ipx p8023 p4_clockmod speedstep_lib lirc_dev rfcomm bnep bluetooth kvm_intel kvm parport_pc ppdev binfmt_misc nfsd nfs lockd fscache auth_rpcgss nfs_acl sunrpc reiserfs joydev snd_hda_codec_hdmi snd_hda_codec_via snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi snd_seq_midi_event coretemp snd_seq snd_timer psmouse dm_multipath snd_seq_device snd eeprom fglrx(PO) w83791d hwmon_vid asus_atk0110 mac_hid soundcore snd_page_alloc serio_raw i2c_i801 firewire_sbp2 firewire_core crc_itu_t lp parport zfs(PO) zcommon(PO) znvpair(PO) zavl(PO) zunicode(PO) spl(O) raid10 raid1 raid0 multipath linear btrfs zlib_deflate libcrc32c pata_marvell raid456 async_pq async_xor xor async_memcpy async_raid6_recov raid6_pq async_tx usbhid hid r8169 pata_jmicron usb_storage

Pid: 20261, comm: find Tainted: P           O 3.3.0-030300rc7-generic #201203101735 System manufacturer System Product Name/P5Q SE PLUS
RIP: 0010:[<ffffffffa00eb9cb>]  [<ffffffffa00eb9cb>] btrfs_lookup_dentry+0x34b/0x350 [btrfs]
RSP: 0018:ffff88016e63bb88  EFLAGS: 00010a93
RAX: 0000000000000040 RBX: ffff88004d8f5c00 RCX: 0000000000000000
RDX: 0000000000000006 RSI: ffffc900004c4248 RDI: ffff88004d8f5c5c
RBP: ffff88016e63bc18 R08: 00000000000163e0 R09: ffff880227002600
R10: ffffffffa00eb7d7 R11: ffff88016e63bd48 R12: ffff8800b90d2c50
R13: ffff88021d3cfc00 R14: 0000000000000000 R15: ffff88004d8f5c00
FS:  00007fda62120700(0000) GS:ffff88022fd80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000008c2058 CR3: 000000013cc66000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process find (pid: 20261, threadinfo ffff88016e63a000, task ffff8802175e5bc0)
Stack:
 ffff88016e63bbb8 ffffffff811962fb ffff8800b90d3c50 ffff88004d8f5b40
 ffff88016e63bbb8 ffffffff812a449b ffff88016e63bbc8 ffffffff81197b69
 d60000000009a1d6 0000000000000340 ffff88016e63bb00 ffff88021d3cfc00
Call Trace:
 [<ffffffff811962fb>] ? __d_instantiate+0xdb/0x120
 [<ffffffff812a449b>] ? security_d_instantiate+0x1b/0x30
 [<ffffffff81197b69>] ? _d_rehash+0x49/0x50
 [<ffffffffa00eb9ed>] btrfs_lookup+0x1d/0x70 [btrfs]
 [<ffffffff8118bd81>] d_inode_lookup+0x21/0x60
 [<ffffffff8118e13e>] do_lookup+0x30e/0x390
 [<ffffffff81190428>] path_lookupat+0x118/0x690
 [<ffffffffa010ef98>] ? btrfs_tree_read_unlock_blocking+0x88/0xc0 [btrfs]
 [<ffffffff8116e7bc>] ? kmem_cache_alloc+0x3c/0x120
 [<ffffffff811909d1>] do_path_lookup+0x31/0xc0
 [<ffffffff811918e9>] user_path_at_empty+0x59/0xa0
 [<ffffffff8166024e>] ? _raw_spin_lock+0xe/0x20
 [<ffffffff811861d8>] ? cp_new_stat+0xf8/0x110
 [<ffffffff81191941>] user_path_at+0x11/0x20
 [<ffffffff811862b7>] vfs_fstatat+0x47/0x80
 [<ffffffff81186314>] sys_newfstatat+0x24/0x50
 [<ffffffff81668929>] system_call_fastpath+0x16/0x1b
Code: 48 8b 7d c8 e8 47 f8 ff ff 89 c3 e9 ff fe ff ff 49 8b 7c 24 28 48 8d 75 b0 31 c9 4c 89 ea e8 3d 91 ff ff 49 89 c6 e9 ae fd ff ff <0f> 0b eb fe 90 55 48 89 e5 48 83 ec 20 48 89 5d f0 4c 89 65 f8 
RIP  [<ffffffffa00eb9cb>] btrfs_lookup_dentry+0x34b/0x350 [btrfs]
 RSP <ffff88016e63bb88>


--
Cheers, Bob McElrath

"The individual has always had to struggle to keep from being overwhelmed by
the tribe.  If you try it, you will be lonely often, and sometimes frightened.
But no price is too high to pay for the privilege of owning yourself." --
Friedrich Nietzsche
