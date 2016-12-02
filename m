Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:36824 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757961AbcLBTH5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 2 Dec 2016 14:07:57 -0500
Received: by mail-qt0-f173.google.com with SMTP id w33so260652432qtc.3
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Dec 2016 11:07:56 -0800 (PST)
MIME-Version: 1.0
From: Blake Lewis <blake@portworx.com>
Date: Fri, 2 Dec 2016 11:07:54 -0800
Message-ID: <CAFuzrVeWdz2Lup-x1OiJjVcknQRysiiZVYG1doxNdGKiHB+Jaw@mail.gmail.com>
Subject: missing checksums on reboot
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, all, this is my first posting to the mailing list.  I am a
long-time file system guy who is just starting to take a serious
interest in btrfs.

My company's product uses btrfs for its backing storage.  We
maintain a log file to let us synchronize after reboots.  In
testing, we find that when the system panics and we read the
file after coming back up, we intermittently (but fairly often)
get "no csum found for inode X start Y" messages and from our
point of view, the log is corrupt.

Here are a few pertinent details:

1) When we see this, the device is always an SSD.
2) We reproduce it easily with 3.10 kernels but we have not
been able to reproduce it in 4.8.
3) The log file is opened with O_SYNC|O_DIRECT; its size is 128MB
and we are appending to it.
4) No other activity in the file system except a generated sequential
write workload
5) Panics are induced with "echo c > /proc/sysrq-trigger".

We filed a bug (https://bugzilla.kernel.org/show_bug.cgi?id=188051)
but I wanted to see if anyone here recognized these symptoms and
could point me in the right direction, especially since the problem
seems to have gone away in more recent releases.  We can't realistically
make our customers run newer kernels, so I want to understand the
nature of the bug and whether it might be able to fix it in the older
code.

Thanks for any guidance.

Blake
