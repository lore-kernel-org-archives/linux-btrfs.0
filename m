Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:33928 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbcHHQah (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Aug 2016 12:30:37 -0400
Received: by mail-qk0-f195.google.com with SMTP id x67so11455155qke.1
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Aug 2016 09:30:37 -0700 (PDT)
MIME-Version: 1.0
From: Ivan Sizov <sivan606@gmail.com>
Date: Mon, 8 Aug 2016 19:30:16 +0300
Message-ID: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com>
Subject: Strange behavior after "rm -rf //"
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'd ran "rm -rf //" by mistake two days ago. I'd stopped it after five
seconds, but some files had been deleted. I'd tried to shutdown the
system, but couldn't (a lot of files in /bin had been deleted and
systemd didn't work). After hard reboot (by reset button) and booting
to a live USB a strange thing was discovered.

Deleted files are present when I "mount -r" the disk, but
btrfs-restore tells they are deleted ("We have looped trying to
restore files too many times to be making progress").

What does it mean? Will those files be deleted after RW mount?

-- 
Ivan Sizov (SIvan)
