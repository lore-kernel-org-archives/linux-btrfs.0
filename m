From: "Jonas H." <jonas@lophus.org>
Subject: Writes in idle/How to debug filesystem activity
Date: Mon, 29 Aug 2011 22:13:02 +0200
Message-ID: <4E5BF2CE.9060604@lophus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo list,

I use btrfs on a SD card. When my computer is running in idle (i.e. 
nothing running but wmii and a few background tasks that don't do any 
i/o; freshly synced), from time to time some [btrfs-*] tasks do writes 
(for 5 seconds or so).  What are those processes doing on my disk, 
having nothing to write/read? That leads to the second question: How can 
I debug file system activity in inotify style?

Thanks,
Jonas
