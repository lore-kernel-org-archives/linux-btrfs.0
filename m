Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:56971 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaC3J6R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Mar 2014 05:58:17 -0400
Received: by mail-ee0-f47.google.com with SMTP id b15so5527176eek.6
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Mar 2014 02:58:16 -0700 (PDT)
Received: from linuxpc.localnet (188-22-82-140.adsl.highway.telekom.at. [188.22.82.140])
        by mx.google.com with ESMTPSA id x45sm24667490eeu.23.2014.03.30.02.58.15
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 30 Mar 2014 02:58:15 -0700 (PDT)
From: GEO <1g2e3o4@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Backup: Compare sent snapshots
Date: Sun, 30 Mar 2014 10:58:13 +0200
Message-ID: <8465933.4bvG1Xk5zJ@linuxpc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am doing backups regularly following the scheme of 
https://btrfs.wiki.kernel.org/index.php/Incremental_Backup

It states we keep a local reference of the read only snapshot we sent to the 
backup drive, which I understand.
But now I have a question:  When I do a read only snapshot of home, send the 
difference to the backup drive, keep it until the next incremental step, send 
the difference to the backup drive, remove the old read only snapshot and so 
on...
I wonder what happens if the read only snapshot I keep as a local reference 
got corrupted somehow. 
Then maybe too much difference would be sent which would not be dramatic, or 
too less, which would be. 
Is there a quick way I could compare the last sent snapshot to the local one, 
to make sure the local reference is still the same?

Apart from that, imagine I somehow lost the local reference (e.g. delete it by 
mistake), would there still be a way to sync the difference to the last sent 
snapshot on the backup device?



