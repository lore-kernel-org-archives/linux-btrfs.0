Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:36698 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751364AbcLDSwm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Dec 2016 13:52:42 -0500
Received: by mail-yw0-f172.google.com with SMTP id a10so243074185ywa.3
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Dec 2016 10:52:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3405186.JXS0fWUK5s@thetick>
References: <1776088.42rHLKPlSp@thetick> <4615776.dvopQOigxY@thetick>
 <CAJCQCtRUO1pByA3HXjbKRNVFmC9zcFvbLi22hAJS8VLafXnoew@mail.gmail.com> <3405186.JXS0fWUK5s@thetick>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 4 Dec 2016 11:52:40 -0700
Message-ID: <CAJCQCtQsDCxtMujcutk=+fJauzfoKaE+GAMRtObPpZ4ukJE2UQ@mail.gmail.com>
Subject: Re: system hangs due to qgroups
To: Marc Joliet <marcec@gmx.de>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 4, 2016 at 9:02 AM, Marc Joliet <marcec@gmx.de> wrote:

>
> Also, now the file system fails with the BUG I mentioned, see here:
>
> [Sun Dec  4 12:27:07 2016] BUG: unable to handle kernel paging request at
> fffffffffffffe10
> [Sun Dec  4 12:27:07 2016] IP: [<ffffffff8131226f>]
> qgroup_fix_relocated_data_extents+0x1f/0x2a0
> [Sun Dec  4 12:27:07 2016] PGD 1c07067 PUD 1c09067 PMD 0
> [Sun Dec  4 12:27:07 2016] Oops: 0000 [#1] PREEMPT SMP
> [Sun Dec  4 12:27:07 2016] Modules linked in: crc32c_intel serio_raw
> [Sun Dec  4 12:27:07 2016] CPU: 0 PID: 370 Comm: mount Not tainted 4.8.11-
> gentoo #1
> [Sun Dec  4 12:27:07 2016] Hardware name: FUJITSU LIFEBOOK A530/FJNBB06, BIOS
> Version 1.19   08/15/2011
> [Sun Dec  4 12:27:07 2016] task: ffff8801b1d90000 task.stack: ffff8801b1268000
> [Sun Dec  4 12:27:07 2016] RIP: 0010:[<ffffffff8131226f>]
> [<ffffffff8131226f>] qgroup_fix_relocated_data_extents+0x1f/0x2a0
> [Sun Dec  4 12:27:07 2016] RSP: 0018:ffff8801b126bcd8  EFLAGS: 00010246
> [Sun Dec  4 12:27:07 2016] RAX: 0000000000000000 RBX: ffff8801b10b3150 RCX:
> 0000000000000000
> [Sun Dec  4 12:27:07 2016] RDX: ffff8801b20f24f0 RSI: ffff8801b2790800 RDI:
> ffff8801b20f2460
> [Sun Dec  4 12:27:07 2016] RBP: ffff8801b10bc000 R08: 0000000000020340 R09:
> ffff8801b20f2460
> [Sun Dec  4 12:27:07 2016] R10: ffff8801b48b7300 R11: ffffea0005dd0ac0 R12:
> ffff8801b126bd70
> [Sun Dec  4 12:27:07 2016] R13: 0000000000000000 R14: ffff8801b2790800 R15:
> 00000000b20f2460
> [Sun Dec  4 12:27:07 2016] FS:  00007f97a7846780(0000)
> GS:ffff8801bbc00000(0000) knlGS:0000000000000000
> [Sun Dec  4 12:27:07 2016] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [Sun Dec  4 12:27:07 2016] CR2: fffffffffffffe10 CR3: 00000001b12ae000 CR4:
> 00000000000006f0
> [Sun Dec  4 12:27:07 2016] Stack:
> [Sun Dec  4 12:27:07 2016]  0000000000000801 0000000000000801 ffff8801b20f2460
> ffff8801b4aaa000
> [Sun Dec  4 12:27:07 2016]  0000000000000801 ffff8801b20f2460 ffffffff812c23ed
> ffff8801b1d90000
> [Sun Dec  4 12:27:07 2016]  0000000000000000 00ff8801b126bd18 ffff8801b10b3150
> ffff8801b4aa9800
> [Sun Dec  4 12:27:07 2016] Call Trace:
> [Sun Dec  4 12:27:07 2016]  [<ffffffff812c23ed>] ?
> start_transaction+0x8d/0x4e0
> [Sun Dec  4 12:27:07 2016]  [<ffffffff81317913>] ?
> btrfs_recover_relocation+0x3b3/0x440
> [Sun Dec  4 12:27:07 2016]  [<ffffffff81292b2a>] ? btrfs_remount+0x3ca/0x560
> [Sun Dec  4 12:27:07 2016]  [<ffffffff811bfc04>] ? shrink_dcache_sb+0x54/0x70
> [Sun Dec  4 12:27:07 2016]  [<ffffffff811ad473>] ? do_remount_sb+0x63/0x1d0
> [Sun Dec  4 12:27:07 2016]  [<ffffffff811c9953>] ? do_mount+0x6f3/0xbe0
> [Sun Dec  4 12:27:07 2016]  [<ffffffff811c918f>] ?
> copy_mount_options+0xbf/0x170
> [Sun Dec  4 12:27:07 2016]  [<ffffffff811ca111>] ? SyS_mount+0x61/0xa0
> [Sun Dec  4 12:27:07 2016]  [<ffffffff8169565b>] ?
> entry_SYSCALL_64_fastpath+0x13/0x8f
> [Sun Dec  4 12:27:07 2016] Code: 66 90 66 2e 0f 1f 84 00 00 00 00 00 41 57 41
> 56 41 55 41 54 55 53 48 83 ec 50 48 8b 46 08 4c 8b 6e 10 48 8b a8 f0 01 00 00
> 31 c0 <4d> 8b a5 10 fe ff ff f6 85 80 0c 00 00 01 74 09 80 be b0 05 00
> [Sun Dec  4 12:27:07 2016] RIP  [<ffffffff8131226f>]
> qgroup_fix_relocated_data_extents+0x1f/0x2a0
> [Sun Dec  4 12:27:07 2016]  RSP <ffff8801b126bcd8>
> [Sun Dec  4 12:27:07 2016] CR2: fffffffffffffe10
> [Sun Dec  4 12:27:07 2016] ---[ end trace bd51bbcfd10492f7 ]---

I can't parse this. Maybe someone else can. Do you get the same thing,
or a different thing, if you do a normal mount rather than a remount?



> Ah, but what does work is mounting a snapshot, in the sense that mount doesn't
> fail.  However, it seems that the balance still continues, so I'm back at
> square one.

Interesting that mounting a subvolume directly works, seeing as that's
just a bind mount behind the scene. But maybe there's something wrong
in the top level subvolume that's being skipped when mounting a
subvolume directly.

Are you mounting with skip_balance mount option? And how do you know
that it's a balance continuing? What do you get for 'btrfs balance
status' for this volume? Basically I'm asking if you're sure there's a
balance happening. The balance itself is not bad, it's just that it
slows everything down astronomically. That's the main reason why you'd
like to skip it or cancel it. Instead of balancing it might be doing
some sort of cleanup. Either 'top' or 'perf top' might give a clue
what's going on if 'btrfs balance status' doesn't show a balance is
happening, and yet the drive is super busy as if a balance is
happening.

Also, if you boot from alternate media, scrub resuming should not
happen because the progress file for scrub is in /var/lib/btrfs, there
is no metadata on the Btrfs volume itself that indicates it's being
scrubbed or what the progress is.



> Well, btrfs check came back clean.  And as mentioned above, I was able to get
> two images, but with btrfs-progs 4.7.3 (the version in sysrescuecd).  I can
> get different images from the initramfs (which I didn't think of earlier,
> sorry).

'btrfs check' using btrfs-progs 4.8.2 or higher came back clean? That
sounds like a bug. You're having quota related problems (at least it's
a contributing factor) but btrfs check says clean, while the kernel is
getting confused. So either 'btrfs check' is correct that there are no
problems, and there's a kernel bug resulting in confusion; or the
check is missing something, and that's why the kernel is mishandling
it. In either case, there's a kernel bug.

So yeah for sure you'll want a sanitized btrfs-image captured for the
developers to look at; put it somewhere like Google Drive or wherever
they can grab it. And put the URL in this thread, and/or also file a
bug about this problem with the URL to the image included.

Looking at 4.9 there's not many qgroup.c changes, but there's a pile
of other changes, per usual. So even though the problem seems like
it's qgroup related, it might actually be some other problem that then
also triggers qgroup messages.



-- 
Chris Murphy
