From: MOB <digital.corpus@gmail.com>
Subject: Copied Files from Btrfs partition larger than original
Date: Mon, 14 Feb 2011 00:41:46 -0800
Message-ID: <8534C054-C9D6-470F-BB5A-45493462A17C@gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

So as I'm doing some maintenance on my personal video server, I'm noticing that when I'm copying files off of my btrfs partitions, they are getting larger...

First partition is the original:
http://pastebin.com/GM5xWetR

I have 3 affected partitions, This appears to have started with 2.6.37 but could have started happening before. I have ~3300 video files where ~840 are on btrfs partitions that randomly get shuffled on/off for free space distribution

Thank you,
Michael