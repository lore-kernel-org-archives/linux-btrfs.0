From: "Ahmed Kamal" <email.ahmedkamal@googlemail.com>
Subject: crash when mounting
Date: Sun, 3 Aug 2008 02:12:53 +0300
Message-ID: <3da3b5b40808021612q1ec112c2jae0769b0abdcceb5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi guys,
I was playing on vmware with btrfs on complete disks /dev/sd{b,c,d,e}.
Next I decided to use partitions, so I created /dev/sd{b,c,d,e}1 and
used those, worked fine! Afterward, I mistakenly re-ran an old command
on the full disk ( mount -t btrfs -o subvol=. /dev/sdb /mnt/ ) notice
this is sdb not sdb1, and I got this spectacular kernel freeze. Let me
know if that's some bug.
Thanks

[root@btrfs tests]# mount -t btrfs -o subvol=. /dev/sdb /mnt/

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel: ------------[ cut here ]------------

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel: invalid opcode: 0000 [#1] SMP
Segmentation fault
[root@btrfs tests]#
Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel: Process mount (pid: 18986, ti=dc539000 task=ded4ae70 task.ti=dc539000)

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel: Stack: e0dc9e73 01c7b000 00000000 00001000 00000000 c1407134
c140a6bc 00000000

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:        00000282 00011220 df436880 00011270 00000000 c846e118
c846e120 c0463c6b

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:        dc539c40 c0463ed0 00000000 00011270 dc539c68 dc539c78
e0dc23a6 01c7b000

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel: Call Trace:

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [mempool_alloc_slab+14/16] ? mempool_alloc_slab+0xe/0x10

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [mempool_alloc+66/224] ? mempool_alloc+0x42/0xe0

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dc23a6>] ? set_extent_bit+0xa3/0x337 [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [bio_add_page+39/46] ? bio_add_page+0x27/0x2e

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dc5ded>] ? btrfs_map_block+0x19/0x1b [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dc5e4c>] ? btrfs_map_bio+0x5d/0x1b7 [btrfs]
Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dc3ab3>] ? end_bio_extent_readpage+0x0/0x339 [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dad33a>] ? __btree_submit_bio_hook+0x42/0x4b [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dae650>] ? btree_submit_bio_hook+0x15/0x3b [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dae63b>] ? btree_submit_bio_hook+0x0/0x3b [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dc0fc2>] ? submit_one_bio+0xdf/0x10c [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dc3854>] ? read_extent_buffer_pages+0x276/0x3c6 [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dc16cd>] ? add_lru+0x22/0x69 [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dacbf7>] ? btree_read_extent_buffer_pages+0x3a/0x8e [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0daf19b>] ? btree_get_extent+0x0/0x1cd [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dad922>] ? read_tree_block+0x3e/0x52 [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0dae0a9>] ? open_ctree+0x6d4/0x825 [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0da027e>] ? btrfs_get_sb_bdev+0x103/0x284 [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0da07bb>] ? btrfs_parse_options+0x261/0x26e [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [<e0da080c>] ? btrfs_get_sb+0x44/0x60 [btrfs]

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [vfs_kern_mount+130/245] ? vfs_kern_mount+0x82/0xf5
Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [do_kern_mount+50/186] ? do_kern_mount+0x32/0xba

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [do_new_mount+66/108] ? do_new_mount+0x42/0x6c

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [do_mount+420/450] ? do_mount+0x1a4/0x1c2

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [__get_free_pages+72/79] ? __get_free_pages+0x48/0x4f

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [copy_mount_options+42/249] ? copy_mount_options+0x2a/0xf9

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [sys_mount+102/158] ? sys_mount+0x66/0x9e

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  [syscall_call+7/11] ? syscall_call+0x7/0xb

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel:  =======================

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel: Code: 7d 1c 00 0f 95 45 93 84 c0 74 27 31 c0 80 7d 93 00 0f
85 0c 04 00 00 8b 55 10 ff 72 04 ff 32 57 56 68 73 9e dc e0 e8 38 91
86 df <0f> 0b 83 c4 14 eb fe 8b 4d ac 8b 51 10 8b 41 0c 39 fa 77 23 72

Message from syslogd@btrfs at Aug  3 05:09:33 ...
 kernel: EIP: [<e0dc59a6>] __btrfs_map_block+0xe1/0x4e1 [btrfs] SS:ESP
0068:dc539bd0
ls /
bin  boot  dev  etc  home  lib  lost+found  media  mnt  opt  proc
root  sbin  selinux  srv  sys  tmp  usr
