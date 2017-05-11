Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vsmx011.vodafonemail.xion.oxcs.net ([153.92.174.89]:45392 "EHLO
        vsmx011.vodafonemail.xion.oxcs.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751282AbdEKUZG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 May 2017 16:25:06 -0400
Received: from vsmx003.vodafonemail.xion.oxcs.net (unknown [192.168.75.197])
        by mta-5-out.mta.xion.oxcs.net (Postfix) with ESMTP id 682E03E0324
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 20:17:16 +0000 (UTC)
Received: from [192.168.0.1] (unknown [91.10.21.65])
        by mta-7-out.mta.xion.oxcs.net (Postfix) with ESMTPA id 0B719300490
        for <linux-btrfs@vger.kernel.org>; Thu, 11 May 2017 20:17:13 +0000 (UTC)
From: Ochi <ochi@arcor.de>
Subject: Creating btrfs RAID on LUKS devs makes devices disappear
To: linux-btrfs@vger.kernel.org
Message-ID: <0e7ef6b4-7a81-fc66-942e-411f238d631e@arcor.de>
Date: Thu, 11 May 2017 22:17:12 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

while trying to initialize a btrfs RAID1 on my new NAS using LUKS 
crypt-devices for each of the btrfs RAID devices, I have seen "random" 
weirdness shortly after mkfs.

It seems to boil down to the problem that after mkfs.btrfs, some of the 
/dev/dm-* nodes (as well as the corresponding /dev/mapper/* symlinks) 
sometimes disappear. The RAID can be mounted at first but quickly shows 
symptoms such as missing devices, or being unable to mount the second time.

I have tried to btrfs.mkfs -d raid1 -m raid1 using the /dev/dm-* and 
/dev/mapper/* devices, but with similar results.

By best guess is that the fact that one UUID is given to multiple 
separate devices confuses... something (udev or the like?), making nodes 
appear, disappear or being re-ordered while mkfs is in progress, or 
leading to unexpected things later at mount time.

Honestly, the idea of the same UUID being given to separate physical 
devices scared me already when I first saw it. Could that actually be 
the culprit here?

Best regards
Sebastian
