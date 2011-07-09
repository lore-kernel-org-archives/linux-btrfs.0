From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: Raid root filesystem?
Date: Sat, 09 Jul 2011 13:05:11 +0200
Message-ID: <4E1835E7.60901@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>, hugo@carfax.org.uk
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>> It would be awesome to be able to just boot a btrfs raid without the
>> need for pesky partitions, as this would allow a system to be "grown"
>> later when space gets scarce...
>
>    You still need a partition for swap, of course.

With btrfs it's still true, unfortunately, as you can't swap to a file 
placed on btrfs.

Are there any middle-term plans to let swap to a file on btrfs (without 
the workarounds like loop devices etc.)?


-- 
Tomasz Chmielewski
http://wpkg.org

