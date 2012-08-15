Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:34518 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab2HOW3F (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Aug 2012 18:29:05 -0400
Received: from luuna.daevel.fr ([82.67.37.138] helo=[192.168.1.50])
	by licorne.daevel.fr with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1T1m5H-0004E0-OI
	for linux-btrfs@vger.kernel.org; Thu, 16 Aug 2012 00:29:03 +0200
Message-ID: <502C22BA.2000509@daevel.fr>
Date: Thu, 16 Aug 2012 00:29:14 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: [solved] Re: Can't umount a read-only FS ?
References: <502BDC30.8060409@daevel.fr>
In-Reply-To: <502BDC30.8060409@daevel.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15/08/2012 19:28, Olivier Bonvalet wrote:
> Hi,
> 
> I have a strange problem with a btrfs partition : after an error, btrfs was forced readonly.
> 
> So I try to umount it, to launch btrfsck, but it doesn't work :
> 
> root! sofia:~# umount /backup/
> root! sofia:~# btrfsck /dev/vg-sofia/backup
> /dev/vg-sofia/backup is currently mounted. Aborting.
> root! sofia:~# umount /backup/
> umount: /backup/: not mounted
> root! sofia:~# btrfsck /dev/vg-sofia/backup
> /dev/vg-sofia/backup is currently mounted. Aborting.
> root! sofia:~#
> 
> 

Well... I was using a "mount --bind" of a directory within that FS... So not btrfs related.

Sorry for noise, once again.

Olivier

