Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:59677 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaCWOYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 23 Mar 2014 10:24:18 -0400
Received: by mail-la0-f43.google.com with SMTP id e16so2900993lan.2
        for <linux-btrfs@vger.kernel.org>; Sun, 23 Mar 2014 07:24:16 -0700 (PDT)
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Luiz_Rom=E1rio_Santana_Rios?=
	<luizromario@gmail.com>
Date: Sun, 23 Mar 2014 14:23:56 +0000
Message-ID: <CABCW-krKsrsbJ4DpNN9P9U5hR7R2MSJJ=yG2QX5+BFTe7CuM6w@mail.gmail.com>
Subject: Partition won't mount after forced shutdown
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was using my laptop when, suddenly, it froze. I forced it to
shutdown, but, when I tried to turn it back on, /home, a btrfs
partition, couldn't mount. I tried to mount it with the recovery mount
option but it didn't help: http://pastebin.com/8C8MEyK9. Then I tried
to recover it with btrfs-zero-log; still nothing:
http://pastebin.com/g6gviKpP.

Next, following https://btrfs.wiki.kernel.org/index.php/Restore, I
tried to recover the files from the partition, but only a handful of
config files were successfully recovered, even when using the -i
option (output: http://pastebin.com/fp2GiSAz). And I can't find the
find-root executable in my system or in btrfs-progs.

Here's my /var/log/messages: https://www.dropbox.com/s/ytn21srae858brn/msgs

What else should I do before trying to btrfsck? I was going to try and
follow the guide in this post:
https://bbs.archlinux.org/viewtopic.php?pid=1321989#p1321989.

Regards,

-- 
Luiz Romário Santana Rios
