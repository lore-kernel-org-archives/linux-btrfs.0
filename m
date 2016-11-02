Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:34649 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932488AbcKBVzS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 17:55:18 -0400
Received: by mail-lf0-f65.google.com with SMTP id o141so411337lff.1
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Nov 2016 14:55:17 -0700 (PDT)
Received: from [10.0.0.101] (179.79-161-153.customer.lyse.net. [79.161.153.179])
        by smtp.googlemail.com with ESMTPSA id u63sm811790lja.34.2016.11.02.14.55.15
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Nov 2016 14:55:15 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Tom Arild Naess <tanaess@gmail.com>
Subject: btrfs scrub with unexpected results
Message-ID: <84df8b17-65ac-0f40-cf19-471b3664b0b3@gmail.com>
Date: Wed, 2 Nov 2016 22:55:14 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I have been running btrfs on a file server and backup server for a 
couple of years now, both set up as RAID 10. The file server has been 
running along without any problems since day one. My problems has been 
with the backup server.

A little background about the backup server before I dive into the 
problems. The server was a new build that was set to replace an aging 
machine, and my intention was to start using btrfs send/receive instead 
of hard links for the backups. Since I had 8x the space on the new 
server, I just rsynced the whole lot of old backups to the new server. I 
then made some scripts that created snapshots from the old file 
hierarchy. As I started rewriting my backup scripts (on file server and 
backup server) to use send/receive, I also tested scrubbing to see that 
everything was OK. After doing this a few times, scrub found 
unrecoverable files. This, I thought, should not be possible on new 
disks. I tried to get some help on this list, but no answers were found, 
and since I was unable to find what triggered this, I just stopped using 
send/receive, and let my old backup regime live on on this new backup 
server as well. I don't remember how I fixed the errors, but I guess I 
just replaced the offending files with fresh ones, and scrub ran without 
any more problems. I decided to let things just run like this, and set 
up scrubbing on a monthly schedule.

Last night I got the unpleasant mail from cron telling me that scrub had 
failed (for the first time in over a year). Since I was running on an 
older kernel (4.2.x), I decided to upgrade, and went for the latest of 
the longterm branches, namely 4.4.30. After rebooting I did (for 
whatever reason) check one of the offending files, and I could read the 
file just fine! I checked the rest of the bunch, and all files read 
fine, and had the same md5 sum as the originals! All these files were 
located in those old snapshots. I thought that maybe this was because of 
a bug resolved since my last kernel. Then I ran a new scrub, and this 
one also reported unrecoverable errors. This time on two other files but 
also in some of the old snapshots. I tried reading the files, and got 
the expected I/O errors. One reboot later, these files reads just fine 
again!

Some system info:

$ uname -a
Linux backup 4.4.30-1-lts #1 SMP Tue Nov 1 22:09:20 CET 2016 x86_64 
GNU/Linux

$ btrfs --version
btrfs-progs v4.8.2

$ btrfs fi show /backup
Label: none  uuid: 8825ce78-d620-48f5-9f03-8c4568d3719d
     Total devices 4 FS bytes used 2.81TiB
     devid    1 size 2.73TiB used 1.41TiB path /dev/sdb
     devid    2 size 2.73TiB used 1.41TiB path /dev/sda
     devid    3 size 2.73TiB used 1.41TiB path /dev/sdd
     devid    4 size 2.73TiB used 1.41TiB path /dev/sdc


Thanks!

Tom Arild Naess


