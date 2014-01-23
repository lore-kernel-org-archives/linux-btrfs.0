Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:41413 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaAWXhw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jan 2014 18:37:52 -0500
Received: by mail-qc0-f170.google.com with SMTP id e9so3573990qcy.29
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jan 2014 15:37:51 -0800 (PST)
MIME-Version: 1.0
From: Jonathan H <pythonnut@gmail.com>
Date: Thu, 23 Jan 2014 15:37:21 -0800
Message-ID: <CAAW2-ZeF89ZKi3yhhmRpuEBJT9hhbE=c5aehO-wSPsjfsf0YDQ@mail.gmail.com>
Subject: Zombie BTRFS subvolume
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I deleted a subvolume using "rm -rf .snapshots" (the subvolume was
created by snapper). Now, it's gone from the filesystem, but it's
still show in "btrfs su list /" where it was originally. This makes me
worried. I ran a btrfsck and it didn't spot any errors that seemed
relevant.

The system is alive and well, but I'm worried that something's not
right. Is this okay, and, if not, how can I fix it?

Thanks,
PythonNut
