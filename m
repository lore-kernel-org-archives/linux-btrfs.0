Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolcon.net.244.248.89.in-addr.arpa ([89.248.244.226]:38060 "EHLO
	kolcon.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbcFVMZf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jun 2016 08:25:35 -0400
Received: from localhost (unknown [127.0.0.1])
	by kolcon.net (Postfix) with ESMTP id 465F213E5481
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 12:01:13 +0000 (UTC)
Received: from kolcon.net ([127.0.0.1])
	by localhost (mail.kolouch.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0HjUCoZUel6A for <linux-btrfs@vger.kernel.org>;
	Wed, 22 Jun 2016 14:01:10 +0200 (CEST)
Received: from localhost (unknown [89.248.246.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by kolcon.net (Postfix) with ESMTPSA id 1E6E913E5479
	for <linux-btrfs@vger.kernel.org>; Wed, 22 Jun 2016 12:01:10 +0000 (UTC)
Date: Wed, 22 Jun 2016 14:01:08 +0200
From: Lubos Kolouch <kolcon@kolcon.net>
To: linux-btrfs@vger.kernel.org
Subject: btrfs send/receive error
Message-ID: <20160622120108.GA15708@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am having strange issue with btrfs send/receive:

#btrfs send -p /mnt/a/_btrbk_snap/debian.20160621_1 
/mnt/a/_btrbk_snap/debian.20160622 | btrfs receive 
/mnt/ext/backups/vaclfw/

At subvol /mnt/a/_btrbk_snap/debian.20160622
At snapshot debian.20160622
ERROR: unlink var/lib/samba/private/msg.sock/7992 failed. No such file 
or directory


But :

ls -la 
/mnt/a/_btrbk_snap/debian.20160621_1/var/lib/samba/private/msg.sock/
2330   2388   2394   29375  7992

ls -la 
/mnt/ext/backups/vaclfw/debian.20160621_1/var/lib/samba/private/msg.sock/
2330   2388   2394   29375  7992

uname -a
Linux vaclfw 4.6.0-1-amd64 #1 SMP Debian 4.6.2-1 (2016-06-15) x86_64 
GNU/Linux

# btrfs version
# btrfs-progs v4.5.2

What could be wrong?

Thanks

Lubos
