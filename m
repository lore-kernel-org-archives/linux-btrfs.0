Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:47453 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3F0PB2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Jun 2013 11:01:28 -0400
Received: by mail-bk0-f41.google.com with SMTP id jc3so360772bkc.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jun 2013 08:01:26 -0700 (PDT)
Message-ID: <51CC53BD.20808@gmail.com>
Date: Thu, 27 Jun 2013 17:01:17 +0200
From: =?ISO-8859-1?Q?St=E9phane_Mutz?= <stephane.mutz@gmail.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Problem with btrfsck / couurpted filesystem
References: <51CC4419.6030108@gmail.com> <20130627135842.GQ4288@localhost.localdomain> <51CC4AF1.2090209@gmail.com> <20130627143355.GR4288@localhost.localdomain>
In-Reply-To: <20130627143355.GR4288@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks a lot for the support.

The fs metadata allocation was full. I did the balance operation
and things seem to be back to normal.

It is a bit confusing and hard to predict when the fs is close to running
out of space on one of its pool. I still had 60GB+ free data space when
it happened.

The only thing I found in dmesg is:
Jun 27 16:33:56 lgin0001 kernel: [ 9225.057991] INFO: task
btrfs-transacti:9832 blocked for more than 120 seconds.
Jun 27 16:33:56 lgin0001 kernel: [ 9225.057995] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jun 27 16:33:56 lgin0001 kernel: [ 9225.057998] btrfs-transacti D
ffff8806172939c0     0  9832      2 0x00000000
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058003]  ffff8803b68a3d90
0000000000000046 ffff88041b3e5c00 ffff8803b68a3fd8
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058008]  ffff8803b68a3fd8
ffff8803b68a3fd8 ffff88060d470000 ffff88041b3e5c00
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058012]  ffff8803b68a3da0
ffff8802e6d04000 ffff88020a8f2d20 ffff88020a8f2c00
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058017] Call Trace:
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058026]  [<ffffffff81681259>]
schedule+0x29/0x70
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058061]  [<ffffffffa013956d>]
wait_current_trans.isra.25+0x9d/0x100 [btrfs]
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058067]  [<ffffffff81076920>] ?
finish_wait+0x80/0x80
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058086]  [<ffffffffa013acb0>]
start_transaction+0x1f0/0x300 [btrfs]
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058092]  [<ffffffff810620e0>] ?
usleep_range+0x50/0x50
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058112]  [<ffffffffa013ae15>]
btrfs_join_transaction+0x15/0x20 [btrfs]
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058130]  [<ffffffffa0133047>]
transaction_kthread+0x147/0x2d0 [btrfs]
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058148]  [<ffffffffa0132f00>] ?
btree_readpage_end_io_hook+0x290/0x290 [btrfs]
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058152]  [<ffffffff81075f83>]
kthread+0x93/0xa0
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058157]  [<ffffffff8168b724>]
kernel_thread_helper+0x4/0x10
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058161]  [<ffffffff81075ef0>] ?
kthread_freezable_should_stop+0x70/0x70
Jun 27 16:33:56 lgin0001 kernel: [ 9225.058164]  [<ffffffff8168b720>] ?
gs_change+0x13/0x13

and logs about relocating block groups that I believe are linked to the
balance operation.

Regards, Stéphane.

Le 27/06/2013 16:33, Josef Bacik a écrit :
> On Thu, Jun 27, 2013 at 04:23:45PM +0200, Stéphane Mutz wrote:
>> Hi,
>>
>> I've built the GIT tools and run btrfsck (without options) following the
>> wiki page.
>> I got the following log:
>> Checking filesystem on /dev/VG_NL-SAS/LV_snap
>> UUID: de300fd0-1251-4767-9d80-84ce7ebfba9a
>> checking extents
>> checking free space cache
>> free space inode generation (0) did not match free space cache
>> generation (16583)
>> free space inode generation (0) did not match free space cache
>> generation (16579)
>> checking fs roots
>> checking csums
>> checking root refs
>> found 120489896006 bytes used err is 0
>> total csum bytes: 380818020
>> total tree bytes: 10396295168
>> total fs tree bytes: 9423839232
>> total extent tree bytes: 473616384
>> btree space waste bytes: 1923163802
>> file data blocks allocated: 455172272128
>>  referenced 564086325248
>> Btrfs v0.20-rc1-335-gf00dd83
>>
>> It does not report any extends error.
>> Can I consider all is fine now?
>>
> Yup.  If you still have problems its likely just a kernel bug and not a
> corruption problem.  And if that's the case dmesg would be nice so we can see
> whats going on.  Thanks,
>
> Josef

