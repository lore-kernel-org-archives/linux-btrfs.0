Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:33063 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbcHFU2d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Aug 2016 16:28:33 -0400
Received: by mail-yw0-f194.google.com with SMTP id z8so23071482ywa.0
        for <linux-btrfs@vger.kernel.org>; Sat, 06 Aug 2016 13:28:33 -0700 (PDT)
MIME-Version: 1.0
From: ican realizeum <icanrealizeum@gmail.com>
Date: Sat, 6 Aug 2016 23:27:52 +0300
Message-ID: <CAFad2c0+wi5U9Ysx_x0vOOt76z4MKZs=LpmAsdq1RT_eF-WGVQ@mail.gmail.com>
Subject: umount high CPU usage and takes much time, due to freeing pagecache pages
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

tried to send this but forgot to set Gmail's Plaintext Mode, so it bounced back.
meanwhile I created this bug report:
https://bugzilla.kernel.org/show_bug.cgi?id=151621
--
Hello.
During unmounting(umount command, umount2 syscall), I've noticed that it
takes a few seconds(sometimes up to 127 seconds) for "Unmounting /oldroot"
to finish. During which 1 core is under 100% CPU usage.
It looks like this happens during cleanup_mnt which is in kernel's
fs/namespace.c
and more specifically during deactivate_super(mnt->mnt.mnt_sb);

I did a sysrq+c to crash while this was happening and this is the
screenshot of the stacktrace: https://i.imgur.com/tdteOjB.jpg

What I've also noticed that Sysrq+m to show memory info shows the about 2
million "total pagecache pages" which decrease as time passes while
unmounting is doing this heavy work(of freeing the pages - my guess) until
it gets to about 771 when it finishes.

This started happening maybe 6 or more months ago, or maybe it was
something that I did(other than update kernel to latest git all the time),
but it didn't use to hang at all during umount. Now it's just taking a lot
of time stalling apparently taking its time to free each pagecache - my
guess. It doesn't seem to be flushing anything because there's no SSD led
blinking and also plenty of sync commands were issued beforehand (and
rootfs / is also in remount,ro  if that even matters).

The amount of time that it hangs depends on the uptime(and/or maybe on the
amount that was written during that uptime) - it's now apparent to me that
the more pagecache pages there are, the more time is spent during umounting
the btrfs partition.

I remember umount-ing btrfs filesystems while the system was up(so not
during shutdown) and I think they might've even been mounted ro only but
the stalling and hight CPU usage was present even then. Or my memory fails
me(about the ro part!)

Some examples of right now "pagecache pages" via echo m | sudo
tee /proc/sysrq-trigger
then checking dmesg:

[  598.226377] 288309 total pagecache pages
[ 1463.371632] 294881 total pagecache pages
[ 2050.372096] 338460 total pagecache pages

These increase a lot in time(depending on how much I write? my guess - but
regardless of how much I execute "sync")
When there are over 2 million, it takes like 2 minutes to unmount, so
that's how extra long I've to wait for a reboot/shutdown to complete.

Thanks.

Using kernel:
Linux myzee 4.7.0-ga157b3a #7 SMP PREEMPT Sat Aug 6 15:22:34 EEST 2016
x86_64 GNU/Linux

I've tried commit=300 and commit=3 in fstab, no change. I've tried many
other things I can't remember:D

I can try patches, no problem. Please? ;-)
Thanks my friends.
