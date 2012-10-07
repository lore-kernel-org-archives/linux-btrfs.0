Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp12.smtpout.orange.fr ([80.12.242.134]:37710 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2JGNOJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Oct 2012 09:14:09 -0400
Message-ID: <5071801B.4090704@petaramesh.org>
Date: Sun, 07 Oct 2012 15:14:03 +0200
From: =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS, getting darn slower everyday
References: <50714AC8.4010100@petaramesh.org> (sfid-20121007_121057_935818_E179B3F4) <201210071500.43204.Martin@lichtvoll.de>
In-Reply-To: <201210071500.43204.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 07/10/2012 15:00, Martin Steigerwald a écrit :
> I forgot to mention mount options? Which one do you use?
root@tethys:/etc# grep btrfs fstab
/dev/VG1/BTR_POOL    /    btrfs   
subvol=UBUNTU/@,space_cache,autodefrag,compress=lzo,relatime        0 0
/dev/sda2        /boot    btrfs   
subvol=UBUNTU/@boot,space_cache,autodefrag,relatime            0 0
/dev/VG1/BTR_POOL    /tmp    btrfs   
subvol=UBUNTU/@tmp,space_cache,autodefrag,compress=lzo,relatime        0 0
/dev/VG1/BTR_POOL    /home    btrfs   
subvol=UBUNTU/@home,space_cache,autodefrag,compress=lzo,relatime    0 0
/dev/VG1/BTR_POOL    /storage    btrfs   
subvol=STORAGE,space_cache,autodefrag,compress=lzo,relatime    0 0
/dev/VG1/BTR_POOL    /data/BIG        btrfs   
subvol=DATA/BIG,space_cache,compress=lzo,noatime    0 0
/dev/VG1/BTR_POOL    /data/VBOX_HIDDEN    btrfs   
subvol=DATA/VBOX_HIDDEN,space_cache,compress=lzo,noatime    0 0
/dev/VG1/BTR_POOL    /data/VBOX_VMS        btrfs   
subvol=DATA/VBOX_VMS,space_cache,compress=lzo,noatime    0 0


-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E
Ne cherchez pas : Je ne suis pas sur Facebook.

