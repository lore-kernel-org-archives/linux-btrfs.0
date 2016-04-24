Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:34945 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbcDXMLd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Apr 2016 08:11:33 -0400
Received: by mail-ig0-f174.google.com with SMTP id bi2so45884720igb.0
        for <linux-btrfs@vger.kernel.org>; Sun, 24 Apr 2016 05:11:33 -0700 (PDT)
MIME-Version: 1.0
From: lenovomi <lenovomi@gmail.com>
Date: Sun, 24 Apr 2016 14:11:03 +0200
Message-ID: <CAAcrkY+i1QW0dW5y3=szq9vJh8946shAvCehefbRKW4xqv_zBA@mail.gmail.com>
Subject: restore is failing
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hi,

i run restore command and it restored around 300GB of data from 11TB
but failed here



Skipping existing file
/mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/hosts
Restoring /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
Error creating /mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp:
22
Error searching
/mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
Error searching
/mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
Error searching
/mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
Error searching
/mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
Error searching
/mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
Error searching
/mnt/u/backups/huszi-drive/cubox-rescue/home/alarm/etc/idmapd.conf�.bkp
extent buffer leak: start 17802812047360 len 16384


Any idea why? is it because of the <?> character?

my target directory /mnt/restore is nfs mount point.


thanks
