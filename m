Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:52779 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756488Ab3KZLBT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 06:01:19 -0500
Received: from localhost (localhost [127.0.0.1])
	by ares07.inai.de (Postfix) with ESMTP id A80F52000CD8C
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Nov 2013 12:01:15 +0100 (CET)
Date: Tue, 26 Nov 2013 12:01:14 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: linux-btrfs@vger.kernel.org
Subject: Bogus f_avail/f_bavail in df
Message-ID: <alpine.LSU.2.11.1311261155590.2892@nerf07.vanv.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


While btrfs does its resizing, df stats are messed up.
Seen in linux-3.9.9. Don't know if it still occurs.

11:55 ares07:/home/snap # btrfs fi resize 250G /home/snap/red &
[1] 2861
Resize '/home/snap/red' of '250G'
11:55 ares07:/home/snap # 
11:55 ares07:/home/snap # df -h
Filesystem         Size  Used Avail Use% Mounted on
/dev/loop0         600G  239G   16E   1% /home/snap/red
                                ^^^
/dev/loop0  629145600   250249968 18014398497657468   1% /home/snap/red

(So it's not exactly a magic number (2^n)-1 or something.)
btrfs-progs-v0.20-rc1-358-g194aa4a.tar.bz2
