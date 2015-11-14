Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:36978 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbKNOML (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Nov 2015 09:12:11 -0500
Received: by igcto18 with SMTP id to18so6261977igc.0
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Nov 2015 06:12:10 -0800 (PST)
MIME-Version: 1.0
From: "CHENG Yuk-Pong, Daniel " <j16sdiz@gmail.com>
Date: Sat, 14 Nov 2015 22:11:31 +0800
Message-ID: <CAOcLnUfVNvRLYdeQG_kTZyXaceaLCez=XsQ8PXwEyaXPeYiMwg@mail.gmail.com>
Subject: More memory more jitters?
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi List,


I have read the Gotcha[1] page:

   Files with a lot of random writes can become heavily fragmented
(10000+ extents) causing trashing on HDDs and excessive multi-second
spikes of CPU load on systems with an SSD or **large amount a RAM**.

Why could large amount of memory worsen the problem?

If **too much** memory is a problem, is it possible to limit the
memory btrfs use?

Background info:

I am running a heavy-write database server with 96GB ram. In the worse
case it cause multi minutes of high cpu loads. Systemd keeping kill
and restarting services, and old job don't die because they stuck in
uninterruptable wait... etc.

Tried with nodatacow, but it seems only affect new file. It is not an
subvolume option either...


Regards,
Daniel


[1] https://btrfs.wiki.kernel.org/index.php/Gotchas#Fragmentation
