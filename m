Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35086 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbbD3NTz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Apr 2015 09:19:55 -0400
Received: by igbyr2 with SMTP id yr2so12647405igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 30 Apr 2015 06:19:54 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <554213A2.6050607@phunq.net>
References: <8f886f13-6550-4322-95be-93244ae61045@phunq.net>
	<20150430014616.GZ15810@dastard>
	<81488fcb-b5d5-4761-b8ae-936dce9c1f89@phunq.net>
	<55420EAC.5040900@suse.com>
	<554213A2.6050607@phunq.net>
Date: Thu, 30 Apr 2015 14:19:54 +0100
Message-ID: <CAL3q7H5pYi97Z65+5tipjZs+1EfwNZhMXo+bYiAy8xO+5T5x5Q@mail.gmail.com>
Subject: Re: Tux3 Report: How fast can we fsync?
From: Filipe David Manana <fdmanana@gmail.com>
To: Daniel Phillips <daniel@phunq.net>
Cc: Filipe Manana <fdmanana@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 30, 2015 at 12:36 PM, Daniel Phillips <daniel@phunq.net> wrote:
> On 04/30/2015 04:14 AM, Filipe Manana wrote:
>>
>> On 04/30/2015 11:28 AM, Daniel Phillips wrote:
>>> It looks like Btrfs hit a bug, not a huge surprise. Btrfs hit an assert
>>> for me earlier this evening. It is rare but it happens.
>>
>> Hi Daniel,
>>
>> Would you mind reporting (to linux-btrfs@vger.kernel.org) the
>> bug/assertion you hit during your tests with btrfs?
>
> Kernel 3.19.0 under KVM with BTRFS mounted on a file in /tmp, see
> the KVM command below. I believe I was running the 10,000 task test
> using the "sync" program below: "syncs foo 10 10000".
>
>     346 ------------[ cut here ]------------
>     347 kernel BUG at fs/btrfs/extent_io.c:4548!
>     348 invalid opcode: 0000 [#1] PREEMPT SMP
>     349 Modules linked in:
>     350 CPU: 2 PID: 5754 Comm: sync6 Not tainted 3.19.0-56544-g65cf1a5 #756
>     351 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
>     352 task: ec3c0ea0 ti: ec3ea000 task.ti: ec3ea000
>     353 EIP: 0060:[<c1301a30>] EFLAGS: 00010202 CPU: 2
>     354 EIP is at btrfs_release_extent_buffer_page+0xf0/0x100
>     355 EAX: 00000001 EBX: f47198f0 ECX: 00000000 EDX: 00000001
>     356 ESI: f47198f0 EDI: f61f1808 EBP: ec3ebbac ESP: ec3ebb9c
>     357  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
>     358 CR0: 8005003b CR2: b756a356 CR3: 2c3ce000 CR4: 000006d0
>     359 Stack:
>     360  00000005 f47198f0 f61f1000 f61f1808 ec3ebbc0 c1301a7f f47198f0 00000000
>     361  f6a3d940 ec3ebbcc c1301ee5 d9a6c770 ec3ebbdc c12b436d fff92000 da136b20
>     362  ec3ebc74 c12e42b6 00000c00 00000000 00000000 00001000 00000000 00000000
>     363 Call Trace:
>     364  [<c1301a7f>] release_extent_buffer+0x3f/0xb0
>     365  [<c1301ee5>] free_extent_buffer+0x45/0x80
>     366  [<c12b436d>] btrfs_release_path+0x2d/0x90
>     367  [<c12e42b6>] cow_file_range_inline+0x466/0x600
>     368  [<c12e495e>] cow_file_range+0x50e/0x640
>     369  [<c12fdde1>] ? find_lock_delalloc_range.constprop.42+0x2e1/0x320
>     370  [<c12e5af9>] run_delalloc_range+0x419/0x450
>     371  [<c12fdf6b>] writepage_delalloc.isra.32+0x14b/0x1d0
>     372  [<c12ff20e>] __extent_writepage+0xde/0x2b0
>     373  [<c11208fd>] ? find_get_pages_tag+0xad/0x120
>     374  [<c130135c>] extent_writepages+0x29c/0x350
>     375  [<c12e1530>] ? btrfs_direct_IO+0x300/0x300
>     376  [<c12e009f>] btrfs_writepages+0x1f/0x30
>     377  [<c11299e5>] do_writepages+0x15/0x40
>     378  [<c112199f>] __filemap_fdatawrite_range+0x4f/0x60
>     379  [<c1121aa2>] filemap_fdatawrite_range+0x22/0x30
>     380  [<c12f4768>] btrfs_fdatawrite_range+0x28/0x70
>     381  [<c12f47d1>] start_ordered_ops+0x21/0x30
>     382  [<c12f4823>] btrfs_sync_file+0x43/0x370
>     383  [<c115c3e5>] ? vfs_write+0x135/0x1c0
>     384  [<c12f47e0>] ? start_ordered_ops+0x30/0x30
>     385  [<c1183e27>] do_fsync+0x47/0x70
>     386  [<c118403d>] SyS_fsync+0xd/0x10
>     387  [<c15bd8ae>] syscall_call+0x7/0x7
>     388 Code: 8b 03 f6 c4 20 75 26 f0 80 63 01 f7 c7 43 1c 00 00 00 00 89 d8 e8 61 94 e2 ff eb c3 8d
> b4 26 00 00 00 00 83 c4 04 5b 5e 5f 5d c3 <0f> 0b 0f 0b     388 0f 0b 0f 0b 90 8d b4 26 00 00 00 00
> 55 89 e5 57 56
>     389 EIP: [<c1301a30>] btrfs_release_extent_buffer_page+0xf0/0x100 SS:ESP 0068:ec3ebb9c
>     390 ---[ end trace 12b9bbe75d9541a3 ]---
>
> KVM command:
>
> mkfs.btrfs -f /tmp/disk.img && kvm -kernel /src/linux-tux3/arch/x86/boot/bzImage -append
> "root=/dev/sda1 console=ttyS0 console=tty0 oops=panic tux3.tux3_trace=0" -serial file:serial.txt
> -hda /more/kvm/hdd.img -hdb /tmp/disk.img -net nic -net user,hostfwd=tcp::1234-:22 -smp 4 -m 2000

There's a very recent patch to fix that issue:
https://patchwork.kernel.org/patch/6261421/
It's not really specific to fsync.

Thanks for reporting it.

>
> Source code:
>
> /*
>  * syncs.c
>  *
>  * D.R. Phillips, 2015
>  *
>  * To build: c99 -Wall syncs.c -o syncs
>  * To run: ./syncs [<filename> [<syncs> [<tasks>]]]
>  */
>
> #include <unistd.h>
> #include <stdlib.h>
> #include <stdio.h>
> #include <fcntl.h>
> #include <sys/wait.h>
> #include <errno.h>
> #include <sys/stat.h>
>
> char text[1024] = { "hello world!\n" };
>
> int main(int argc, const char *argv[]) {
>         const char *basename = argc < 1 ? "foo" : argv[1];
>         char name[100];
>         int steps = argc < 3 ? 1 : atoi(argv[2]);
>         int tasks = argc < 4 ? 1 : atoi(argv[3]);
>         int err, fd;
>
>         for (int t = 0; t < tasks; t++) {
>                 snprintf(name, sizeof name, "%s%i", basename, t);
>                 if (!fork())
>                         goto child;
>         }
>         for (int t = 0; t < tasks; t++)
>                 wait(&err);
>         return 0;
>
> child:
>         fd = creat(name, S_IRWXU);
>         for (int i = 0; i < steps; i++) {
>                 write(fd, text, sizeof text);
>                 fsync(fd);
>         }
>         return 0;
> }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
