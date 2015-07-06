Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:60577 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbbGFTUK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 15:20:10 -0400
Received: from [127.0.0.1] ([88.71.42.237]) by mrelayeu.kundenserver.de
 (mreue004) with ESMTPA (Nemesis) id 0Lpzv9-1YZGM30Fcd-00fh9o for
 <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2015 21:20:08 +0200
Message-ID: <559AD4E5.2030107@friedels.name>
Date: Mon, 06 Jul 2015 21:20:05 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: size 2.73TiB used 240.97GiB  after balance
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I started with a raid1:
         devid    1 size 2.73TiB used 2.67TiB path /dev/sdd
         devid    2 size 2.73TiB used 2.67TiB path /dev/sdb
Then I added a third device, /dev/sdc1 and a balance
btrfs balance start -dconvert=raid5 -mconvert=raid5 /mnt/__Complete_Disk/

Now the file-system looks like this:
         Total devices 3 FS bytes used 4.68TiB
         devid    1 size 2.73TiB used 2.67TiB path /dev/sdd
         devid    2 size 2.73TiB used 2.67TiB path /dev/sdb
         devid    3 size 2.73TiB used 240.97GiB path /dev/sdc1

I am surprised by the 240.97GiB...

In the syslog and dmesg I find several:
[108274.415499] btrfs_dev_stat_print_on_error: 8 callbacks suppressed
[108279.840334] btrfs_dev_stat_print_on_error: 12 callbacks suppressed

What's wrong here?

Regards,
Hendrik

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

