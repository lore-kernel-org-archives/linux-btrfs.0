From: Steve Freitas <sflist@ihonk.com>
Subject: btrfs volume mounts and dies (was Re: Segfault in btrfsck)
Date: Sun, 03 Jan 2010 14:57:01 -0800
Message-ID: <1262559421.17096.50.camel@phat>
References: <1262476565.17096.20.camel@phat>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1262476565.17096.20.camel@phat>
List-ID: <linux-btrfs.vger.kernel.org>

Got some more information. I installed Debian on another disk ("rescue")
running 2.6.32, pulled the latest btrfs module code from git, applied an
earlier mentioned patch[1], then compiled and loaded the new module.
It's able to mount the volume initially...

Jan  3 14:46:57 rescue kernel: [   25.984141] Btrfs loaded
Jan  3 14:46:57 rescue kernel: [   25.984711] device fsid
334a5cd99de23fc4-ed77fc1dc6f59780 devid 1 transid 29665 /dev/sdb3
Jan  3 14:46:57 rescue kernel: [   25.985137] btrfs: use compression

But after a little activity (chrooting in and running "apt-get update"),
the apt-get freezes and I get many hundreds of thousands of these:

Jan  3 14:47:30 rescue kernel: [   59.275031] parent transid verify
failed on 111181824 wanted 29645 found 27038

Eventually, I get this:

Jan  3 14:50:31 rescue kernel: [  240.364274] INFO: task
btrfs-transacti:1400 blocked for more than 120 seconds.
Jan  3 14:50:31 rescue kernel: [  240.364337] "echo 0
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan  3 14:50:31 rescue kernel: [  240.364399] btrfs-transac D
0000000000000000     0  1400      2 0x00000000
Jan  3 14:50:31 rescue kernel: [  240.364515]  ffff88021f06b880
0000000000000046 0000000000000000 ffffffffa02d4e98
Jan  3 14:50:31 rescue kernel: [  240.364692]  ffffea0007646b10
0000000000000000 000000000000f8a0 ffff88021cb75fd8
Jan  3 14:50:31 rescue kernel: [  240.364867]  00000000000155c0
00000000000155c0 ffff88021dc37810 ffff88021dc37b08
Jan  3 14:50:31 rescue kernel: [  240.365042] Call Trace:
Jan  3 14:50:31 rescue kernel: [  240.365097]  [<ffffffffa02d4e98>] ?
update_block_group+0x1b1/0x1d3 [btrfs]
Jan  3 14:50:31 rescue kernel: [  240.365150]  [<ffffffff8106bebd>] ?
ktime_get_ts+0x68/0xb2
Jan  3 14:50:31 rescue kernel: [  240.365201]  [<ffffffff810989b2>] ?
delayacct_end+0x74/0x7f
Jan  3 14:50:31 rescue kernel: [  240.365251]  [<ffffffff810b2c91>] ?
sync_page+0x0/0x46
Jan  3 14:50:31 rescue kernel: [  240.365300]  [<ffffffff812e412e>] ?
io_schedule+0x73/0xb7
Jan  3 14:50:31 rescue kernel: [  240.365349]  [<ffffffff810b2cd2>] ?
sync_page+0x41/0x46
Jan  3 14:50:31 rescue kernel: [  240.365397]  [<ffffffff812e462e>] ?
__wait_on_bit+0x41/0x70
Jan  3 14:50:31 rescue kernel: [  240.365447]  [<ffffffff810b2e56>] ?
wait_on_page_bit+0x6b/0x71
Jan  3 14:50:31 rescue kernel: [  240.365496]  [<ffffffff81064a9c>] ?
wake_bit_function+0x0/0x23
Jan  3 14:50:31 rescue kernel: [  240.365547]  [<ffffffff810ba94e>] ?
pagevec_lookup_tag+0x1a/0x21
Jan  3 14:50:31 rescue kernel: [  240.365596]  [<ffffffff810b35f2>] ?
wait_on_page_writeback_range+0x69/0x11b
Jan  3 14:50:31 rescue kernel: [  240.365655]  [<ffffffffa02f83d9>] ?
btrfs_wait_ordered_range+0x6b/0x112 [btrfs]
Jan  3 14:50:31 rescue kernel: [  240.365725]  [<ffffffffa02f865e>] ?
btrfs_run_ordered_operations+0x12d/0x1b6 [btrfs]
Jan  3 14:50:31 rescue kernel: [  240.365794]  [<ffffffffa02e353f>] ?
btrfs_commit_transaction+0x29f/0x618 [btrfs]
Jan  3 14:50:31 rescue kernel: [  240.365857]  [<ffffffff81064a6e>] ?
autoremove_wake_function+0x0/0x2e
Jan  3 14:50:31 rescue kernel: [  240.365913]  [<ffffffffa02df2cf>] ?
transaction_kthread+0x173/0x204 [btrfs]
Jan  3 14:50:31 rescue kernel: [  240.365970]  [<ffffffffa02df15c>] ?
transaction_kthread+0x0/0x204 [btrfs]
Jan  3 14:50:31 rescue kernel: [  240.366021]  [<ffffffff810647a1>] ?
kthread+0x79/0x81
Jan  3 14:50:31 rescue kernel: [  240.366070]  [<ffffffff81011b6a>] ?
child_rip+0xa/0x20
Jan  3 14:50:31 rescue kernel: [  240.366118]  [<ffffffff81064728>] ?
kthread+0x0/0x81
Jan  3 14:50:31 rescue kernel: [  240.366166]  [<ffffffff81011b60>] ?
child_rip+0x0/0x20
Jan  3 14:50:31 rescue kernel: [  240.366214] INFO: task apt-get:1411
blocked for more than 120 seconds.
Jan  3 14:50:31 rescue kernel: [  240.366264] "echo 0
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jan  3 14:50:31 rescue kernel: [  240.366326] apt-get       D
0000000000000002     0  1411   1407 0x00000004
Jan  3 14:50:31 rescue kernel: [  240.366433]  ffff88021dc32a60
0000000000000082 0000005001c9f000 0000000001c9f000
Jan  3 14:50:31 rescue kernel: [  240.366608]  0000000000000000
0000000000000000 000000000000f8a0 ffff88021b869fd8
Jan  3 14:50:31 rescue kernel: [  240.366782]  00000000000155c0
00000000000155c0 ffff88021c3d69f0 ffff88021c3d6ce8
Jan  3 14:50:31 rescue kernel: [  240.366957] Call Trace:
Jan  3 14:50:31 rescue kernel: [  240.367002]  [<ffffffff810b7df3>] ?
__pagevec_free+0x69/0x80
Jan  3 14:50:31 rescue kernel: [  240.367051]  [<ffffffff81017131>] ?
read_tsc+0xa/0x20
Jan  3 14:50:31 rescue kernel: [  240.367100]  [<ffffffff810b2c91>] ?
sync_page+0x0/0x46
Jan  3 14:50:31 rescue kernel: [  240.367148]  [<ffffffff812e412e>] ?
io_schedule+0x73/0xb7
Jan  3 14:50:31 rescue kernel: [  240.367197]  [<ffffffff810b2cd2>] ?
sync_page+0x41/0x46
Jan  3 14:50:31 rescue kernel: [  240.367245]  [<ffffffff812e462e>] ?
__wait_on_bit+0x41/0x70
Jan  3 14:50:31 rescue kernel: [  240.367294]  [<ffffffff810b2e56>] ?
wait_on_page_bit+0x6b/0x71
Jan  3 14:50:31 rescue kernel: [  240.367343]  [<ffffffff81064a9c>] ?
wake_bit_function+0x0/0x23
Jan  3 14:50:31 rescue kernel: [  240.367393]  [<ffffffff810bb33e>] ?
lock_page+0x9/0x1f
Jan  3 14:50:31 rescue kernel: [  240.367441]  [<ffffffff810bba88>] ?
truncate_inode_pages_range+0x257/0x2b0
Jan  3 14:50:31 rescue kernel: [  240.367500]  [<ffffffffa02e9881>] ?
btrfs_delete_inode+0x27/0x132 [btrfs]
Jan  3 14:50:31 rescue kernel: [  240.367557]  [<ffffffffa02e985a>] ?
btrfs_delete_inode+0x0/0x132 [btrfs]
Jan  3 14:50:31 rescue kernel: [  240.367609]  [<ffffffff810fd840>] ?
generic_delete_inode+0xdc/0x168
Jan  3 14:50:31 rescue kernel: [  240.367659]  [<ffffffff810fa1ff>] ?
d_kill+0x34/0x55
Jan  3 14:50:31 rescue kernel: [  240.367707]  [<ffffffff810fbd76>] ?
dput+0x13d/0x149
Jan  3 14:50:31 rescue kernel: [  240.367755]  [<ffffffff810f651c>] ?
sys_renameat+0x184/0x1e9
Jan  3 14:50:31 rescue kernel: [  240.367804]  [<ffffffff81064a6e>] ?
autoremove_wake_function+0x0/0x2e
Jan  3 14:50:31 rescue kernel: [  240.367854]  [<ffffffff8106bebd>] ?
ktime_get_ts+0x68/0xb2
Jan  3 14:50:31 rescue kernel: [  240.367904]  [<ffffffff810ec812>] ?
vfs_read+0xca/0xff
Jan  3 14:50:31 rescue kernel: [  240.367953]  [<ffffffff81010b02>] ?
system_call_fastpath+0x16/0x1b

Any ideas? I'm happy to apply any patches you suggest and try again...

Steve

[1]http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg03686.html


