Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64201 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754576Ab3BPWD0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Feb 2013 17:03:26 -0500
Received: by mail-wg0-f47.google.com with SMTP id dr13so3738324wgb.14
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Feb 2013 14:03:25 -0800 (PST)
Message-ID: <51200320.4010205@statystyka.net>
Date: Sat, 16 Feb 2013 23:07:28 +0100
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Why does "btrfs send /mnt/btrfs-root" fail with "ERROR: /mnt/btrfs-root
 is not read-only." even when mounted with option "ro"?
References: <510E6714.7040206@statystyka.net> <510F0AE4.4070608@cn.fujitsu.com>
In-Reply-To: <510F0AE4.4070608@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Question as in title.

I did remount my btrfs partition as read-only

(i.e. I did "sudo mount /dev/sda9 /mnt/btrfs-root -o ro")

And when I did
   btrfs send /mnt/btrfs-root >/dev/null
I received "ERROR: /mnt/adama-docs is not read-only."

Although, when I
   sudo touch /mnt/btrfs-root/foo
I get "touch: cannot touch `/mnt/btrfs-root/foo': Read-only file system"


My btrfs --version reads
   Btrfs v0.20-rc1-56-g6cd836d

And uname -r
   3.7.8-030708-generic

Do I miss something obvious? Or should I wait until next kernel version?

-- 
Adam Ryczkowski
+48505919892
Skype:sisteczko

