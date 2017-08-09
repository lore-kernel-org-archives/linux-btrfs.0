Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33255 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752033AbdHIIs0 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Aug 2017 04:48:26 -0400
Received: by mail-lf0-f68.google.com with SMTP id 65so4044934lfa.0
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Aug 2017 01:48:26 -0700 (PDT)
Received: from localhost.localdomain ([176.65.90.70])
        by smtp.gmail.com with ESMTPSA id a191sm657860lfe.66.2017.08.09.01.48.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Aug 2017 01:48:24 -0700 (PDT)
Date: Wed, 9 Aug 2017 10:48:20 +0200
From: Mario =?UTF-8?B?RnVnYXp6acKu?= <fugazzi99@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS warning: unhandled fiemap cache detected
Message-ID: <20170809104820.25c3601e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone :-)

After updating the kernel to the latest one 4.12 I receive a lot of warnings in
my dmesg but only on my ssd that is a kingston hyperx predator.
No message get logged for my other two traditional HD that are btrfs also.
Warnings show only on boot and not on every boot.
Kernel is now 4.12.5 but I got that till upgrading to 4.12, in 4.11 no warnings.

Just wanted to know if I have to worry about this, scrubs are ok and btrfs
check give me no problems.

Thank you very much.
Mario.

Some sample:

[   13.486100] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960767488 len=8192 flags=0x0
[   13.486110] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960767488 len=8192 flags=0x0
[   13.486261] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960824832 len=12288 flags=0x0
[   13.486280] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960763392 len=4096 flags=0x0
[   13.486434] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960767488 len=8192 flags=0x0
[   13.486446] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960775680 len=4096 flags=0x0
[   13.486616] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960783872 len=24576 flags=0x0
[   13.486650] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960808448 len=4096 flags=0x0
[   13.486719] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960812544 len=8192 flags=0x0
[   13.486742] BTRFS warning (device sdd2): unhandled fiemap cache detected: offset=0 phys=1960820736 len=4096 flags=0x0

