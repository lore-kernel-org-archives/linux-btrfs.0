From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: how can I copy files bigger than ~32 GB when using compress-force?
Date: Tue, 12 Oct 2010 13:12:37 +0200
Message-ID: <4CB442A5.20406@wpkg.org>
References: <4CAA4A34.80701@wpkg.org> <20101004222837.GD9759@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101004222837.GD9759@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 05.10.2010 00:28, Chris Mason wrote:

>>> Does it happen with any 32gb file that doesn't compress well?
>>
>> The 220 GB qcow2 file was basically uncompressible (backuppc archive
>> full of bzip2-compressed files).
> 
> Ok, I think I know what is happening here, they all lead to the same
> chunk of code.  I'll be able to reproduce this locally.

FYI, qemu/kvm doesn't seem to like its files located on btrfs mounted with compress-force.

I have a filesystem mounted with noatime,compress-force, where I created a 100GB sparse file.
There, I wanted to install a Linux distribution - however, the whole qemu-kvm process hanged with these entries being repeated over and over.
It's not possible to kill the qemu-kvm process (even with kill -9) etc.


[103678.068429] INFO: task qemu-kvm:18722 blocked for more than 120 seconds.
[103678.068434] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[103678.068439] qemu-kvm      D 00000001062a02ba     0 18722  18607 0x00000000
[103678.068446]  ffff88008d80bb38 0000000000000082 ffff880000000000 00000000000148c0
[103678.068453]  ffff88008725db00 00000000000148c0 ffff88008d80bfd8 00000000000148c0
[103678.068459]  ffff88008d80a000 00000000000148c0 ffff88008725dea8 00000000000148c0
[103678.068466] Call Trace:
[103678.068490]  [<ffffffffa06a3ee5>] btrfs_start_ordered_extent+0x75/0xc0 [btrfs]
[103678.068499]  [<ffffffff8107e5e0>] ? autoremove_wake_function+0x0/0x40
[103678.068517]  [<ffffffffa06a44a1>] btrfs_wait_ordered_range+0xc1/0x160 [btrfs]
[103678.068535]  [<ffffffffa0695922>] btrfs_file_aio_write+0x542/0x9a0 [btrfs]
[103678.068542]  [<ffffffff8108f562>] ? futex_wait_queue_me+0xc2/0x100
[103678.068549]  [<ffffffff81082462>] ? hrtimer_cancel+0x22/0x30
[103678.068568]  [<ffffffffa06953e0>] ? btrfs_file_aio_write+0x0/0x9a0 [btrfs]
[103678.068576]  [<ffffffff81144533>] do_sync_readv_writev+0xd3/0x110
[103678.068583]  [<ffffffff81091db9>] ? do_futex+0x109/0xb00
[103678.068590]  [<ffffffff811d9789>] ? security_file_permission+0x29/0xa0
[103678.068597]  [<ffffffff811447f4>] do_readv_writev+0xd4/0x1f0
[103678.068603]  [<ffffffff810714ef>] ? kill_pid_info+0x3f/0x60
[103678.068610]  [<ffffffff81144958>] vfs_writev+0x48/0x60
[103678.068615]  [<ffffffff81144c92>] sys_pwritev+0xa2/0xc0
[103678.068623]  [<ffffffff8100af82>] system_call_fastpath+0x16/0x1b


-- 
Tomasz Chmielewski
http://wpkg.org
