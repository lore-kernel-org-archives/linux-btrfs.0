Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36834 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931AbbJYCM6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Oct 2015 22:12:58 -0400
Received: by igdg1 with SMTP id g1so38640724igd.1
        for <linux-btrfs@vger.kernel.org>; Sat, 24 Oct 2015 19:12:57 -0700 (PDT)
Received: from [192.168.0.233] (MTRLPQ0313W-LP140-05-1279438538.dsl.bell.ca. [76.66.174.202])
        by smtp.googlemail.com with ESMTPSA id j94sm10719661iod.3.2015.10.24.19.12.56
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 24 Oct 2015 19:12:56 -0700 (PDT)
To: linux-btrfs@vger.kernel.org
From: Nicholas Steeves <nsteeves@gmail.com>
Subject: wow!
Message-ID: <562C3AA7.9060007@gmail.com>
Date: Sat, 24 Oct 2015 22:12:55 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I upgraded to linux-4.2.3 and btrfs-progs-4.2.3 yesterday, and wow, 
there must have been bigger between linux-4.1.10 and 4.2.3 than were 
mentioned in the changelog!  I've been testing btrfs on a Thinkpad X200 
with an i5-2450M, Intel 320 SSD, and 8GB of RAM for over a year now, 
since when when linux-3.16 and btrfs-progs-3.17 were very new. 
Performance had been steadily degrading, or hit or miss (I'm not sure if 
defrag or fstrim actually work...), but stability was getting better.

The regular use case I use a benchmark is how fast the backup goes.  If 
the numbers seem unusual, I'll reboot and run:

tar cf- /.snapshots/only_one_snapshot | pv -pabet > /dev/null
then reboot and run
btrfs send /.snapshots/only_one_snapshot | pv -pabet > /dev/null

The worst run I've seen this last year for both of these commands~60 
MiB/s throughput to /dev/null...

A year ago, when the file system was brand new, after I filled the fs 
with my regular data, the average was:
GNU tar: ~125 MiB/s
BSD tar: ~129 MiB/s
btrfs send: ~140 MiB/s

Now with linux-4.2.3 and btrfs-progs-4.2.3:
GNU tar: ~134 MiB/s
BSD tar: ~129 MiB/s
btrfs send: ~133 MiB/s

This is the first time a backup has run at the speed of a fresh 
filesystem; I have not recently run fstrim or btrfs fi defrag, so I was 
very pleasantly surprised!  Thank you all very much for your hard work.

Kind regards,
Nicholas
