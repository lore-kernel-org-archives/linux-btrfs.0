Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:50534 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751664AbcLQU1r (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Dec 2016 15:27:47 -0500
MIME-Version: 1.0
Message-ID: <trinity-2653fb5f-aa88-4ece-bced-51dee466d428-1482006464623@3capp-mailcom-bs11>
From: "Xin Zhou" <xin.zhou@gmx.com>
To: =?UTF-8?Q?=22Jari_Sepp=C3=A4l=C3=A4=22?=
        <lihamakaroonilaatikko@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Help please: BTRFS fs crashed due to bad removal of USB drive,
 no help from recovery procedures
Content-Type: text/plain; charset=UTF-8
Date: Sat, 17 Dec 2016 21:27:44 +0100
In-Reply-To: <66A9C2C6-028F-466B-9EFF-F06BF3FB4694@gmail.com>
References: <66A9C2C6-028F-466B-9EFF-F06BF3FB4694@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Hi Jari,
 
Similar with other file system, btrfs has copies of super blocks.
Try to run "man btrfs check", "man btrfs rescue" and related commands for more details.
Regards,
Xin
 
 

Sent: Saturday, December 17, 2016 at 2:06 AM
From: "Jari Seppälä" <lihamakaroonilaatikko@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Help please: BTRFS fs crashed due to bad removal of USB drive, no help from recovery procedures
Syslog tells:
[ 135.446222] BTRFS error (device sdb1): system chunk array too small 0 < 97
[ 135.446260] BTRFS error (device sdb1): superblock contains fatal errors
[ 135.462544] BTRFS error (device sdb1): open_ctree failed

What have been done:
* All "btrfs rescue" options

Info on system
* fs on external SSD via USB
* kernel 4.9.0 (tried with 4.8.13)
* btrfs-tools 4.4
* Mythbuntu (Ubuntu) 16.04.1 LTS with latest fixes 2012-12-16

Any help appreciated. Around 300G of TV recordings on the drive, which of course will eventually come as replays.

Jari
--
*** Jari Seppälä

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at http://vger.kernel.org/majordomo-info.html
