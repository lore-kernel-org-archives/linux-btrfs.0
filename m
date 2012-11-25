Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:36547 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2KYRRQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 25 Nov 2012 12:17:16 -0500
Received: from luuna.daevel.fr ([82.67.37.138] helo=[192.168.1.50])
	by licorne.daevel.fr with esmtpsa (SSL3.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1TcfpQ-0005V7-0a
	for linux-btrfs@vger.kernel.org; Sun, 25 Nov 2012 18:17:12 +0100
Message-ID: <1353863796.26883.10.camel@boolette.noo>
Subject: FS mountable only in RO / incomplete FAQ ?
From: Olivier Bonvalet <btrfs.list@daevel.fr>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Nov 2012 18:16:36 +0100
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I had an umountable FS, no kernel oops, just "mount /backup" which still
running after hours, without throwing any IO to disk.

>From the FAQ https://btrfs.wiki.kernel.org/index.php/Problem_FAQ I saw
to try with (-o recovery) then (-o ro). The recovery didn't help, but
the "ro" option works fine, thanks !

So now ? I have a FS in read-only, is there something I can do to fix
it ? "btrfsck --repair" is killed by OOM (it use 14GB of RAM !)

If it can help :
# btrfs fi df /backup/
Data: total=1.72TB, used=1.65TB
System, DUP: total=64.00MB, used=208.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=39.20GB, used=35.38GB


Thanks for any help,
Olivier

