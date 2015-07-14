Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.forwiss.uni-passau.de ([132.231.20.39]:45163 "EHLO
	mail.forwiss.uni-passau.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751776AbbGNL4g (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jul 2015 07:56:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.forwiss.uni-passau.de (Postfix) with ESMTP id 8B2AA4185A
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2015 10:52:43 +0200 (CEST)
Received: from [::ffff:84e7:140f] (helo=luthien.forwiss.uni-passau.de)
	by forwiss.uni-passau.de with ESMTP (eXpurgate 4.0.7)
	(envelope-from <berberic@forwiss.uni-passau.de>)
	id 558bc15b-01fa-00000000000000000000ffff84e714270019-00000000000000000000ffff84e7140fbb1a-1
	for <linux-btrfs@vger.kernel.org>; Thu, 25 Jun 2015 10:52:43 +0200
Date: Tue, 14 Jul 2015 13:47:05 +0200
From: M G Berberich <btrfs@oss.m-berberich.de>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs filesystem-fail observations and hints
Message-ID: <20150714114705.GI23491@forwiss.uni-passau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

at the weekend we had a disk-fail in a 5-disk BtrFS-RAID1
setup. Ideally one failing disk in a RAID1 setup should (at least
temporarily) degrade the filesystem and inform root about the
situation, but should let the rest of the system unaffected. That’s
not what happend. Processes accessing the filesystem hung
device-waiting and the filesystem itself “hung” too, producing lots of

  BTRFS: lost page write due to I/O error on /dev/sdd
  BTRFS: bdev /dev/sdd errs: wr …, rd …, flush 0, corrupt 0, gen 0

messages. Attempts to reboot the system regularly failed. Only after
physically removing the failed (hotplugable) disk from the system, it
was possible to reboot the system somewhat normal.

Afterwards, trying to get the system running again, the following
observation where made:

· “btrfs device delete missing”

  There seems to be no straight-forward way to monitor the progress of
  the “rebalancing” of the filesystem. It took about 6 hours and while
  it was possible to estimate the time of finish by watching “btrfs fi
  show” and extrapolating device-usagem, a method to monitor the
  progess like “btrfs balance status” would be fine. (“btrfs balance
  status” says “No balance found on …”)

· “btrfs fi df”

  During “btrfs device delete missing”-rebalance “btrfs fi df” does
  not reflect the current state of the filesystem. It says p.e.

    Data, RAID1: total=1.46TiB, used=1.46TiB
    Data, single: total=8.00MiB, used=0.00B

  while actually, depending of the advance of the rebalance, about 0
  to 300 GByte have only one copy on the devices. So p.e.

    Data, RAID1: total=1.1TiB, used=1.1TiB
    Data, single: total=290GiB, used=290GiB

  would be better reflecting the state of the system.

	MfG
	bmg

-- 
„Des is völlig wurscht, was heut beschlos- | M G Berberich
 sen wird: I bin sowieso dagegn!“          | berberic@fmi.uni-passau.de
(SPD-Stadtrat Kurt Schindler; Regensburg)  | www.fmi.uni-passau.de/~berberic
