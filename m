Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62002 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265AbaHFVU3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Aug 2014 17:20:29 -0400
Received: by mail-wi0-f181.google.com with SMTP id bs8so3910526wib.8
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Aug 2014 14:20:28 -0700 (PDT)
Received: from linuxpc.localnet (194-166-58-156.adsl.highway.telekom.at. [194.166.58.156])
        by mx.google.com with ESMTPSA id 10sm5071364wjr.22.2014.08.06.14.20.22
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Wed, 06 Aug 2014 14:20:22 -0700 (PDT)
From: GEO <1g2e3o4@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs send handle missing space on target device
Date: Wed, 06 Aug 2014 23:20:20 +0200
Message-ID: <8854735.1A2mADRSs8@linuxpc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I wonder how I should handle missing space on the backup device when doing 
incremental backup with btrfs send?
I mean for the initial bootstrap it is easy, I simply compare the free space 
of the target device with the size of home (we are talking about incremental 
backups of home), but how should I handle this with

sudo btrfs send -p @home-backup @home-backup | sudo btrfs receive /mnt/backup/

What will happen by default if the space on the target is not enough? Will the 
command start writing to  /mnt/backup/ at all and stop when the disk is full, 
or will it return an error code? If it doesn't return an error code, how can I 
handle this before the transaction?

Thanks in advance!
