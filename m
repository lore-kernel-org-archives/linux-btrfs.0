Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:9724 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753017AbdHJUAM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 10 Aug 2017 16:00:12 -0400
Received: from mordor.fritz.box (xd9328886.dyn.telefonica.de [217.50.136.134])
        by smtp.strato.de (RZmta 41.1 DYNA|AUTH)
        with ESMTPSA id z0726ft7AK08JWL
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate)
        for <linux-btrfs@vger.kernel.org>;
        Thu, 10 Aug 2017 22:00:08 +0200 (CEST)
Message-ID: <1502395208.3361.1.camel@cloud.haefemeier.eu>
Subject: Replace missing disc => strange result!?
From: Cloud Admin <admin@cloud.haefemeier.eu>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: Thu, 10 Aug 2017 22:00:08 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I had a disc failure and must replace it. I followed the description on
 https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devi
ces and started the replacement.
Setup is a two disc RAID1!
After it was done, I called 'btrfs fi us /mn/btrfsroot' and I got the
output below. What is wrong?
Is it a rebalancing issue? I thought the replace command started it
automatically...

Overall:
    Device size:		   3.64TiB
    Device allocated:		   1.04TiB
    Device unallocated:		   2.60TiB
    Device missing:		     0.00B
    Used:			 519.76GiB
    Free (estimated):		   1.56TiB	(min: 1.56TiB)
    Data ratio:			      2.00
    Metadata ratio:		      1.60
    Global reserve:		 279.11MiB	(used: 0.00B)

Data,single: Size:1.00GiB, Used:0.00B
   /dev/mapper/luks-3ff6c412-4d3a-4d33-85a3-cc70e95c26f8	   1.00
GiB

Data,RAID1: Size:265.00GiB, Used:259.60GiB
   /dev/mapper/luks-3ff6c412-4d3a-4d33-85a3-cc70e95c26f8	 265.00
GiB
   /dev/mapper/luks-ff4bf5da-48af-4563-abb2-db083bd01512	 265.00
GiB

Data,DUP: Size:264.00GiB, Used:0.00B
   /dev/mapper/luks-3ff6c412-4d3a-4d33-85a3-cc70e95c26f8	 528.00
GiB

Metadata,single: Size:1.00GiB, Used:0.00B
   /dev/mapper/luks-3ff6c412-4d3a-4d33-85a3-cc70e95c26f8	   1.00
GiB

Metadata,RAID1: Size:1.00GiB, Used:286.03MiB
   /dev/mapper/luks-3ff6c412-4d3a-4d33-85a3-cc70e95c26f8	   1.00
GiB
   /dev/mapper/luks-ff4bf5da-48af-4563-abb2-db083bd01512	   1.00
GiB

Metadata,DUP: Size:512.00MiB, Used:112.00KiB
   /dev/mapper/luks-3ff6c412-4d3a-4d33-85a3-cc70e95c26f8	   1.00
GiB

System,single: Size:32.00MiB, Used:0.00B
   /dev/mapper/luks-3ff6c412-4d3a-4d33-85a3-cc70e95c26f8	  32.00
MiB

System,RAID1: Size:8.00MiB, Used:48.00KiB
   /dev/mapper/luks-3ff6c412-4d3a-4d33-85a3-cc70e95c26f8	   8.00
MiB
   /dev/mapper/luks-ff4bf5da-48af-4563-abb2-db083bd01512	   8.00
MiB

System,DUP: Size:32.00MiB, Used:48.00KiB
   /dev/mapper/luks-3ff6c412-4d3a-4d33-85a3-cc70e95c26f8	  64.00
MiB

Unallocated:
   /dev/mapper/luks-3ff6c412-4d3a-4d33-85a3-cc70e95c26f8	   1.04
TiB
   /dev/mapper/luks-ff4bf5da-48af-4563-abb2-db083bd01512	   1.56
TiB

Bye
	Frank
