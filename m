Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64107 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758958Ab2FHA55 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2012 20:57:57 -0400
Received: by lbbgm6 with SMTP id gm6so991096lbb.19
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2012 17:57:56 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 7 Jun 2012 20:57:55 -0400
Message-ID: <CACfbfuUvZHCWiFuiZpBiw1G59W35gttSd9XV4tJhBSAn1_-p-w@mail.gmail.com>
Subject: USB drives going away and causing problems for btrfs
From: Marco Ceppi <ceppi.marco@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have three hard-drives attached to a media pc via USB (yes, this is
far from idea and I'm procuring the hardware to resolve this). As USB
seems to be crap in general (or something is not working) the drives
get dropped from time to time. In past times this hasn't been an
issue. I was able to force umount the stale mount point and re-mount
with the new device names (/dev/sdb, /dev/sdc, /deb/sdd being
re-written to /dev/sdd, sde, sdf). However, this evening when this
happened the drives wouldn't come back up. After speaking with
darkwing in the the #btrfs room it looks as though the metadata is
corrupt. I've gathered all the logs I could of the incident and
aftermath in hopes that it will help lead developers to better error
handling when poor fools, such as myself, attach large drives via USB.

Kernel log of the dropping incident: http://paste.ubuntu.com/1029622/
btrfsck: http://paste.ubuntu.com/1029589/
btrfs-debug-tree after a reboot: http://paste.ubuntu.com/1029635/
btrfs fi show: http://paste.ubuntu.com/1029638/

Linux media-pc 3.4.0-4-generic #9~precise1-Ubuntu SMP Tue Jun 5
01:25:26 UTC 2012 x86_64 x86_64 x86_64 GNU/Linux
btrfs-tools  0.19+20120421-0daily6~bzr457~precise1

Running btrfsck with the --super options and --repair yielded the same
results. If there are any additional logs I could provide or questions
i could answer let me know.

Thanks,
Marco Ceppi
