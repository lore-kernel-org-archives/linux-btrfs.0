Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:17894 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752692Ab3KZGku convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Nov 2013 01:40:50 -0500
Received: from c-50-183-15-223.hsd1.co.comcast.net ([50.183.15.223]:49297 helo=[192.168.1.120])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.82)
	(envelope-from <lists@colorremedies.com>)
	id 1VlCKI-002j9W-C0
	for linux-btrfs@vger.kernel.org; Mon, 25 Nov 2013 23:40:50 -0700
From: Chris Murphy <lists@colorremedies.com>
Content-Type: text/plain; charset=us-ascii
Subject: missing /sbin/fsck.btrfs
Message-Id: <13F547BC-D81C-45FB-9DC8-9C076B8605EF@colorremedies.com>
Date: Mon, 25 Nov 2013 23:40:49 -0700
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Is there supposed to be an /sbin/fsck.btrfs? I'm seeing a handful of threads indicating some idea of having it just do a no-op like fsck.xfs does, but then also the idea that /etc/fstab should correctly set fs_passno to 0 instead of such trickery.

I ask due to systemd-fstab-generator seemingly getting the idea from Fedora 20's default /etc/fstab that btrfs should have its file system checked, and during offline  updates, systemd tries to do this, doesn't find /sbin/fsck.btrfs, and then has several dozen fits.

https://bugzilla.redhat.com/show_bug.cgi?id=1034563
https://bugzilla.redhat.com/show_bug.cgi?id=862871

So the question, is there supposed to be (one day) a faux /sbin/fsck.btrfs? Or should things always check /etc/fstab fs_passno and honor the fact there is really no such thing?

Thanks,

Chris Murphy