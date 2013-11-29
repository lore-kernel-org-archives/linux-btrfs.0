Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:53478 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab3K2Nvx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Nov 2013 08:51:53 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so13771063pdj.25
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Nov 2013 05:51:53 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 29 Nov 2013 08:51:53 -0500
Message-ID: <CAMfhy93_SCzGKwkPFpOb-ShhAoCXoehwTRLvxD+=ZgOXuce_Gg@mail.gmail.com>
Subject: BTRFS scrub hung
From: Mace Moneta <moneta.mace@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=66151

# btrfs scrub status /
scrub status for 02184910-5849-489f-b970-3ea35912a7af
        scrub started at Tue Nov 26 21:30:01 2013, running for 15 seconds
        total bytes scrubbed: 5.38GiB with 0 errors

# btrfs scrub cancel /
ERROR: scrub cancel failed on /: not running

# btrfs scrub resume /
ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel /'.
To see the status use 'btrfs scrub status [-d] /'.

# btrfs scrub status /
scrub status for 02184910-5849-489f-b970-3ea35912a7af
        scrub started at Tue Nov 26 21:30:01 2013, running for 15 seconds
        total bytes scrubbed: 5.38GiB with 0 errors

Notes:
1. Using btrfs-progs-3.12-1.fc20.x86_64, kernel-3.12.1-2.fc21.x86_64
on Fedora 20.
2. The BTRFS filesystem is on two drives, data RAID0 and metadata RAID1
