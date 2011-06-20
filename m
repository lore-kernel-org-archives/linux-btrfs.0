From: Proskurin Kirill <k.proskurin@corp.mail.ru>
Subject: compression ratio
Date: Mon, 20 Jun 2011 15:29:45 +0400
Message-ID: <4DFF2F29.4040108@corp.mail.ru>
Reply-To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello all.

I`m new to btrfs and do some testing now.

What we have:
SL6 - kernel 2.6.32-131.2.1.el6.x86_64
mdadm RAID5 with 8 HDD - 27T partition.

Mount options is "noatime,noacl,compress-force"
I use scribe daemon to copy log files from 200 hosts to that partition 
for stress testing.

But I found what compression ratio is really small.
Partition is full of regular log files - plain text. Most of them a big 
ones(10-20Gb) and they grow in realtime.

du -hs /logs/
1.1T   /logs/

And compressed size is(df -h):
908G

Regular gzip do a significant more ratio.

There is a problem here? File size? Realtime grow of a files?


-- 
Best regards,
Proskurin Kirill
