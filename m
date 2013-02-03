Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:57510 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab3BCMTa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Feb 2013 07:19:30 -0500
Received: by mail-ie0-f169.google.com with SMTP id 13so2814444iea.28
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Feb 2013 04:19:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGvr90BH3DWzqXt-5cJz9e0myU-rU-+Om=RmAG8eY_=N9hKUZw@mail.gmail.com>
References: <CAGvr90BH3DWzqXt-5cJz9e0myU-rU-+Om=RmAG8eY_=N9hKUZw@mail.gmail.com>
Date: Sun, 3 Feb 2013 12:19:29 +0000
Message-ID: <CAGvr90DA3KQrBTRG2pmAnihjhJ2wJ4srfP=BYqcJuCqRLob8Ug@mail.gmail.com>
Subject: kernel BUG at fs/btrfs/extent-tree.c:6185!
From: Radek Machulka <radek.machulka@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,

my computer suddenly failed to boot. It seams that it is unable to mount
/home which is btrfs. Here are the messages I get during the boot (the
relevant part; hopefully):

Feb 02 13:59:58 Edge kernel: kernel BUG at fs/btrfs/extent-tree.c:6185!
Feb 02 13:59:58 Edge kernel: invalid opcode: 0000 [#1] PREEMPT SMP
Feb 02 13:59:58 Edge kernel: Modules linked in: joydev coretemp kvm_intel
kvm arc4 ghash_clmulni_intel aesni_intel aes_x86_64 ablk_helper snd_hda_cod
Feb 02 13:59:58 Edge kernel: CPU 1
Feb 02 13:59:58 Edge systemd[1]: home.mount mount process exited,
code=killed status=11
Feb 02 13:59:58 Edge kernel: Pid: 314, comm: mount Tainted: G         C
3.7.5-1-ARCH #1 LENOVO 129886G/129886G
Feb 02 13:59:58 Edge kernel: RIP: 0010:[<ffffffffa024e0a7>]
[<ffffffffa024e0a7>] btrfs_alloc_logged_file_extent+0x1c7/0x1e0 [btrfs]
Feb 02 13:59:58 Edge kernel: RSP: 0018:ffff880138b53758  EFLAGS: 00010286
Feb 02 13:59:58 Edge kernel: RAX: 00000000fffffff5 RBX: ffff880135bc4200
RCX: 000000000001a7c0
Feb 02 13:59:58 Edge kernel: RDX: ffffea0004dea100 RSI: 0000000000000002
RDI: ffff880138bdd840
Feb 02 13:59:58 Edge kernel: RBP: ffff880138b537d8 R08: ffff880138b53fd8
R09: ffff880134ace400
Feb 02 13:59:58 Edge kernel: R10: ffffffffa029aa6c R11: ffff880138b53fd8
R12: ffff880138b538a3
Feb 02 13:59:58 Edge kernel: R13: 0000000000000000 R14: 000000017f8f1000
R15: ffff8801388b6000
Feb 02 13:59:58 Edge kernel: FS:  00007f9c55f20780(0000)
GS:ffff88013fa40000(0000) knlGS:0000000000000000
Feb 02 13:59:58 Edge kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Feb 02 13:59:58 Edge kernel: CR2: 000000000161ceb0 CR3: 0000000138b5c000
CR4: 00000000000407e0
Feb 02 13:59:58 Edge kernel: DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
Feb 02 13:59:58 Edge systemd[1]: Failed to mount /home.
Feb 02 13:59:58 Edge systemd-journal[345]: Allowing runtime journal files to
grow to 193.5M.
Feb 02 13:59:58 Edge kernel: Process mount (pid: 314, threadinfo
ffff880138b52000, task ffff880134bcc920)
Feb 02 13:59:58 Edge kernel: Stack:
Feb 02 13:59:58 Edge kernel:  0000000000000001 0000000000008000
ffff880138b53788 ffffffffa023a1ea
Feb 02 13:59:58 Edge kernel:  0000000000614000 0000000000000430
0000000000000005 ffff880137a81000
Feb 02 13:59:58 Edge kernel:  0000000000008000 00ff88013788a560
a8000000017f8f10 ffff8801388b6000
Feb 02 13:59:58 Edge kernel: Call Trace:
Feb 02 13:59:58 Edge kernel:  [<ffffffffa023a1ea>] ?
btrfs_free_path+0x2a/0x40 [btrfs]
Feb 02 13:59:58 Edge kernel:  [<ffffffffa0293990>]
replay_one_extent+0x620/0x690 [btrfs]
Feb 02 13:59:58 Edge kernel:  [<ffffffffa0292fc8>] ?
add_inode_ref+0x638/0x9e0 [btrfs]
Feb 02 13:59:58 Edge kernel:  [<ffffffffa026e940>] ?
btrfs_destroy_inode+0x1c0/0x2e0 [btrfs]
Feb 02 13:59:58 Edge kernel:  [<ffffffffa0294a1b>]
replay_one_buffer+0x2db/0x3a0 [btrfs]
Feb 02 13:59:58 Edge kernel:  [<ffffffffa027c9bd>] ?
alloc_extent_buffer+0x9d/0x490 [btrfs]
Feb 02 13:59:58 Edge kernel:  [<ffffffffa02913e2>]
walk_down_log_tree+0x212/0x400 [btrfs]
Feb 02 13:59:58 Edge kernel:  [<ffffffffa029166d>] walk_log_tree+0x9d/0x1f0
[btrfs]
Feb 02 13:59:58 Edge kernel:  [<ffffffffa02979eb>]
btrfs_recover_log_trees+0x21b/0x3a0 [btrfs]
Feb 02 13:59:58 Edge kernel:  [<ffffffffa0294740>] ?
replay_one_dir_item+0xf0/0xf0 [btrfs]
Feb 02 13:59:58 Edge kernel:  [<ffffffffa025d9d7>] open_ctree+0x1587/0x1ba0
[btrfs]
Feb 02 13:59:58 Edge kernel:  [<ffffffff81255091>] ? disk_name+0x61/0xc0
Feb 02 13:59:58 Edge kernel:  [<ffffffffa0236ae3>] btrfs_mount+0x633/0x770
[btrfs]
Feb 02 13:59:58 Edge kernel:  [<ffffffff81165f60>] ?
alloc_pages_current+0xb0/0x120
Feb 02 13:59:58 Edge kernel:  [<ffffffff81188163>] mount_fs+0x43/0x1b0
Feb 02 13:59:58 Edge kernel:  [<ffffffff811a2974>] vfs_kern_mount+0x74/0x110
Feb 02 13:59:58 Edge kernel:  [<ffffffff811a2ed4>] do_kern_mount+0x54/0x110
Feb 02 13:59:58 Edge kernel:  [<ffffffff811a4b55>] do_mount+0x315/0x8e0
Feb 02 13:59:58 Edge kernel:  [<ffffffff811a46aa>] ?
copy_mount_options+0x3a/0x180
Feb 02 13:59:58 Edge kernel:  [<ffffffff811a51ae>] sys_mount+0x8e/0xe0
Feb 02 13:59:58 Edge kernel:  [<ffffffff814c111d>]
system_call_fastpath+0x1a/0x1f
Feb 02 13:59:58 Edge kernel: Code: 0b 0f 1f 00 48 8d bb 80 00 00 00 e8 c4 68
ff ff 85 c0 74 1d 48 8b 55 c0 4c 89 f6 48 89 df e8 01 c8 04 00 85 c0 0f 84
29 ff ff ff <0f> 0b 0f 0b 0f 0b 0f 0b 0f 0b 66 66 66 66 66 66 2e 0f 1f 84 00
Feb 02 13:59:58 Edge kernel: RIP  [<ffffffffa024e0a7>]
btrfs_alloc_logged_file_extent+0x1c7/0x1e0 [btrfs]
Feb 02 13:59:58 Edge kernel:  RSP <ffff880138b53758>
Feb 02 13:59:58 Edge kernel: ---[ end trace 03c331f97cd8632d ]---


I was however able to save my data with btrfs-restore command (it boots into
some systemd emergency shell or I can use recovery cd). I tried to mount it
manually and after no success (the mount command does not end) mount it with
-o recovery option, but it does not do anything nether (well the command is
'running' for hours without any output until I turn the pc off, so I do not know
wheather it is recovering something or not). So before doing any btrfsck
--repair or btrfs-zero-log (which are pretty much all commands for
'repairing' btrfs I founded over the net) I would like to ask for some help
or advices.

Anyway here are some information about disc space:

root@sysresccd /root % btrfs fi show /dev/sda7
Label: 'home'  uuid: 04c96e2f-36b1-4dd2-9ab2-c35a355f54fe
Total devices 1 FS bytes used 123.87GB
devid    1 size 158.02GB used 158.02GB path /dev/sda7

Any help would be highly appreciated.
Thanks
Radek
