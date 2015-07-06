Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:51099 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbbGFTo5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 6 Jul 2015 15:44:57 -0400
Received: from [127.0.0.1] ([88.71.42.237]) by mrelayeu.kundenserver.de
 (mreue002) with ESMTPA (Nemesis) id 0Ly6KL-1Z0Bnf47GP-015WqW for
 <linux-btrfs@vger.kernel.org>; Mon, 06 Jul 2015 21:44:55 +0200
Message-ID: <559ADAB5.3050804@friedels.name>
Date: Mon, 06 Jul 2015 21:44:53 +0200
From: Hendrik Friedel <hendrik@friedels.name>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: size 2.73TiB used 240.97GiB  after balance
References: <559AD4E5.2030107@friedels.name>
In-Reply-To: <559AD4E5.2030107@friedels.name>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

ok, sdc seems to have failed (sorry, I checked only sdd and sdb SMART 
values, as sdc is brand new. Maybe a bad assumption, from my side.

I have mounted the device
mount -o recovery,ro

So, what should I do now:
btrfs device delete /dev/sdc /mnt

or

mount -o degraded /dev/sdb /mnt
btrfs device delete missing /mnt

I do have a backup of the most valuable data.
But if you consider one of the above options risky, I might better get a 
new drive before, but this might take a couple of days (in which sdc 
could further degrade).
What is your recommendation?


Regards,
Hendrik

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

