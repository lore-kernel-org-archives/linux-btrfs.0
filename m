Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33280 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbcFKARr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 20:17:47 -0400
Received: by mail-oi0-f54.google.com with SMTP id u201so8809691oie.0
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 17:17:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160610234114.GB11174@onerussian.com>
References: <20160610234114.GB11174@onerussian.com>
Date: Fri, 10 Jun 2016 18:17:46 -0600
Message-ID: <CAJCQCtS1UTBx1-GELqUTbrdcxmncN3bv7X3OjGGrjvzom28m+w@mail.gmail.com>
Subject: Re: recent complete stalls of btrfs (4.6.0-rc4+) -- any advice?
From: Chris Murphy <lists@colorremedies.com>
To: Yaroslav Halchenko <yoh@onerussian.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 10, 2016 at 5:41 PM, Yaroslav Halchenko <yoh@onerussian.com> wrote:
> Dear BTRFS developers,
>
> First of all -- thanks for developing BTRFS!  So far it served really
> well, when others falling (or failing) behind in my initial evaluation
> (http://datalad.org/test_fs_analysis.html).  With btrbk backups are a
> breeze.  But it still does fail completely for me at times
> unfortunately.
>
> I know that I should upgrade the kernel, and I will now...  but I
> thought to share this incident(s) report since those might have been of
> some value.  Running Debian jessie but with manually built kernel.
> btrfs is extensively used for a high meta-data partition (lots of
> symlinks, lots of directories with a single file in them -- heave use of
> git-annex), snapshots are taken regularly etc.
>
> Setup -- btrfs on top of software raids:
>
> # btrfs fi show /mnt/btrfs/
> Label: 'tank'  uuid: b5fe7f5e-3478-4293-a42c-bf9ca26ea724
>         Total devices 4 FS bytes used 21.07TiB
>         devid    2 size 10.92TiB used 5.30TiB path /dev/md10
>         devid    3 size 10.92TiB used 5.30TiB path /dev/md11
>         devid    4 size 10.92TiB used 5.30TiB path /dev/md12
>         devid    5 size 10.92TiB used 5.30TiB path /dev/md13
>
>
> Within last 5 days, the beast has stalled twice by now.  The last signs
> were:
>
> * 20160605 -- kernel kaboomed at btrfs level
>
> smaug login: [3675876.734400] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffffa03d0354
> [3675876.734400]
> [3675876.745680] CPU: 9 PID: 651474 Comm: git Tainted: G        W IO    4.6.0-rc4+ #1
> [3675876.753272] Hardware name: Supermicro X10DRi/X10DRI-T, BIOS 1.0b 09/17/2014
> [3675876.760431]  0000000000000086 000000005e62edd4 ffffffff813098f5 ffffffff817cd080
> [3675876.768104]  ffff880036f23da8 ffffffff811701af ffff881e00000010 ffff880036f23db8
> [3675876.775763]  ffff880036f23d50 000000005e62edd4 ffff880036f23d88 ffffffffa03d0354
> [3675876.783426] Call Trace:
> [3675876.786057]  [<ffffffff813098f5>] ? dump_stack+0x5c/0x77
> [3675876.791575]  [<ffffffff811701af>] ? panic+0xdf/0x226
> [3675876.796812]  [<ffffffffa03d0354>] ? btrfs_add_link+0x384/0x3e0 [btrfs]
> [3675876.803549]  [<ffffffff8107abf7>] ? __stack_chk_fail+0x17/0x30
> [3675876.809610]  [<ffffffffa03d0354>] ? btrfs_add_link+0x384/0x3e0 [btrfs]
> [3675876.816391]  [<ffffffffa03d1273>] ? btrfs_link+0x143/0x220 [btrfs]
> [3675876.822802]  [<ffffffff811fea9f>] ? vfs_link+0x1af/0x280
> [3675876.828331]  [<ffffffff812020ba>] ? SyS_link+0x22a/0x260
> [3675876.833859]  [<ffffffff815ba436>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8
> [3675876.840740] Kernel Offset: disabled
> [3675876.854050] ---[ end Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffffa03d0354
> [3675876.854050]
>
> * 20160610 -- again, different kaboom
>
> [443370.085059] CPU: 10 PID: 1044513 Comm: git-annex Tainted: G        W IO    4.6.0-rc4+ #1
> [443370.093268] Hardware name: Supermicro X10DRi/X10DRI-T, BIOS 1.0b 09/17/2014
> [443370.100356] task: ffff8806c463d0c0 ti: ffff8808f9dc8000 task.ti: ffff8808f9dc8000
> [443370.107953] RIP: 0010:[<ffff88090f67be10>]  [<ffff88090f67be10>] 0xffff88090f67be10
> [443370.115761] RSP: 0018:ffff8808f9dcbe18  EFLAGS: 00010292
> [443370.121187] RAX: ffff88103fd95fc0 RBX: ffff8808f9dcc000 RCX: 0000000000000000
> [443370.128438] RDX: 00000000ffffffff RSI: ffff8806c463d0c0 RDI: ffff88103fd95fc0
> [443370.135693] RBP: ffff8808f9dcbe30 R08: ffff8808f9dc8000 R09: 0000000000000000
> [443370.142940] R10: 000000000000000a R11: 0000000000000000 R12: ffff881035beedc8
> [443370.150184] R13: ffff880ff1106800 R14: ffff88123d6c0000 R15: ffff88123d6c0068
> [443370.157432] FS:  00007f0ab3d83740(0000) GS:ffff88103fd80000(0000) knlGS:0000000000000000
> [443370.165645] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [443370.171512] CR2: ffff88090f67be10 CR3: 0000000cf7516000 CR4: 00000000001406e0
> [443370.178758] Stack:
> [443370.180880]  ffff88069dda93c0 ffffffffa0358700 ffff88069dda93c0 ffff880f00000000
> [443370.188490]  ffff8806c463d0c0 ffffffff810bb560 ffff8808f9dcbe48 ffff8808f9dcbe48
> [443370.196107]  00000000d5ce3509 ffff88069dda93c0 0000000000000001 ffff8806a64835c8
> [443370.203726] Call Trace:
> [443370.206310]  [<ffffffffa0358700>] ? btrfs_commit_transaction+0x350/0xa30 [btrfs]
> [443370.213826]  [<ffffffff810bb560>] ? wait_woken+0x90/0x90
> [443370.219280]  [<ffffffffa036fb6b>] ? btrfs_sync_file+0x2fb/0x3d0 [btrfs]
> [443370.226012]  [<ffffffff81222a48>] ? do_fsync+0x38/0x60
> [443370.231267]  [<ffffffff81222ccf>] ? SyS_fdatasync+0xf/0x20
> [443370.236870]  [<ffffffff815ba436>] ? entry_SYSCALL_64_fastpath+0x1e/0xa8
> [443370.243604] Code: 88 ff ff 21 67 5b 81 ff ff ff ff 00 00 6c 3d 12 88 ff ff dd 77 35 a0 ff ff ff ff 00 00 00 00 00 00 00 00 40 e0 91 4b 08 88 ff ff <60> b5 0b 81 ff ff ff ff f0 fd 61 8a 0c 88 ff ff 18 7c 79 3e 00
> [443370.264107] RIP  [<ffff88090f67be10>] 0xffff88090f67be10
> [443370.271044]  RSP <ffff8808f9dcbe18>
> [443370.276177] CR2: ffff88090f67be10
> [443370.284979] ---[ end trace 2c4b690b49d17ebd ]---
>
> and for the last case here is more details with dmesg showing apparently other tracebacks
> and errors logged before, so might be of help:
>
> http://www.onerussian.com/tmp/dmesg-nonet.20160610.txt
>
> Are those issues something which was fixed since 4.6.0-rc4+ or I should
> be on look out for them to come back?  What other information should I
> provide if I run into them again to help you troubleshoot/fix it?
>
> P.S. Please CC me the replies


4.6.2 is current and it's a lot easier to just use that and see if it
still happens than for someone to track down whether it's been fixed
since a six week old RC.


-- 
Chris Murphy
