Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36809 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbcCMWBG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Mar 2016 18:01:06 -0400
Received: by mail-io0-f172.google.com with SMTP id z76so202764130iof.3
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 15:01:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQt8J697-mABAr+4Wdaf7Kw-sX6yLHwwyLGJ9kJFFG7xw@mail.gmail.com>
References: <CAJCQCtQt8J697-mABAr+4Wdaf7Kw-sX6yLHwwyLGJ9kJFFG7xw@mail.gmail.com>
Date: Sun, 13 Mar 2016 16:01:05 -0600
Message-ID: <CAJCQCtQ_LaxZp1fkxZ+_gpSBcdRY-bhNLar0b2zYGK8AAY1DUg@mail.gmail.com>
Subject: Re: 4.5.0 rc7 balance btrfs/extent-tree.c:7964 btrfs_alloc_tree_block+0x417/0x500
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This didn't make it to the list, probably because of the attachment,
so dmesg is attached to this bug:
https://bugzilla.kernel.org/show_bug.cgi?id=114541


On Sun, Mar 13, 2016 at 3:37 PM, Chris Murphy <lists@colorremedies.com> wrote:
> Today I saw two warnings during a filtered balance, -dusage=50 -musage=50.
>
> [61425.186172]  [<ffffffff813d497f>] dump_stack+0x63/0x84
> [61425.186176]  [<ffffffff810a6142>] warn_slowpath_common+0x82/0xc0
> [61425.186178]  [<ffffffff810a61dc>] warn_slowpath_fmt+0x5c/0x80
> [61425.186183]  [<ffffffff813da662>] ? ___ratelimit+0xb2/0x100
> [61425.186198]  [<ffffffffa05105f7>] btrfs_alloc_tree_block+0x417/0x500 [btrfs]
> [61425.186201]  [<ffffffff810e1db7>] ? update_sd_lb_stats+0x107/0x500
> [61425.186214]  [<ffffffffa04f7022>] btrfs_copy_root+0x102/0x2b0 [btrfs]
> [61425.186232]  [<ffffffffa05709cd>] create_reloc_root+0x19d/0x220 [btrfs]
> [61425.186249]  [<ffffffffa0576b66>] btrfs_init_reloc_root+0x96/0xb0 [btrfs]
> [61425.186264]  [<ffffffffa051fee4>] record_root_in_trans+0xa4/0x100 [btrfs]
> [61425.186279]  [<ffffffffa05216d4>]
> btrfs_record_root_in_trans+0x44/0x70 [btrfs]
> [61425.186293]  [<ffffffffa0522906>] start_transaction+0x96/0x4a0 [btrfs]
> [61425.186308]  [<ffffffffa0522d67>] btrfs_join_transaction+0x17/0x20 [btrfs]
> [61425.186322]  [<ffffffffa0528cec>] btrfs_dirty_inode+0x3c/0xd0 [btrfs]
> [61425.186336]  [<ffffffffa0528dfd>] btrfs_update_time+0x7d/0xb0 [btrfs]
> [61425.186340]  [<ffffffff8125dfdd>] file_update_time+0xbd/0x110
> [61425.186355]  [<ffffffffa05330e9>] btrfs_page_mkwrite+0xc9/0x3f0 [btrfs]
> [61425.186357]  [<ffffffff810de475>] ? put_prev_entity+0x35/0x7f0
> [61425.186361]  [<ffffffff811e63da>] do_page_mkwrite+0x7a/0x120
> [61425.186364]  [<ffffffff811e89f9>] do_wp_page+0x1a9/0x890
> [61425.186367]  [<ffffffff811eb848>] handle_mm_fault+0x818/0x1bd0
> [61425.186369]  [<ffffffff810696c5>] __do_page_fault+0x195/0x400
> [61425.186372]  [<ffffffff81069960>] do_page_fault+0x30/0x80
> [61425.186374]  [<ffffffff81003d19>] ? syscall_return_slowpath+0x79/0xb0
> [61425.186378]  [<ffffffff817cfec8>] page_fault+0x28/0x30
> [61425.186399] ---[ end trace 2c5c3c76646758b9 ]---
>
> There is, since kernel 4.4.x this dump_pagetables message that happens
> every boot, that taints the kernel.
> WARNING: CPU: 0 PID: 1 at arch/x86/mm/dump_pagetables.c:225
> note_page+0x635/0x7e0()
>
> Including entire dmesg as attachment. So far no apparent negative
> consequence, the balance completes normally.


-- 
Chris Murphy
