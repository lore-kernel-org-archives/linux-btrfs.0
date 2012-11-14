Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:40427 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422898Ab2KNNmO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 08:42:14 -0500
Message-ID: <50A39FAF.50602@profihost.ag>
Date: Wed, 14 Nov 2012 14:42:07 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Sage Weil <sage@inktank.com>
CC: "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>, miaox@cn.fujitsu.com
Subject: problem with ceph and btrfs patch: set journal_info in async trans
 commit worker
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello list,

i wanted to try out ceph with latest vanilla kernel 3.7-rc5. I was 
seeing a massive performance degration. I see around 22x 
btrfs-endio-write processes every 10-20 seconds and they run a long time 
while consuming a massive amount of CPU.

So my performance of 23.000 iops drops to an up and down of 23.000 iops 
to 0 - avg is now 2500 iops instead of 23.000.

Git bisect shows me commit: e209db7ace281ca347b1ac699bf1fb222eac03fe 
"Btrfs: set journal_info in async trans commit worker" as the 
problematic patch.

When i revert this one everything is fine again.

Is this known?

Greets,
Stefan
