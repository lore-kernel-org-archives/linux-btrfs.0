Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:43670 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750946AbdIJQMO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 12:12:14 -0400
Date: Sun, 10 Sep 2017 19:11:47 +0300
In-Reply-To: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
References: <CAOsOv4morDsVyrWEitL8L+7mXjS+0mXXsd9213Y8cdR44qrLYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: Help me understand what is going on with my RAID1 FS
To: FLJ <feci2048@gmail.com>, linux-btrfs@vger.kernel.org
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
Message-ID: <1F3219B0-72B2-4201-8C96-E6FBFD02A413@demfloro.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>Actually based on http://carfax.org.uk/btrfs-usage/index.html I
>would've expected 6 TB of usable space. Here I get 6.4 which is odd,
>but that only 1.5 TB is available is even stranger.
>
>Could anyone explain what I did wrong or why my expectations are wrong?
>
>Thank you in advance

I'd say df and the website calculate different things. In btrfs raid1 profile stores exactly 2 copies of data, each copy is on separate device. 
So by adding third drive, no matter how big, effective free space didn't expand because btrfs still needs space on any one of other two drives to store second half of each raid1 chunk stored on that third drive. 

Basically:

Drive1      Drive2    Drive3
X               X
X                               X
                  X             X

Where X is a chunk of raid1 block group.
