Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317AbaFRScX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 14:32:23 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: greg@kroah.com, kamal.mostafa@canonical.com, luis.henriques@canonical.com,
        jslaby@suse.cz
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [v3.10.y][v3.11.y][3.12.y][v3.13.y][v3.14.y][SRU][PATCH 0/1][V2] ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined
Date: Wed, 18 Jun 2014 14:32:15 -0400
Message-Id: <cover.1403113867.git.joseph.salisbury@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Please consider including upstream commit b7a77235 in the next v3.13.y release.  It was included upstream as of v3.15-rc5.  It has been tested and confirmed to resolve http://bugs.launchpad.net/bugs/1319457 .

commit b7a7723513dc89f83d6df13206df55d4dc26e825
Author: Sander Eikelenboom <linux@eikelenboom.it>
Date:   Fri May 2 15:09:27 2014 +0200

    ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined


This original commit does not apply cleanly to v3.13, so I performed a backport, which is in email 1/1.  The backport has been tested and cleanly applies to upstream 3.10.y, 3.11.y, 3.12.y and 3.14.y.  The backport is not applicable to longterm stable 3.2.y or 3.4.y.


Sander Eikelenboom (1):
  ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log
    while DEBUG not defined

 sound/usb/pcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

-- 
2.0.0

