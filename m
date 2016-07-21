Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:45374 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbcGUOzT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jul 2016 10:55:19 -0400
Received: from tux.wizards.de (pD953E552.dip0.t-ipconnect.de [217.83.229.82])
	by mail02.iobjects.de (Postfix) with ESMTPSA id BC81C41605D8
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 16:55:17 +0200 (CEST)
Received: from [192.168.100.223] (ragnarok.wizards.de [192.168.100.223])
	by tux.wizards.de (Postfix) with ESMTP id 5723A11C01CB
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jul 2016 16:55:17 +0200 (CEST)
To: linux-btrfs <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Subject: Finding only non-snapshots via btrfs subvol list
Message-ID: <5790E255.50806@applied-asynchrony.com>
Date: Thu, 21 Jul 2016 16:55:17 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I'm trying to find non-snapshots, i.e. 'top-level' subvolumes in a
filesystem and this seems harder than it IMHO should be.

The fs is just like:

/mnt/stuff
 subvolA
 subvolA-date1
 subvolA-date2
 subvolB
 subvolB-date1
 subvolB-date2
..

All I want are the subvol{A,B} *without* the snapshots, but so
far I haven't been able to accomplish this easily with "subvol list"
and its options. -s lists only snapshots, but what I want is the
exact opposite.

So far the best I could find - except for relying on my ad-hoc naming
conventions and inverse-grepping for that - is via -q (print parent UUID)
and matching on that:

btrfs subvol list -q /mnt/stuff | grep "parent_uuid -" | cut -f 11 -d " "

gives me what I want - but eeww. So somehow I think I'm missing something
trivial. Is there a better, non-greppy way?

Holger
