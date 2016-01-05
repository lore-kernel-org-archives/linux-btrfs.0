Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.palepurple.co.uk ([89.16.183.188]:45159 "EHLO
	mail.palepurple.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbcAENEa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 08:04:30 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.palepurple.co.uk (Postfix) with ESMTP id 3B5458334
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Jan 2016 13:04:29 +0000 (GMT)
Received: from mail.palepurple.co.uk ([127.0.0.1])
	by localhost (mail.palepurple.co.uk [127.0.0.50]) (amavisd-new, port 10024)
	with ESMTP id Z0uk71vq9Hiq for <linux-btrfs@vger.kernel.org>;
	Tue,  5 Jan 2016 13:04:29 +0000 (GMT)
Received: from [172.30.33.200] (host81-133-46-190.in-addr.btopenworld.com [81.133.46.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: david@palepurple.co.uk)
	by mail.palepurple.co.uk (Postfix) with ESMTPSA id 00E0D8111
	for <linux-btrfs@vger.kernel.org>; Tue,  5 Jan 2016 13:04:28 +0000 (GMT)
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: David Goodwin <david@codepoets.co.uk>
Subject: device removal seems to be very slow (kernel 4.1.15)
Message-ID: <568BBF5D.40304@codepoets.co.uk>
Date: Tue, 5 Jan 2016 13:04:29 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using btrfs progs 4.3.1 on a Vanilla kernel.org 4.1.15 kernel.

time btrfs device delete /dev/xvdh /backups

real    13936m56.796s
user    0m0.000s
sys     1351m48.280s


(which is about 9 days).


Where :

/dev/xvdh was 120gb in size.


/backups is a single / "raid 0" volume that now looks like :

Label: 'BACKUP_BTRFS_SNAPS'  uuid: 6ee08c31-f310-4890-8424-b88bb77186ed
	Total devices 3 FS bytes used 301.09GiB
	devid    1 size 100.00GiB used 90.00GiB path /dev/xvdg
	devid    3 size 220.00GiB used 196.06GiB path /dev/xvdi
	devid    4 size 221.00GiB used 59.06GiB path /dev/xvdj


There are about 400 snapshots on it.


thanks
David.
