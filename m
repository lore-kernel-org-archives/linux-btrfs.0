Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:32861 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbbHSPje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 11:39:34 -0400
Received: by wijp15 with SMTP id p15so130242376wij.0
        for <linux-btrfs@vger.kernel.org>; Wed, 19 Aug 2015 08:39:33 -0700 (PDT)
Received: from [192.168.1.73] (LPuteaux-657-1-134-185.w193-248.abo.wanadoo.fr. [193.248.193.185])
        by smtp.googlemail.com with ESMTPSA id ck18sm1523277wjb.47.2015.08.19.08.39.31
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Wed, 19 Aug 2015 08:39:32 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Leo Unbekandt <leo.unbek@gmail.com>
Subject: BTRFS deadlock when OOM killed processes using the file system
Message-ID: <55D4A331.7000202@gmail.com>
Date: Wed, 19 Aug 2015 17:39:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I've encountered what looks like a nasty bug which occures when the OOM
kills a process and that this process is working with the file system.
I've been able to reproduce this issue using docker, by limiting the
memory limits of process and make them crash when working.

(You can find more information there: my post on Docker bug tracker, but
it seems that it is more a BTRF-related issue
https://github.com/docker/docker/issues/15654#issuecomment-132384763)

Once the processes have been killed, a BTRFS kworker switched in
uninterruptible (state D) IO wait, and the file system is completely
unusable, no way to read or write from it which is pretty critical, in
my case Docker is not usable anymore as btrfs is the used storage backend.

OOM logs: http://pastebin.com/Lb4Gybay (Simple OOM logs)
BTRFS freeze and uninterruptible processes (plus Sysrq-w):
http://pastebin.com/qd1yB8u2

Hoping that I've got enough information, tell me if you need more. Now
I'm able to reproduce quite easily.

Thank you,

--
Leo Unbekandt
@Soulou

~# uname -a
Linux <hostname> 3.19.0-26-generic #28~14.04.1-Ubuntu SMP Wed Aug 12
14:09:17 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux

~# btrfs --version
Btrfs v3.12

~# btrfs fi show
Label: none  uuid: c36b7b1d-910e-4af7-b671-b6d437c4b8d5
    Total devices 1 FS bytes used 34.03GiB
    devid    1 size 100.00GiB used 44.04GiB path /dev/dm-0

btrBtrfs v3.12

~# btrfs fi df /var/lib/docker
Data, single: total=35.01GiB, used=31.77GiB
System, DUP: total=8.00MiB, used=16.00KiB
System, single: total=4.00MiB, used=0.00
Metadata, DUP: total=4.50GiB, used=2.25GiB
Metadata, single: total=8.00MiB, used=0.00
unknown, single: total=512.00MiB, used=0.00

~# dmesg.log

http://pastebin.com/S5DvJjxQ


