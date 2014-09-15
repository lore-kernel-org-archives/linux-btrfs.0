Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f169.google.com ([209.85.216.169]:62415 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbaIOQgk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 12:36:40 -0400
Received: by mail-qc0-f169.google.com with SMTP id r5so4451439qcx.28
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Sep 2014 09:36:34 -0700 (PDT)
Received: from [192.168.11.50] ([98.113.246.12])
        by mx.google.com with ESMTPSA id e4sm9838659qgf.32.2014.09.15.09.36.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Sep 2014 09:36:33 -0700 (PDT)
Message-ID: <5417158B.4010700@gmail.com>
Date: Mon, 15 Sep 2014 12:36:27 -0400
From: Elliot Wolk <elliot.wolk@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: restore breaks incremental backup
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

restoring from an incremental backup breaks the parent UUIDs, making it 
impossible to continue doing incremental backup.

1) assume you do incremental backup from "home" to "BACKUP":
btrfs subvol snapshot -r /home /home/backup1
btrfs send /home/backup1 | btrfs receive /BACKUP
btrfs subvol snapshot -r /home /home/backup2
btrfs send /home/backup2 -p /home/backup1 | btrfs receive /BACKUP


2) then you delete "home", mkfs.btrfs, and attempt to restore:
btrfs send /BACKUP/backup2 | btrfs receive /home
btrfs subvol snapshot /home /home/home-rw
btrfs subvol snapshot -r /home/home-rw /home/home-rw/backup3
btrfs send /home/home-rw/backup3 -p /home/backup2 | btrfs receive /BACKUP
#send|receive fails with "parent not found"
#the next step would be to set-default to home-rw, remount, and continue 
inc backup as above

receive fails with "parent not found", which makes sense since the 
parent UUIDs are not the same, but is highly undesirable. i need to 
delete my backup drive and reseed which is mucho scary. perhaps there is 
some obvious way to do this that im missing?

thanks, and sorry if this is too vague or is not actually a misfeature. 
let me know if theres anything i can do to help. {please CC me for 
replies, im not subscribed}

