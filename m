Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:58606 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab2HOR2H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 13:28:07 -0400
Received: from luuna.daevel.fr ([82.67.37.138] helo=[192.168.1.50])
	by licorne.daevel.fr with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1T1hO1-0008RF-Vn
	for linux-btrfs@vger.kernel.org; Wed, 15 Aug 2012 19:28:06 +0200
Message-ID: <502BDC30.8060409@daevel.fr>
Date: Wed, 15 Aug 2012 19:28:16 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Can't umount a read-only FS ?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have a strange problem with a btrfs partition : after an error, btrfs was forced readonly.

So I try to umount it, to launch btrfsck, but it doesn't work :

root! sofia:~# umount /backup/
root! sofia:~# btrfsck /dev/vg-sofia/backup
/dev/vg-sofia/backup is currently mounted. Aborting.
root! sofia:~# umount /backup/
umount: /backup/: not mounted
root! sofia:~# btrfsck /dev/vg-sofia/backup
/dev/vg-sofia/backup is currently mounted. Aborting.
root! sofia:~#



And I can't remount it :

root! sofia:~# mount /backup/
mount: /dev/mapper/vg--sofia-backup already mounted or /backup busy



Or access to the content :

root! sofia:~# ls /backup/
root! sofia:~#




It's on a v3.4.7 kernel, with btrfs-tools version 0.19+20120328-7 (from Debian unstable).

What should I do ? Reboot ?


Thanks,

Olivier
