Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:35313 "EHLO
        mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdIAPUb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 11:20:31 -0400
Received: by mail-io0-f178.google.com with SMTP id z67so3319674iof.2
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 08:20:31 -0700 (PDT)
Subject: Re: mount time for big filesystems
To: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>,
        Roman Mamedov <rm@romanrm.net>
References: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com>
 <20170831163656.6be88191@natsu>
 <CAC+fKQXozVX4OsKOVxPEdRPkO=5iakEJenaxLHoaQ4FieSUmLA@mail.gmail.com>
 <437dddb7-6d3f-6ad8-7802-51b62e22d708@gmail.com>
 <CAC+fKQWFbdF6b3jGO_6hG_pNNzKobBYMeSNyEi5XRCf5YKa81Q@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <208a4dda-0628-1e1b-1118-b8921f86fedd@gmail.com>
Date: Fri, 1 Sep 2017 11:20:27 -0400
MIME-Version: 1.0
In-Reply-To: <CAC+fKQWFbdF6b3jGO_6hG_pNNzKobBYMeSNyEi5XRCf5YKa81Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-01 11:00, Juan Orti Alcaine wrote:
> 
> 
> El 1 sept. 2017 15:59, "Austin S. Hemmelgarn" <ahferroin7@gmail.com 
> <mailto:ahferroin7@gmail.com>> escribió:
> 
>     If you are going to use bcache, you don't need separate caches for
>     each device (and in fact, you're probably better off sharing a cache
>     across devices).
> 
> 
> But, if I mix all the backing devices, I'll only get one bcache device, 
> so I won't be able to do btrfs RAID1 on that.
No, that's not what I'm talking about.  You always get one bcache device 
per backing device, but multiple bcache devices can use the same 
physical cache device (that is, backing devices map 1:1 to bcache 
devices, but cache devices can map 1:N to bcache devices).  So, in other 
words, the layout I'm suggesting looks like this:

/dev/sda1: Backing device.
/dev/sdb1: Backing device.
/dev/sdc1: Backing device.
/dev/sdd1: Backing device.
/dev/sde1: SSD cache device.
/dev/bcache0: Corresponds to /dev/sda1, uses /dev/sde1 as cache
/dev/bcache1: Corresponds to /dev/sdb1, uses /dev/sde1 as cache
/dev/bcache2: Corresponds to /dev/sdc1, uses /dev/sde1 as cache
/dev/bcache3: Corresponds to /dev/sdd1, uses /dev/sde1 as cache

This is actually simpler to manage for multiple reasons, and will avoid 
wasting space on the cache device because of random choices made by 
BTRFS when deciding where to read data.
