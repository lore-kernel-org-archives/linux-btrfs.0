Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:33147 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742AbaIWM6J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Sep 2014 08:58:09 -0400
Received: by mail-we0-f181.google.com with SMTP id w61so2693523wes.12
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Sep 2014 05:58:08 -0700 (PDT)
Received: from ubuntu.localnet (91-113-120-128.adsl.highway.telekom.at. [91.113.120.128])
        by mx.google.com with ESMTPSA id pm2sm2208283wic.13.2014.09.23.05.58.07
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Sep 2014 05:58:07 -0700 (PDT)
From: GEO <1g2e3o4@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs send does not work from readonly device
Date: Tue, 23 Sep 2014 14:58:06 +0200
Message-ID: <16424080.RP99VxSJe8@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Let's say we have a snapshot called "snapshot" on our device "/dev/sdb".
Now we boot a qemu machine and attatch the disk read only (since we do not
want to put our data at risk in the vm, and read only should be enough to
get our snapshot data).

I used

qemu-system-x86_64 -drive -file=/dev/sdb,if=scsi,readonly -hda
<path_to_guest_operating_system>

When we are in the qemu instance (suppose our device  /dev/sdb is mounted
on /mnt/import), we want to import our data now using btrfs send/receive:

btrfs send /mnt/import/snapshot | btrfs receive  /

we get the following problems in syslog due to the fact that our device is
read only:

delayed_refs has NO entry
BTRFS warning (device sdb): btrfs_update_root:151: Aborting unsused
transaction(No space left)
BTRFS warning (device sdb): Skipping commit of aborted transaction.
BTRFS warning (device sdb): cleanup_transaction:1547: Aborting unused
transaction (No space left)

Apart from the snapshot folder being created in / nothing happens, the
process simply hangs forever, with no actual data getting imported.

Is that supposed to be that way? Why is readonly not enough to import data
using btrfs send?
