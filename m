Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:37429 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377AbbBHQiy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Feb 2015 11:38:54 -0500
Received: by mail-oi0-f51.google.com with SMTP id x69so19097660oia.10
        for <linux-btrfs@vger.kernel.org>; Sun, 08 Feb 2015 08:38:54 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 8 Feb 2015 17:38:53 +0100
Message-ID: <CAOQhA5UE66MsybF=CtmgRFXoiMNdLMKUgr--BNmg61mTCxuFRw@mail.gmail.com>
Subject: Segfault when deleting device
From: Robert Mucina <robert.mucina@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I have kubuntu 14.10 with 3.17.1 kernel and 3.17 tools
the setup of data pool was btrfs raid1, 3x6TB + 1x3TB. Time has come
to replace old 3TB with new 3TB.
As usual I added new device and deleted the old one, system started
relocating chunks and I went to bed...
In the morning I was greeted with pool in RO mode and segmentation
fault in dmesg, see here http://pastebin.com/vcr7qagB
After some nail biting and reisub I found data to be ok and pool
worked normally in RW. Pheww.
By output in dmesg and in btrfs fi show I can see the new device has
336GBs used so the problem occurred after some data copying.
I ran 7 hour SMART extensive test on new device and it came out
perfectly ok. Then I tried disconnecting old drive in attempt to do
delete missing. Unfortunately this also led to segmentation fault
almost immediately after firing the command (didn't make a copy of
that one though)
All three 6TB drives seem to be fine by quick SMART checks.

So now I'm running in degraded mode, unable to delete missing device.
Options I see here is to attempt rebalance which I'm rather affraid of
in this state. Or upgrade kernel to 3.18.x in hope the problem's been
already fixed...
Any other thoughts?

Regards,
Robert
