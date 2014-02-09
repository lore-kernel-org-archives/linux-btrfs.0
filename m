Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:51216 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaBIUVA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Feb 2014 15:21:00 -0500
Received: by mail-lb0-f182.google.com with SMTP id w7so4286489lbi.27
        for <linux-btrfs@vger.kernel.org>; Sun, 09 Feb 2014 12:20:59 -0800 (PST)
Received: from melforce.localnet (melforce.xtsubasa.org. [2a02:578:5002:8062::2])
        by mx.google.com with ESMTPSA id qx7sm13188488lbb.9.2014.02.09.12.20.56
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 09 Feb 2014 12:20:57 -0800 (PST)
From: Pavel Volkov <negaipub@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Error: could not do orphan cleanup -22
Date: Mon, 10 Feb 2014 00:20:54 +0400
Message-ID: <2047669.QmpNhlvBGM@melforce>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There was a similar discussion about an error in January 2013 but it related to some kernel panic.
I don't know if I encountered the same thing.

These errors from system journal bother me:

 2月 09 22:18:53 melforce kernel: BTRFS error (device sdb3): Error removing orphan entry, stopping orphan cleanup
 2月 09 22:18:53 melforce kernel: BTRFS critical (device sdb3): could not do orphan cleanup -22

I run kernel 3.12.10.
I'll explain what I did at that moment.
Subvolumes were already mounted at /home and /var and I mounted the root subvolume at /mnt/btr2.
Then executed ls command on /home/btr2. ls gave me "invalid argument" errors, but still displayed the contents. 
Next time I ran ls (right away), there were no more errors.

Another example is a script that mounts the same thing and then takes snapshots.
If I run the script manually, it never fails. If I run it from cron job, one of the snapshot commands fails
telling me that /home/btr2/var isn't accesible (I don't remember the exact error message, I can look if it
shows up again).

Someone said in the January thread that -22 error messages are harmless but in this case userspace tools break
so I wouldn't consider this totally harmless.
