Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:36577 "EHLO
	mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbbH3RRp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Aug 2015 13:17:45 -0400
Received: by vkbc123 with SMTP id c123so28326971vkb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Aug 2015 10:17:44 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 30 Aug 2015 11:17:44 -0600
Message-ID: <CAJCQCtSx8yvtbm+7i3bNtv1DaRtTAgRTdk+iMTrk5nNhssgRLQ@mail.gmail.com>
Subject: mount command now shows subvol and subvolid
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Does anyone know when this changed? Maybe it's a 4.2 thing... anyway
it's very much welcome!

/dev/sda2 on /home type btrfs
(rw,relatime,seclabel,space_cache,subvolid=258,subvol=/home)

/dev/sdc1 on /brick0 type btrfs
(rw,relatime,seclabel,space_cache,subvolid=5,subvol=/)

/dev/sde on /brick1 type btrfs
(rw,relatime,seclabel,space_cache,subvolid=5,subvol=/)




-- 
Chris Murphy
