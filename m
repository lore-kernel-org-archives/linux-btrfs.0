Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:36597 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161335AbcBQNCa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 08:02:30 -0500
Received: by mail-qk0-f171.google.com with SMTP id s68so5311789qkh.3
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Feb 2016 05:02:30 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 17 Feb 2016 14:02:30 +0100
Message-ID: <CAH4oapcJVfd74Wg64+4Q+xXzF07U1NKrQTnhoOA1ry2sJogkXQ@mail.gmail.com>
Subject: btrfs send error
From: Pavol Cupka <pavol.cupka@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

when trying to btrfs send a snaphost I get this in dmesg:
[8614395.539466] BTRFS error (device sda1): did not find backref in
send_root. inode=673755, offset=131072, disk_byte=25730310144 found
extent=25730310144

scrub reveals no errors
scrub status for bb8094e8-a7b1-4c2d-854e-77a9921e6f7e
        scrub started at Wed Feb 17 08:14:32 2016 and finished after 00:15:58
        total bytes scrubbed: 67.49GiB with 0 errors

Is there something else that I might try to get this work?

uname -a
Linux 4.1.7-hardened-r1 #4 SMP Mon Nov 9 20:02:04 CET 2015 x86_64
Intel(R) Atom(TM) CPU N2800 @ 1.86GHz GenuineIntel GNU/Linux

btrfs --version
btrfs-progs v4.3.1

Thanks Pavol
