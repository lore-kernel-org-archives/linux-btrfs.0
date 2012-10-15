Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:1654 "EHLO
	srv2.trombetti.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab2JORTq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Oct 2012 13:19:46 -0400
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id 615855436E
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Oct 2012 13:09:11 -0400 (EDT)
Message-ID: <507C4343.6060305@shiftmail.org>
Date: Mon, 15 Oct 2012 19:09:23 +0200
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Systemcall for offline deduplication
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all btrfs developers

I would really appreciate a systemcall (or ioctl or the like) to allow 
deduplication of a block of a file against a block of another file.
(ok if blocks need to be aligned to filesystem blocks)

So that if I know that bytes 32768...65536 of FileA  are identical to 
bytes 131072...163840 of FileB I can call that syscall to have the 
regions deduplicated one against the other atomically and with the 
filesystem running.
The syscall should presumably check that the regions are really equal 
and perform the deduplication atomically.

This would be the start for a lot of deduplication algorithms in userspace.
It would be a killer feature for backup systems.

Thank you,
Bob
