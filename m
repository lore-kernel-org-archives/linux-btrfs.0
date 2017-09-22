Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:52182 "EHLO
        mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751997AbdIVLW4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Sep 2017 07:22:56 -0400
Received: by mail-io0-f177.google.com with SMTP id l15so2281535iol.8
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Sep 2017 04:22:55 -0700 (PDT)
Received: from [191.9.206.254] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id p133sm2236363ite.9.2017.09.22.04.22.53
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Sep 2017 04:22:53 -0700 (PDT)
Subject: Re: defragmenting best practice?
To: linux-btrfs@vger.kernel.org
References: <20170831070558.GB5783@rus.uni-stuttgart.de>
 <20170912162843.GA32233@rus.uni-stuttgart.de>
 <20170914133824.5cf9b59c@jupiter.sol.kaishome.de>
 <CABB28CyM9wQuDgn1ONTw3hrXQrLHwk30dxPcF_qnvdCM+A0gxA@mail.gmail.com>
 <20170914172434.39eae89d@jupiter.sol.kaishome.de>
 <CABB28Cx13a4eP3nM7PVYknmug-jpyeKv1ai5DWT0jKt4Zi0Rgg@mail.gmail.com>
 <59BBB15E.8010002@sarach.com.pl>
 <CABB28CxYR35HQgvf5PvRpDkGvtBxMR1LBDQO60N6QZ1cBmZGjQ@mail.gmail.com>
 <59BBDFA6.4020500@sarach.com.pl>
 <20170915190826.1f0be8a9@jupiter.sol.kaishome.de>
 <CABB28Cw6A-xYnwkcaoc=1XJa=K8g-Bz6_KFT2Q33FUJhbXD8JQ@mail.gmail.com>
 <CAH=dxU7R2fZQY12mJnYigt2s4BqVrsALJjxgbpvo7hfEwMXt-Q@mail.gmail.com>
 <6ab6ffd8-a556-800d-b812-e5361b13ea8d@gmail.com>
 <20170921221013.5576f90e@jupiter.sol.kaishome.de>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <fd4d55ff-3b6c-3ed1-6a8e-1823083243d9@gmail.com>
Date: Fri, 22 Sep 2017 07:22:52 -0400
MIME-Version: 1.0
In-Reply-To: <20170921221013.5576f90e@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-21 16:10, Kai Krakow wrote:
> Am Wed, 20 Sep 2017 07:46:52 -0400
> schrieb "Austin S. Hemmelgarn" <ahferroin7@gmail.com>:
> 
>>>       Fragmentation: Files with a lot of random writes can become
>>> heavily fragmented (10000+ extents) causing excessive multi-second
>>> spikes of CPU load on systems with an SSD or large amount a RAM. On
>>> desktops this primarily affects application databases (including
>>> Firefox). Workarounds include manually defragmenting your home
>>> directory using btrfs fi defragment. Auto-defragment (mount option
>>> autodefrag) should solve this problem.
>>>
>>> Upon reading that I am wondering if fragmentation in the Firefox
>>> profile is part of my issue. That's one thing I never tested
>>> previously. (BTW, this system has 256 GB of RAM and 20 cores.)
>> Almost certainly.  Most modern web browsers are brain-dead and insist
>> on using SQLite databases (or traditional DB files) for everything,
>> including the cache, and the usage for the cache in particular kills
>> performance when fragmentation is an issue.
> 
> At least in Chrome, you can turn on simple cache backend, which, I
> think, is using many small instead of one huge file. This suit btrfs
> much better:
That's correct.  The traditional cache in Chrome and Chromium uses a 
single SQLite database for storing all the cache data and metadata (just 
like FIrefox did last time I checked).  The simple cache backend instead 
uses the filesystem to handle allocations and uses directory hashing to 
speed up look ups of items, which actually means that even without BTRFS 
involved, it will usually be faster (both because it allows concurrent 
access unlike SQLite, and because it's generally faster to parse a 
multi-level directory hash than an SQL statement).
> 
> chrome://flags/#enable-simple-cache-backend
> 
> 
> And then I suggest also doing this (as your login user):
> 
> $ cd $HOME
> $ mv .cache .cache.old
> $ mkdir .cache
> $ lsattr +C .cache
> $ rsync -av .cache.old/ .cache/
> $ rm -Rf .cache.old
> 
> This makes caches for most applications nocow. Chrome performance was
> completely fixed for me by doing this.
> 
> I'm not sure where Firefox puts its cache, I only use it on very rare
> occasions. But I think it's going to .cache/mozilla last time looked
> at it.
I'm pretty sure that is correct.
> 
> You may want to close all apps before converting the cache directory.
At a minimum, you'll have to restart them to get them to use the new 
location.
> 
> Also, I don't see any downsides in making this nocow. That directory
> could easily be also completely volatile. If something breaks due to no
> longer protected by data csum, just clean it out.
Indeed, anything that is storing data here that can't be regenerated 
from some other source is asking for trouble, sane backup systems don't 
include ~/.cache, and it's quite often one of the first things 
recommended for deletion when trying to free up disk space.
