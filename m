Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38876 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbbBOVBX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Feb 2015 16:01:23 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YN6Jd-0001KD-Ln
	for linux-btrfs@vger.kernel.org; Sun, 15 Feb 2015 22:01:21 +0100
Received: from p4ff58ced.dip0.t-ipconnect.de ([79.245.140.237])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 22:01:21 +0100
Received: from holger.hoffstaette by p4ff58ced.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 22:01:21 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Suddenly cannot change metadata profile any longer
Date: Sun, 15 Feb 2015 21:01:07 +0000 (UTC)
Message-ID: <pan.2015.02.15.21.01.07@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Here's a new one (with kernel 3.18.7++):

$btrfs --version
Btrfs v3.18.2 (also tried 3.19-rc2)

$mount /dev/sdf1 /mnt/usb

$btrfs filesystem df /mnt/usb
Data, single: total=8.00MiB, used=256.00KiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=1.00GiB, used=112.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

Note: metadata=single - done right after mkfs for the initial balance.

$btrfs balance start -mconvert=dup /mnt/usb    
Done, had to relocate 2 out of 3 chunks

root>btrfs filesystem df /mnt/usb              
Data, single: total=8.00MiB, used=512.00KiB
System, single: total=32.00MiB, used=16.00KiB
Metadata, single: total=1.00GiB, used=192.00KiB
GlobalReserve, single: total=16.00MiB, used=0.00B

Wait, what? Still single?

This used to work, but somehow no longer does (verified on another
filesystem). If it's dup, it stays dup; if it's single, it stays single.

What works is the very first balance after the mkfs - it successfully
changes from the initial default dup to single, but subsequent balances
don't work. They also don't really fail.

Any ideas what might have caused this? Must have been a recent patch.

Holger

