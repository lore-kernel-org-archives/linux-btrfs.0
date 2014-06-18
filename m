Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:33526 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaFRScX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jun 2014 14:32:23 -0400
From: Joseph Salisbury <joseph.salisbury@canonical.com>
To: greg@kroah.com, kamal.mostafa@canonical.com, luis.henriques@canonical.com,
        jslaby@suse.cz
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [v3.10.y][v3.11.y][v3.12.y][v3.13.y][v3.14.y][PATCH 1/1][V2] ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log while DEBUG not defined
Date: Wed, 18 Jun 2014 14:32:16 -0400
Message-Id: <a377cdb51b1a98e9fa6bffaa124502fc15c47903.1403113867.git.joseph.salisbury@canonical.com>
In-Reply-To: <cover.1403113867.git.joseph.salisbury@canonical.com>
References: <cover.1403113867.git.joseph.salisbury@canonical.com>
In-Reply-To: <cover.1403113867.git.joseph.salisbury@canonical.com>
References: <cover.1403113867.git.joseph.salisbury@canonical.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

From: Sander Eikelenboom <linux@eikelenboom.it>

BugLink: http://bugs.launchpad.net/bugs/1319457

This (widely used) construction:

if(printk_ratelimit())
	dev_dbg()

Causes the ratelimiting to spam the kernel log with the "callbacks suppressed"
message below, even while the dev_dbg it is supposed to rate limit wouldn't
print anything because DEBUG is not defined for this device.

[  533.803964] retire_playback_urb: 852 callbacks suppressed
[  538.807930] retire_playback_urb: 852 callbacks suppressed
[  543.811897] retire_playback_urb: 852 callbacks suppressed
[  548.815745] retire_playback_urb: 852 callbacks suppressed
[  553.819826] retire_playback_urb: 852 callbacks suppressed

So use dev_dbg_ratelimited() instead of this construction.

Signed-off-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
(backported from commit b7a7723513dc89f83d6df13206df55d4dc26e825)
Signed-off-by: Joseph Salisbury <joseph.salisbury@canonical.com>
---
 sound/usb/pcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index ca3256d..ede4b92 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -1488,7 +1488,8 @@ static void retire_playback_urb(struct snd_usb_substream *subs,
 	 * on two reads of a counter updated every ms.
 	 */
 	if (abs(est_delay - subs->last_delay) * 1000 > runtime->rate * 2)
-		snd_printk(KERN_DEBUG "delay: estimated %d, actual %d\n",
+		dev_dbg_ratelimited(&subs->dev->dev,
+			"delay: estimated %d, actual %d\n",
 			est_delay, subs->last_delay);
 
 	if (!subs->running) {
-- 
2.0.0

