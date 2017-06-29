Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:53572 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751518AbdF2BCT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Jun 2017 21:02:19 -0400
Date: Thu, 29 Jun 2017 03:02:11 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Nick Terrell <terrelln@fb.com>
Cc: "dsterba@suse.cz" <dsterba@suse.cz>, Kernel Team <Kernel-team@fb.com>,
        Chris Mason <clm@fb.com>, Yann Collet <cyan@fb.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib/zstd: use div_u64() to let it build on 32-bit
Message-ID: <20170629010210.yfmumrhdcu3ssmwz@angband.pl>
References: <20170626121230.GF2866@twin.jikos.cz>
 <20170627041823.1300-1-kilobyte@angband.pl>
 <7DDA5748-8FAB-497A-9EA3-9DEA27158C61@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <7DDA5748-8FAB-497A-9EA3-9DEA27158C61@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 27, 2017 at 05:27:51AM +0000, Nick Terrell wrote:
> Adam, I’ve applied the same patch in my tree. I’ll send out the update [1]
> once it's reviewed, since I also reduced the stack usage of functions
> using over 1 KB of stack space.
> 
> I have userland tests set up mocking the linux kernel headers, and tested
> 32-bit mode there, but neglected to test the kernel on a 32-bit VM, which
> I’ve now corrected. Thanks for testing the patch on your ARM machine!

Is there a version I should be testing?

I got a bunch of those:
[10170.448783] kworker/u8:6: page allocation stalls for 60720ms, order:0, mode:0x14000c2(GFP_KERNEL|__GFP_HIGHMEM), nodemask=(null)
[10170.448819] kworker/u8:6 cpuset=/ mems_allowed=0
[10170.448842] CPU: 3 PID: 13430 Comm: kworker/u8:6 Not tainted 4.12.0-rc7-00034-gdff47ed160bb #1
[10170.448846] Hardware name: SAMSUNG EXYNOS (Flattened Device Tree)
[10170.448872] Workqueue: btrfs-endio btrfs_endio_helper
[10170.448910] [<c010de1c>] (unwind_backtrace) from [<c010adb8>] (show_stack+0x10/0x14)
[10170.448925] [<c010adb8>] (show_stack) from [<c0442b00>] (dump_stack+0x78/0x8c)
[10170.448942] [<c0442b00>] (dump_stack) from [<c01b0178>] (warn_alloc+0xc0/0x170)
[10170.448952] [<c01b0178>] (warn_alloc) from [<c01b0c3c>] (__alloc_pages_nodemask+0x97c/0xe30)
[10170.448964] [<c01b0c3c>] (__alloc_pages_nodemask) from [<c01e217c>] (__vmalloc_node_range+0x144/0x27c)
[10170.448976] [<c01e217c>] (__vmalloc_node_range) from [<c01e2550>] (__vmalloc_node.constprop.10+0x48/0x50)
[10170.448982] [<c01e2550>] (__vmalloc_node.constprop.10) from [<c01e25ec>] (vmalloc+0x2c/0x34)
[10170.448990] [<c01e25ec>] (vmalloc) from [<c038f7cc>] (zstd_alloc_workspace+0x6c/0xb8)
[10170.448997] [<c038f7cc>] (zstd_alloc_workspace) from [<c038fcb8>] (find_workspace+0x120/0x1f4)
[10170.449002] [<c038fcb8>] (find_workspace) from [<c038ff60>] (end_compressed_bio_read+0x1d4/0x3b0)
[10170.449016] [<c038ff60>] (end_compressed_bio_read) from [<c0130e14>] (process_one_work+0x1d8/0x3f0)
[10170.449026] [<c0130e14>] (process_one_work) from [<c0131a18>] (worker_thread+0x38/0x558)
[10170.449035] [<c0131a18>] (worker_thread) from [<c0136854>] (kthread+0x124/0x154)
[10170.449042] [<c0136854>] (kthread) from [<c01076f8>] (ret_from_fork+0x14/0x3c)

which never happened with compress=lzo, and a 2GB RAM machine that runs 4
threads of various builds runs into memory pressure quite often.  On the
other hand, I used 4.11 for lzo so this needs more testing before I can
blame the zstd code.

Also, I had network problems all day today so the machine was mostly idle
instead of doing further tests -- not quite going to pull sources to build
over a phone connection.

I'm on linus:4.12-rc7 with only a handful of btrfs patches (v3 of Qu's chunk
check, some misc crap) -- I guess I should use at least btrfs-for-4.13.  Or
would you prefer full-blown next?


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
