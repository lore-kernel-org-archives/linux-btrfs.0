Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:50073 "EHLO
	postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbaGPWRS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 18:17:18 -0400
Received: from [192.168.0.57] (p5B0A04FC.dip0.t-ipconnect.de [91.10.4.252])
	by postfix.iai.uni-bonn.de (Postfix) with ESMTP id 422805C442
	for <linux-btrfs@vger.kernel.org>; Thu, 17 Jul 2014 00:17:15 +0200 (MEST)
	(envelope-from ochmann@informatik.uni-bonn.de)
	(envelope-to linux-btrfs@vger.kernel.org) (1)
	(internal use: ta=1, tu=1, te=1, am=P, au=ochmann)
Message-ID: <53C6FA3D.9010803@informatik.uni-bonn.de>
Date: Thu, 17 Jul 2014 00:18:37 +0200
From: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Is it safe to mount subvolumes of already-mounted volumes (even with
 different options)?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I'm sharing a btrfs-formatted drive between multiple computers and each 
of the machines has a separate home directory on that drive. The root of 
the drive is mounted at /mnt/tray and the home directory for machine 
{hostname} is under /mnt/tray/Homes/{hostname}. Up until now, I have 
mounted /mnt/tray like a normal volume and then did an additional 
bind-mount of /mnt/tray/Homes/{hostname} to /home.

Now I have a new drive and wanted to do things a bit more advanced by 
creating subvolumes for each of the machines' home directories so that I 
can also do independent snapshotting. I guess I could use the bind-mount 
method like before but my question is if it is considered safe to do an 
additional, "regular" mount of one of the subvolumes to /home instead, like

mount /dev/sdxN /mnt/tray
mount -o subvol=/Homes/{hostname} /dev/sdxN /home

When I experimented with such additional mounts of subvolumes of 
already-mounted volumes, I noticed that the mount options of the 
additional subvolume mount might differ from the "original" mount. For 
instance, the root volume might be mounted with "noatime" while the 
subvolume mount may have "relatime".

So my questions are: Is mounting a subvolume of an already mounted 
volume considered safe and are there any combinations of possibly 
conflicting mount options one should be aware of (compression, 
autodefrag, cache clearing)? Is it advisable to use the same mount 
options for all mounts pointing to the same physical device?

Best regards,
Sebastian
