Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:38056 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727004AbeIMNnH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Sep 2018 09:43:07 -0400
Received: by mail-wm0-f66.google.com with SMTP id t25-v6so5180324wmi.3
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 01:34:40 -0700 (PDT)
Received: from t-5.eu (p5B2838D7.dip0.t-ipconnect.de. [91.40.56.215])
        by smtp.gmail.com with ESMTPSA id t9-v6sm52263wmf.1.2018.09.13.01.34.38
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 13 Sep 2018 01:34:38 -0700 (PDT)
Received: from t-5.eu (localhost [127.0.0.1])
        by t-5.eu (Postfix) with ESMTP id A5D9E1305DB
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Sep 2018 10:34:37 +0200 (CEST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 13 Sep 2018 10:34:37 +0200
From: =?UTF-8?Q?J=C3=BCrgen_Herrmann?= <t-5@t-5.eu>
To: linux-btrfs@vger.kernel.org
Subject: btrfs send hangs after partial transfer and blocks all IO
Message-ID: <8c2c436d404bca00617614d08e9720c1@t-5.eu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

I have a newly installed laptop running a freshly installed (abt. two 
months ago) laptop running latest linux mint 19. Root filesystem is on a 
1TB Samsung 860 M.2 SSD with btrfs on top of a LUKS encrypted 900G 
partition. Timeshift-btrfs is enabled for root (@) and home (@home) 
subvolumes. I want to transfer snapshots to a server with a separated 
disk via "btrfs send" and ssh.

Here's the list of snapshot directories, each containing tow snapshots 
for root and home:

drwxr-xr-x 1 root root 30 Sep 12 22:08 2018-08-16_20-00-01
drwxr-xr-x 1 root root 30 Aug 17 14:00 2018-08-17_14-00-02
drwxr-xr-x 1 root root 30 Aug 23 20:00 2018-08-23_20-00-01
drwxr-xr-x 1 root root 30 Aug 30 20:00 2018-08-30_20-00-01
drwxr-xr-x 1 root root 30 Sep  6 20:00 2018-09-06_20-00-01
drwxr-xr-x 1 root root 30 Sep  6 22:00 2018-09-06_22-00-01
drwxr-xr-x 1 root root 30 Sep  8 16:00 2018-09-08_16-00-01
drwxr-xr-x 1 root root 30 Sep 10 20:00 2018-09-10_20-00-02
drwxr-xr-x 1 root root 30 Sep 11 21:00 2018-09-11_21-00-02
drwxr-xr-x 1 root root 30 Sep 12 21:00 2018-09-12_21-00-01

"btrfs send 
/mnt/timeshift/backup/timeshift-btrfs/snapshots/2018-08-16_20-00-01/@ 
 >/dev/null" results in the btrfs task taking 100% cpu time on one cpu and then all IO is blocked -> only reboot can solve the hang.

The crash does not happen immediately, as i was on the road using 
cellular connection it seemed fine at first. That's how I found out that 
it transfers ~140MB of data before hanging. The snapshot is created on 
the server and contains data (du shows abt 140MB).

I am running vanilla kernel 4.18.6 (compiled by myself) and btrfs progs 
4.17.1 compiled from source.

Here's the btrfs filesystem info:
Label: none  uuid: a914c141-72bf-448b-847f-d64ee82d8b7b
         Total devices 1 FS bytes used 342.85GiB
         devid    1 size 875.44GiB used 357.05GiB path 
/dev/mapper/sda3_crypt

A scrub shows no errors:
scrub status for a914c141-72bf-448b-847f-d64ee82d8b7b
         scrub started at Thu Sep 13 10:20:18 2018 and finished after 
00:12:19
         total bytes scrubbed: 342.78GiB with 0 errors

What can I do to help debugging this issue?

Best regards,
Jürgen
-- 
Jürgen Herrmann
https://t-5.eu
ALbertstraße 2
94327 Bogen
