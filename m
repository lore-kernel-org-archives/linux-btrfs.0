Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:50727 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaAOLCM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jan 2014 06:02:12 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 5A67A385E91
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 11:55:45 +0100 (CET)
Received: from localhost (aegq142.neoplus.adsl.tpnet.pl [79.186.172.142])
	by mail.virtall.com (Postfix) with ESMTPSA id 1D817385C38
	for <linux-btrfs@vger.kernel.org>; Wed, 15 Jan 2014 11:55:45 +0100 (CET)
Date: Wed, 15 Jan 2014 11:55:43 +0100
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: why am  I getting "No space left on device" here?
Message-ID: <20140115115543.790adafb@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I'm no longer able to write to this btrfs filesystem:

# df -h /home
Filesystem      Size  Used Avail Use% Mounted on
/dev/sdb4       5.2T  3.6T  1.6T  71% /home


# btrfs fi show /home
Label: crawler-btrfs  uuid: 60f1759c-45f6-4484-9f60-66a4e9bbf2b6
        Total devices 2 FS bytes used 1.80TiB
        devid    3 size 2.56TiB used 1.80TiB path /dev/sdb4
        devid    4 size 2.56TiB used 1.80TiB path /dev/sda4

Btrfs v3.12


# btrfs filesystem df /home
Data, RAID1: total=1.75TiB, used=1.75TiB
System, RAID1: total=32.00MiB, used=268.00KiB
Metadata, RAID1: total=53.00GiB, used=51.71GiB


However:

# dd if=/dev/urandom of=bigfile
dd: writing to `bigfile': No space left on device
186+0 records in
185+0 records out
94720 bytes (95 kB) copied, 0.0144045 s, 6.6 MB/s


I don't understand why - can anyone explain?


-- 
Tomasz Chmielewski
http://wpkg.org

