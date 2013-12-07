Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f180.google.com ([209.85.216.180]:60873 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab3LGKgq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Dec 2013 05:36:46 -0500
Received: by mail-qc0-f180.google.com with SMTP id w7so1266174qcr.39
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Dec 2013 02:36:45 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 7 Dec 2013 11:36:45 +0100
Message-ID: <CADdntNuHYRAK_kcDJf1bnJeuTmc=CRx7TeyJPv4hsW9NPyd6mg@mail.gmail.com>
Subject: Can't remove empty directory after kernel panic, no errors in dmesg
From: Niklas Schnelle <niklas.schnelle@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi List,

so first the basics. I'm running Arch Linux with 3.13-rc2, btrfs-progs
0.20rc1.3-2 from the repo and I'm using a SSD.
So I was having kernel panics with my USB 3.0 Gigabit card and was
trying to get a panic output. These panics are intermittent and most
often happen while using Chromium. Anyway so my system paniced while I
was in Chromium.
After the reboot Chromium reported that its preferences are corrupted,
thankfully I've both backups and an older snapshot. So I wanted to
copy over my ~/.config/chromium from the snapshot.
However I couldn't delete that directory, rm -rf reported it to not be
empty. Renaming worked via
"mv chromium bad" but now I can't delete the bad directory, this is the output:
http://pastebin.com/FWTPGGH1

any idea how to get that directory deleted or how to obtain more information?

Greetings Niklas
