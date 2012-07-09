Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:43013 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab2GITOG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 9 Jul 2012 15:14:06 -0400
Received: from localhost (localhost [127.0.0.1])
	by seven.medozas.de (Postfix) with ESMTP id 1124F96A07E7
	for <linux-btrfs@vger.kernel.org>; Mon,  9 Jul 2012 21:14:03 +0200 (CEST)
Date: Mon, 9 Jul 2012 21:14:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs fi df won't show total=
Message-ID: <alpine.LNX.2.01.1207092111360.16359@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On openSUSE_12.1 with Btrfs v0.19+20120406, the following can be
observed: after a change of the profiles, total=,used= is no
longer shown:


20:49 mmsrv1:~ # btrfs fi df /top.srv/
Data, RAID10: total=152.00GiB, used=121.07GiB
System, RAID1: total=40.00MiB, used=44.00KiB
System: total=4.00MiB, used=0.00
Metadata, RAID1: total=112.00GiB, used=1.30GiB
Metadata: total=8.00MiB, used=0.00
20:50 mmsrv1:~ # btrfs fi bal start -mconvert=raid10 -sconvert=raid10 
/top.srv/
Refusing to explicitly operate on system chunks.
Pass --force if you really want to do that.
20:52 mmsrv1:~ # btrfs fi bal start -mconvert=raid10 -sconvert=raid10 
--force /top.srv/
...
21:10 mmsrv1:~ # btrfs fi df /top.srv/
Data, RAID10: total=156.00GiB, used=124.35GiB
System, RAID10: total=128.00MiB, used=48.00KiB
System: total=4.00MiB, used=0.00
Metadata, RAID10: total=112.00GiB, used=1.38GiB

