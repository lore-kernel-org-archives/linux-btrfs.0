Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:37099 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756036AbcH1UP1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Aug 2016 16:15:27 -0400
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: btrfs and systemd
Message-ID: <47ee55de-a77b-185a-1a01-b8b39899b188@profihost.ag>
Date: Sun, 28 Aug 2016 22:15:21 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

i'm trying to get my 60TB btrfs volume to mount with systemd at boot.
But this always fails with: "mounting timed out. Stopping." after 90s.

I can't find any fstab setting for systemd to higher this timeout.
There's just  the x-systemd.device-timeout but this controls how long to
wait for the device and not for the mount command.

Is there any solution for big btrfs volumes and systemd?

Greets,
Stefan
