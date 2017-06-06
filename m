Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:33287 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbdFFENb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Jun 2017 00:13:31 -0400
Received: by mail-qt0-f180.google.com with SMTP id u12so91579145qth.0
        for <linux-btrfs@vger.kernel.org>; Mon, 05 Jun 2017 21:13:31 -0700 (PDT)
MIME-Version: 1.0
From: Steven Bell <stv.bell07@gmail.com>
Date: Tue, 6 Jun 2017 00:13:30 -0400
Message-ID: <CABCBvj3XtoSO-Kavv4ur3G+Jnm3fBijoBAbfqt+LTRtXo1cmrA@mail.gmail.com>
Subject: device-mapper btrfs Warning Spam
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all,


I have a btrfs raid-0 array (initially a raid-6 but long ago converted
due to warnings not to use raid56, not that I think this impacts my
situation).

One of the disks in the array started to go bad. Some bad sectors
meant one of my video files was unable to be read. This issue was
discovered during a btrfs scrub.

By deleting the offending file occupying the bad sector, I was able to
successfully remove the offending disk from the array. Replacement
disk is in and no issues, restored the file from backup. Great.


My problem now is the following warning message repeatedly spamming my
system logs every minute (even after fresh reboot and everything with
the disk management settled).

"kernel: device-mapper: core: btrfs: sending ioctl 5331 to DM device
without required privilege."

I have never seen the error before the disk issue, and I have
confirmed it only started after a reboot after the disk had started
going bad. I've not been able to figure out any other factors that
maybe contributing.

Everything appears functional and without issue, and I see no
consequences of these messages in system performance or behaviour.

I'm running fully updated Fedora 25 which is using btrfs-progs version
4.6.1-1.fc25 on kernel 4.11.3-200.fc25.x86_64.


Has anyone ever seen this issue? Any help or advice would be greatly
appreciated, thank you.


Regards,

Steven
