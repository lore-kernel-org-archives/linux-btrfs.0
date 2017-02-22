Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:58223 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754329AbdBVHpE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 22 Feb 2017 02:45:04 -0500
Received: from [10.0.0.4] ([95.171.32.30]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MQQzk-1clvE03xyG-00TnE9 for
 <linux-btrfs@vger.kernel.org>; Wed, 22 Feb 2017 08:45:01 +0100
Subject: Re: BTRFS critical: corrupt leaf, slot offset bad; then read-only
To: linux-btrfs@vger.kernel.org
References: <7d3cccae-4761-4799-9ceb-2735519bee8f@gmx.net>
From: Lukas Tribus <lukyt@gmx.net>
Message-ID: <0d721199-9407-ff6b-7a31-4dc5dae08e7b@gmx.net>
Date: Wed, 22 Feb 2017 08:44:58 +0100
MIME-Version: 1.0
In-Reply-To: <7d3cccae-4761-4799-9ceb-2735519bee8f@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Upgrading to 4.8, the FS no longer causes a kernel calltrace and does 
not go read-only. It only shows the "corrupt leaf, slot offset bad" message.

A scrub completed without errors on 3 devices, while it was aborted on 2 
devices. Not sure why it was aborted, since there is no error message in 
dmesg?


Any suggestions why the scrub was aborted?



# uname -a
Linux srv1-dom0 4.8.0-36-generic #36~16.04.1-Ubuntu SMP Sun Feb 5 
09:39:57 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
# btrfs scrub status /storage/users/
scrub status for f50f980e-7640-49c7-bf8d-20d55cfe6005
         scrub started at Wed Feb 22 00:07:33 2017 and was aborted after 
06:35:42
         total bytes scrubbed: 10.60TiB with 0 errors
/# btrfs scrub status /storage/users/ -d
scrub status for f50f980e-7640-49c7-bf8d-20d55cfe6005
scrub device /dev/dm-5 (id 1) history
         scrub started at Wed Feb 22 00:07:33 2017 and finished after 
06:35:36
         total bytes scrubbed: 2.30TiB with 0 errors
scrub device /dev/dm-6 (id 2) history
         scrub started at Wed Feb 22 00:07:33 2017 and finished after 
06:35:30
         total bytes scrubbed: 2.30TiB with 0 errors
scrub device /dev/dm-7 (id 3) history
         scrub started at Wed Feb 22 00:07:33 2017 and finished after 
06:35:42
         total bytes scrubbed: 2.30TiB with 0 errors
scrub device /dev/dm-8 (id 4) history
         scrub started at Wed Feb 22 00:07:33 2017 and was aborted after 
05:01:37
         total bytes scrubbed: 1.85TiB with 0 errors
scrub device /dev/mapper/sde3_crypt (id 5) history
         scrub started at Wed Feb 22 00:07:33 2017 and was aborted after 
05:01:37
         total bytes scrubbed: 1.85TiB with 0 errors
#dmesg | grep BTRFS
[  929.737119] BTRFS critical (device dm-9): corrupt leaf, slot offset 
bad: block=5242107641856,root=1, slot=39
[19772.594129] BTRFS critical (device dm-9): corrupt leaf, slot offset 
bad: block=5242107641856,root=1, slot=39
[19777.127704] BTRFS critical (device dm-9): corrupt leaf, slot offset 
bad: block=5242107641856,root=1, slot=39
[19777.552191] BTRFS critical (device dm-9): corrupt leaf, slot offset 
bad: block=5242107641856,root=1, slot=39
#

