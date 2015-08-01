Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:36133 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbbHAOyN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Aug 2015 10:54:13 -0400
Received: by wicgj17 with SMTP id gj17so52103991wic.1
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Aug 2015 07:54:11 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 1 Aug 2015 14:54:11 +0000
Message-ID: <CABozSb+L4iDwALP8=uvTM-CLTnN1otkW8vK0oHKU9UX8j74jWg@mail.gmail.com>
Subject: Filesystem unmountable
From: Cornelius van Rooyen <nexusdk@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good day,

This might be something you are already aware of, but I thought I should
inform someone of what happened to my sytem.

I was running ArchLinux with kernel 4.1.3-1-ARCH #1 SMP PREEMPT x86_64
GNU/Linux and executed btrfs-convert /mnt from an ArchLinux live disk to
convert my ext4 filesystem to btrfs.

The conversion was seemingly successful, but after booting journalctl
--verify reported some corrupt files. I saw on a an online post that I
should try to do a btrfs balance start after converting from ext4, and so I
executed the command and left the laptop to complete the task. The next
morning however I found the system frozen and had to do a hard reset. After
this the filesystem was unmountable.

The initial boot after the hard reset left me in an emergency shell at
which point I tried to mount the system and the shell stopped responding.
Booting a live disk and running btrfsck exited with a segmentation fault.
Attempts to mount the filesystem also exited with a segmentation fault or
the shell seemed to be waiting for the command to complete for very long
and did not respond to CTRL-C.

I know nothing of kernels or filesystem drivers and I hope I am not
waisting any body's time with something that was probably my own fault. I
have since reinstalled my OS and in hindsight I should probably have
attempted to save some of the kernel log files.

Kind regards,
Neels van Rooyen
