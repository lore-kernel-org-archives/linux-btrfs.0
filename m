From: Paul Komkoff <i@stingr.net>
Subject: btrfs defrag: how does it work?
Date: Wed, 19 Jan 2011 19:58:28 +0000
Message-ID: <AANLkTintJmDE7VVa5eTiepew68gztjh1j8Li1Fgq2iS6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello.

[root@botva incoming]# btrfs fi defrag file-350mb
[root@botva incoming]# filefrag file-350mb
file-350mb: 132 extents found
[root@botva incoming]# rsync --preallocate file-350mb test
[root@botva incoming]# filefrag test
test: 1 extent found

The system is 2.6.37 with latest for-linus.

Thanks.

-- 
This message represents the official view of the voices in my head
