Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wbwburpvsmtpb.warnerbros.com ([168.161.192.151]:26490 "EHLO
	wbwburpvsmtpb.warnerbros.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755391AbaIQRXH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Sep 2014 13:23:07 -0400
Message-ID: <5419C11D.1080803@gmail.com>
Date: Wed, 17 Sep 2014 10:13:01 -0700
From: Alan Hagge <nospam.ah@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Can btrfs re-sync an out-of-sync RAID1 filesystem?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I know that sounds weird, but here's my scenario:

- Create a RAID1 filesystem (both data and metadata) using 2 same-sized
external USB drives
- Copy data (backup of other filesystem) onto this new filesystem
- Dismount the filesystem
- Split up the drives (keep one at home, move one to offsite backup)

This way if I need to recover a file, I can mount the one drive I have
with "-o ro,degraded" to recover data.  If there's a read error on the
backup drive during the copy, I can go to the offsite location, bring
back the 2nd drive and mount both and have RAID1 protection.

BUT...if I accidentally (because I forgot to use "ro" when mounting) or
purposely write data to the single drive in degraded mode,  is it
possible to later mount both drives in RAID1 mode and "resync" them (as
opposed to having to do a "replace" operation on the out-of-sync drive,
which would force it to be completely rewritten)?  If so, how would
btrfs know which drive is the "master" (ie. the updated one)?

Or is it not possible to write to a btrfs volume mounted in "degraded" mode?
