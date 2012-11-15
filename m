Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:41022 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab2KOJof (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 04:44:35 -0500
Received: from local.plusdinfo.com ([82.232.160.30] helo=[192.168.0.10])
	by licorne.daevel.fr with esmtpsa (SSL3.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <btrfs.list@daevel.fr>)
	id 1TYvtn-00052C-EH
	for linux-btrfs@vger.kernel.org; Thu, 15 Nov 2012 10:38:15 +0100
Message-ID: <1352972275.22539.7.camel@localhost>
Subject: btrfs: corrupt leaf, bad key order
From: Olivier Bonvalet <btrfs.list@daevel.fr>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Nov 2012 10:37:55 +0100
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

in my logs I have :
[482886.171753] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482890.537049] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482940.827007] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482940.827048] BTRFS warning (device dm-1): Aborting unused transaction.
[482943.482879] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482943.482918] BTRFS warning (device dm-1): Aborting unused transaction.
[482943.889685] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482944.006944] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482944.118946] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482944.118977] BTRFS warning (device dm-1): Aborting unused transaction.
[482944.118980] BTRFS warning (device dm-1): Aborting unused transaction.
[482944.118991] BTRFS warning (device dm-1): Aborting unused transaction.
[482944.191122] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482944.267567] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482944.267598] BTRFS warning (device dm-1): Aborting unused transaction.
[482944.267601] BTRFS warning (device dm-1): Aborting unused transaction.
[482944.465267] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482944.465301] BTRFS warning (device dm-1): Aborting unused transaction.
[482944.537176] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482944.537226] BTRFS warning (device dm-1): Aborting unused transaction.
[482944.645056] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482944.645091] BTRFS warning (device dm-1): Aborting unused transaction.
[482944.703298] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482944.774537] btrfs: corrupt leaf, bad key order: block=5484560384,root=1, slot=39
[482944.774565] BTRFS error (device dm-1) in btrfs_finish_ordered_io:1938: IO failure
[482944.774572] btrfs is forced readonly
[482944.774580] BTRFS warning (device dm-1): Aborting unused transaction.


How can I fix that ? (seen from a 3.6.6 kernel, but don't know when the
error occurred)

Thanks,
Olivier




