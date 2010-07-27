From: Joe Dunn <me@joedunn.com>
Subject: Btrfs Errors in Fedora 13 ESXi Based Virtual Machine
Date: Tue, 27 Jul 2010 15:40:02 -0500
Message-ID: <AANLkTinweLL6AOxBLjbd9JnqyeCAp7GKPv_yXf+W8hrW@mail.gmail.com>
References: <AANLkTimEjiN4hWhjE7n_ngO3OROCgoZ6v5Tdt_VNnVnS@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimEjiN4hWhjE7n_ngO3OROCgoZ6v5Tdt_VNnVnS@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Here are some of the errors I have collected in my F13 virt machine
using brtfs. If there is anything else you need just ask and I will
send along.

Jul 18 23:13:50 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 18 23:13:51 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 18 23:13:51 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 18 23:13:51 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 18 23:13:51 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 18 23:13:51 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 18 23:13:51 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 18 23:13:51 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899

Jul 24 01:41:03 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 24 01:41:03 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 24 01:41:03 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 24 01:41:03 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 24 01:41:03 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 24 01:41:03 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 24 01:42:37 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 24 01:42:37 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 24 01:42:37 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899
Jul 24 01:42:37 server01 kernel: btrfs csum failed ino 507592 off
389177344 csum 3166690140 private 2898406899

Jul 24 02:05:10 server01 kernel: Call Trace:
Jul 24 02:05:10 server01 kernel: [<ffffffffa008bccf>] ?
alloc_extent_state+0x16/0x54 [btrfs]
Jul 24 02:05:10 server01 kernel: [<ffffffff8106bbd4>] ? ktime_get_ts+0xad/0xba
Jul 24 02:05:10 server01 kernel: [<ffffffffa020537c>] ?
nfs_wait_bit_uninterruptible+0x0/0xd [nfs]
Jul 24 02:05:10 server01 kernel: [<ffffffff81428b04>] io_schedule+0x6e/0xb0
Jul 24 02:05:10 server01 kernel: [<ffffffffa0205385>]
nfs_wait_bit_uninterruptible+0x9/0xd [nfs]
Jul 24 02:05:10 server01 kernel: [<ffffffff81429040>] __wait_on_bit+0x43/0x76
Jul 24 02:05:10 server01 kernel: [<ffffffff811fe623>] ? __lookup_tag+0xbd/0x12d
Jul 24 02:05:10 server01 kernel: [<ffffffff814290dc>]
out_of_line_wait_on_bit+0x69/0x74
Jul 24 02:05:10 server01 kernel: [<ffffffffa020537c>] ?
nfs_wait_bit_uninterruptible+0x0/0xd [nfs]
Jul 24 02:05:10 server01 kernel: [<ffffffff810641f3>] ?
wake_bit_function+0x0/0x2e
Jul 24 02:05:10 server01 kernel: [<ffffffffa020537a>]
nfs_wait_on_request+0x23/0x25 [nfs]
Jul 24 02:05:10 server01 kernel: [<ffffffffa020987f>]
nfs_sync_mapping_wait+0xf1/0x215 [nfs]
Jul 24 02:05:10 server01 kernel: [<ffffffffa0209a35>]
nfs_wb_page+0x92/0xc2 [nfs]
Jul 24 02:05:10 server01 kernel: [<ffffffffa01fbfdd>]
nfs_release_page+0x45/0x5f [nfs]
Jul 24 02:05:10 server01 kernel: [<ffffffff810bfe36>]
try_to_release_page+0x2f/0x38
Jul 24 02:05:10 server01 kernel: [<ffffffff810cb7b3>]
shrink_page_list+0x2fb/0x472
Jul 24 02:05:10 server01 kernel: [<ffffffff810cbcbe>]
shrink_inactive_list+0x394/0x675
Jul 24 02:05:10 server01 kernel: [<ffffffff810cc2f7>] shrink_zone+0x358/0x40c
Jul 24 02:05:10 server01 kernel: [<ffffffff8106bbd4>] ? ktime_get_ts+0xad/0xba
Jul 24 02:05:10 server01 kernel: [<ffffffff810cc5b9>]
do_try_to_free_pages+0x20e/0x381
Jul 24 02:05:10 server01 kernel: [<ffffffff810cc8ce>]
try_to_free_pages+0x6a/0x6c
Jul 24 02:05:10 server01 kernel: [<ffffffff810ca7ae>] ?
isolate_pages_global+0x0/0x1f2
Jul 24 02:05:10 server01 kernel: [<ffffffff810c6bc1>]
__alloc_pages_nodemask+0x3e6/0x630
Jul 24 02:05:10 server01 kernel: [<ffffffff810ecfd0>]
alloc_pages_current+0x90/0x99
Jul 24 02:05:10 server01 kernel: [<ffffffff810c5d00>] __get_free_pages+0x9/0x46
Jul 24 02:05:10 server01 kernel: [<ffffffff810492b1>] copy_process+0xd4/0x1299
Jul 24 02:05:10 server01 kernel: [<ffffffff8104a5dc>] do_fork+0x166/0x362
Jul 24 02:05:10 server01 kernel: [<ffffffff810ff570>] ? fd_install+0x31/0x5e
Jul 24 02:05:10 server01 kernel: [<ffffffff81109057>] ? path_put+0x1d/0x22
Jul 24 02:05:10 server01 kernel: [<ffffffff81010c91>] sys_clone+0x23/0x25
Jul 24 02:05:10 server01 kernel: [<ffffffff81009e23>] stub_clone+0x13/0x20
Jul 24 02:05:10 server01 kernel: [<ffffffff81009b02>] ?
system_call_fastpath+0x16/0x1b
