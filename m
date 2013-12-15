Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38951 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3LOWZO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Dec 2013 17:25:14 -0500
Received: by mail-qc0-f174.google.com with SMTP id n7so3190419qcx.33
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Dec 2013 14:25:14 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 15 Dec 2013 14:25:13 -0800
Message-ID: <CA+DO5u0L8xyrB2vOzopOgpSQQyA+g-6VZTB7asm7RpsKpXYR0Q@mail.gmail.com>
Subject: Is a VM an adequate environment for simulating scenarios and limits
 of BTRFS?
From: DRA <s2cuts@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Greetings all and pardon my intrusion,

I'm just a basic home user running a file server for mostly large
media files (write once, read many).  Some dynamic working files, but
a much smaller portion.  The OS will not run on BTRFS, nor will it do
much in the way of running services other than what's required for a
basic file server.  My server hardware is mostly salvaged, 2 GB of
memory, and an ever growing number of consumer grade large capacity
drives.

Before I commit and cut over to BTRFS, I wanted to do some customized
testing based on my usage profile and the features of BTRFS that I'm
interested in.  My question has to do with if a Virtualbox VM with
virtual disks would be a realistic testing environment to assault
BTRFS on.  I can not practically test on real disks, so would going
the VM route give me a false picture of BTRFS in any way?  I'm not
sure to what degree the virtual disk writes are buffered by the VM
host.  Are there any VM configurations that would give me more
realistic virtual disk behaviour?

Thanks guys for any advice, and for working on what looks to be the
future de facto FS for GNU/Linux.

d
