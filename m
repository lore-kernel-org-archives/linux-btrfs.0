Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:60570 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab3INJFl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 14 Sep 2013 05:05:41 -0400
Received: by mail-la0-f44.google.com with SMTP id eo20so1766155lab.3
        for <linux-btrfs@vger.kernel.org>; Sat, 14 Sep 2013 02:05:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHCa-pc04=k=F3KDdoTUR9NpU_xi0M+tPSTzWyP-yZUEVPU6kg@mail.gmail.com>
References: <CAHCa-pc04=k=F3KDdoTUR9NpU_xi0M+tPSTzWyP-yZUEVPU6kg@mail.gmail.com>
From: Mathew Kamkar <matkam@gmail.com>
Date: Sat, 14 Sep 2013 02:05:10 -0700
Message-ID: <CAHCa-pd=5Eo5EVUEOh8va-zmQAg3=Xb2HT8jBoWH-9RGq9UAzQ@mail.gmail.com>
Subject: Fwd: btrfs-image from bad filesystem
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm using Btrfs v0.20-rc1-253-g7854c8b on kernel 3.10.10-1-ARCH. I've
been using this btrfs filesystem on an SSD for a little under a year
with no problems until now. I noticed it was getting a bit full (~79%)
and tried to do some cleanup by removing old snapshots. Immediately
after, the filesystem went into read only mode. I then followed Hugo
Mill's advice (that was posted here:
https://bbs.archlinux.org/viewtopic.php?id=169429 ) but was not able
to fully recover the filesystem (there were tons of error messages
along the entire process). Luckily, mounting the filesystem read-only,
I was able to copy all my data and rebuild the filesystem.

Anyway, I'm not sure if I ran btrfs-zero-log before or after taking
this image. But I have a btrfs-image available for a dev who wants it.
