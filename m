From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Writes in idle/How to debug filesystem activity
Date: Tue, 30 Aug 2011 08:58:40 +0200
Message-ID: <4E5C8A20.7030604@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>, jonas@lophus.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

> I use btrfs on a SD card. When my computer is running in idle (i.e.
> nothing running but wmii and a few background tasks that don't do any
> i/o; freshly synced), from time to time some [btrfs-*] tasks do writes
> (for 5 seconds or so).  What are those processes doing on my disk,
> having nothing to write/read? That leads to the second question: How can
> I debug file system activity in inotify style?

There was once a similar thread about this issue; unfortunately, without 
any constructive answers:

http://thread.gmane.org/gmane.comp.file-systems.btrfs/10840


-- 
Tomasz Chmielewski
http://wpkg.org

