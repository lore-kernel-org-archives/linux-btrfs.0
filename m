Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nm2-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.158]:40900 "HELO
	nm2-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751324Ab3LWGdV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Dec 2013 01:33:21 -0500
Message-ID: <1387780037.66690.YahooMailNeo@web162601.mail.bf1.yahoo.com>
Date: Sun, 22 Dec 2013 22:27:17 -0800 (PST)
From: Nacho Man <nacho2874@yahoo.com>
Reply-To: Nacho Man <nacho2874@yahoo.com>
Subject: unlinked orphans.
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I ran dmesg and saw a bunch of these:
[564421.874063] BTRFS debug (device sda2): unlinked 32 orphans
[568021.386733] BTRFS debug (device sda2): unlinked 32 orphans
[569943.269610] BTRFS debug (device sda2): unlinked 32 orphans
[570929.840278] BTRFS debug (device sda2): unlinked 32 orphans
[570942.035251] BTRFS debug (device sda2): unlinked 33 orphans
[571623.719086] BTRFS debug (device sda2): unlinked 32 orphans
[572075.684003] BTRFS debug (device sda2): unlinked 32 orphans

I just counted and there's a 175 of them.  Do I have to worry?  I've been working on a toolchain and some other stuff for the PS3 so my hard drive was being accessed a bit.  Could it be related?  Thanks.
