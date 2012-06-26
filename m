Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54214 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab2FZHjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jun 2012 03:39:07 -0400
Received: by obbuo13 with SMTP id uo13so7656503obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jun 2012 00:39:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120625192632.GF7404@localhost.localdomain>
References: <CAHf9xvafQugP2c_3_rxNAn55TgF_GiCM7udNS6yLEqVfPD1_wg@mail.gmail.com>
	<20120625192632.GF7404@localhost.localdomain>
Date: Tue, 26 Jun 2012 10:39:06 +0300
Message-ID: <CAHf9xvYGWvOCCUUte8Y29RG+G0aXAbKkE3up7r=2SDRLCRQKwg@mail.gmail.com>
Subject: Re: fio reports data corruption with btrfs
From: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,
Mount options were noatime, nodatacow.
So you say that fio might have received ENOSPC, but didn't abort the test?

I will compile your branch and let you know.

I did not see any error messages from the kernel, except from:
Jun 25 10:04:28 vc kernel: [  436.730890] btrfs: setting nodatacow
Jun 25 10:04:28 vc kernel: [  436.744139] btrfs: no dev_stats entry
found for device /dev/sdb2 (devid 1) (OK on first mount after mkfs)
Jun 25 10:13:12 vc kernel: [  960.844149] INFO: task
flush-btrfs-2:3349 blocked for more than 120 seconds.
Jun 25 10:13:12 vc kernel: [  960.846600] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 25 10:13:12 vc kernel: [  960.847507] flush-btrfs-2   D
ffffffff8180ca80     0  3349      2 0x00000000
Jun 25 10:13:12 vc kernel: [  960.847515]  ffff8801186337a0
0000000000000046 0000000013e332ba ffffffff81c1d780
Jun 25 10:13:12 vc kernel: [  960.847520]  ffff880118633fd8
ffff880118633fd8 ffff880118633fd8 0000000000013840
Jun 25 10:13:12 vc kernel: [  960.847525]  ffffffff81c13020
ffff8801176f5b80 ffff880118633790 ffff88011fc140e8
Jun 25 10:13:12 vc kernel: [  960.847530] Call Trace:
Jun 25 10:13:12 vc kernel: [  960.847554]  [<ffffffff8166c239>]
schedule+0x29/0x70
Jun 25 10:13:12 vc kernel: [  960.847558]  [<ffffffff8166c30f>]
io_schedule+0x8f/0xd0
Jun 25 10:13:12 vc kernel: [  960.847574]  [<ffffffff812f0a3f>]
get_request_wait+0xef/0x240
Jun 25 10:13:12 vc kernel: [  960.847587]  [<ffffffff81073a80>] ?
add_wait_queue+0x60/0x60
Jun 25 10:13:12 vc kernel: [  960.847592]  [<ffffffff812f191f>]
blk_queue_bio+0x7f/0x3a0
Jun 25 10:13:12 vc kernel: [  960.847596]  [<ffffffff812ee784>]
generic_make_request.part.50+0x74/0xb0
Jun 25 10:13:12 vc kernel: [  960.847600]  [<ffffffff812eef18>]
generic_make_request+0x68/0x70
Jun 25 10:13:12 vc kernel: [  960.847603]  [<ffffffff812eefa7>]
submit_bio+0x87/0x110
Jun 25 10:13:12 vc kernel: [  960.847649]  [<ffffffffa006f8c7>]
btrfs_map_bio+0x167/0x210 [btrfs]
Jun 25 10:13:12 vc kernel: [  960.847669]  [<ffffffffa00428ad>]
btrfs_submit_bio_hook+0x7d/0x140 [btrfs]
Jun 25 10:13:12 vc kernel: [  960.847691]  [<ffffffffa00609fa>]
submit_one_bio+0x6a/0xa0 [btrfs]
Jun 25 10:13:12 vc kernel: [  960.847713]  [<ffffffffa0061059>]
flush_epd_write_bio+0x39/0x50 [btrfs]
Jun 25 10:13:12 vc kernel: [  960.847734]  [<ffffffffa00662c0>]
extent_writepages+0x50/0x60 [btrfs]
Jun 25 10:13:12 vc kernel: [  960.847754]  [<ffffffffa0045ba0>] ?
btrfs_submit_direct+0x1e0/0x1e0 [btrfs]
Jun 25 10:13:12 vc kernel: [  960.847759]  [<ffffffff81073654>] ?
bit_waitqueue+0x14/0xc0
Jun 25 10:13:12 vc kernel: [  960.847779]  [<ffffffffa00436d8>]
btrfs_writepages+0x28/0x30 [btrfs]
Jun 25 10:13:12 vc kernel: [  960.847793]  [<ffffffff81128191>]
do_writepages+0x21/0x40
Jun 25 10:13:12 vc kernel: [  960.847805]  [<ffffffff811a5462>]
writeback_single_inode+0x112/0x380
Jun 25 10:13:12 vc kernel: [  960.847809]  [<ffffffff811a5886>]
writeback_sb_inodes+0x1b6/0x270
Jun 25 10:13:12 vc kernel: [  960.847813]  [<ffffffff811a59de>]
__writeback_inodes_wb+0x9e/0xd0
Jun 25 10:13:12 vc kernel: [  960.847816]  [<ffffffff811a5c9b>]
wb_writeback+0x28b/0x340
Jun 25 10:13:12 vc kernel: [  960.847823]  [<ffffffff810125c7>] ?
__switch_to+0x137/0x410
Jun 25 10:13:12 vc kernel: [  960.847833]  [<ffffffff81197d02>] ?
get_nr_dirty_inodes+0x52/0x80
Jun 25 10:13:12 vc kernel: [  960.847837]  [<ffffffff811a5def>]
wb_check_old_data_flush+0x9f/0xb0
Jun 25 10:13:12 vc kernel: [  960.847842]  [<ffffffff811a72c9>]
wb_do_writeback+0x149/0x1d0
Jun 25 10:13:12 vc kernel: [  960.847848]  [<ffffffff8105f610>] ?
usleep_range+0x50/0x50
Jun 25 10:13:12 vc kernel: [  960.847852]  [<ffffffff811a73db>]
bdi_writeback_thread+0x8b/0x290
Jun 25 10:13:12 vc kernel: [  960.847855]  [<ffffffff811a7350>] ?
wb_do_writeback+0x1d0/0x1d0
Jun 25 10:13:12 vc kernel: [  960.847860]  [<ffffffff81072fe3>]
kthread+0x93/0xa0
Jun 25 10:13:12 vc kernel: [  960.847868]  [<ffffffff81676be4>]
kernel_thread_helper+0x4/0x10
Jun 25 10:13:12 vc kernel: [  960.847873]  [<ffffffff81072f50>] ?
kthread_freezable_should_stop+0x70/0x70
Jun 25 10:13:12 vc kernel: [  960.847877]  [<ffffffff81676be0>] ?
gs_change+0x13/0x13

Thanks,
Alex.



On Mon, Jun 25, 2012 at 10:26 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Mon, Jun 25, 2012 at 12:30:34PM -0600, Alex Lyakas wrote:
>> Greetings everybody,
>>
>> I am running a fio test on btrfs compiled from
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git,
>> up to commit:
>> cb77fcd88569cd2b7b25ecd4086ea932a53be9b3 Btrfs: delay iput with async extents
>> including this commit.
>>
>> Below is a fio configuration file, and later fio textual output.
>> Here:
>> https://docs.google.com/folder/d/0B1AuaIB8xZtbNTRuSW1zVGozWFE/edit
>> are "expected" vs "received" mismatch reports. Strangely, when I read
>> the mismatched block from the file reported as corrupted by fio, I
>> receive data different both from "expected" and "received" blocks that
>> fio reports. I added one such file (job0.1.0.88576.now) to the
>> pastebin as well.
>>
>> If you think that my fio configuration file is faulty, please let me
>> know. fio version is 1.59. The idea is to run 10 io processes in
>> parallel.
>>
>
> So we think it may be enospc, so try btrfs-next
>
> git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git
>
> which has an enospc fix related to creating a crapptone of files.  Let me know
> if that helps.  Thanks,
>
> Josef
