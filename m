Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:35222 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751966AbdIAN7e (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 09:59:34 -0400
Received: by mail-io0-f170.google.com with SMTP id z67so1829359iof.2
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 06:59:34 -0700 (PDT)
Subject: Re: mount time for big filesystems
To: Juan Orti Alcaine <j.orti.alcaine@gmail.com>,
        Roman Mamedov <rm@romanrm.net>
Cc: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com>
 <20170831163656.6be88191@natsu>
 <CAC+fKQXozVX4OsKOVxPEdRPkO=5iakEJenaxLHoaQ4FieSUmLA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <437dddb7-6d3f-6ad8-7802-51b62e22d708@gmail.com>
Date: Fri, 1 Sep 2017 09:59:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAC+fKQXozVX4OsKOVxPEdRPkO=5iakEJenaxLHoaQ4FieSUmLA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-09-01 09:52, Juan Orti Alcaine wrote:
> 2017-08-31 13:36 GMT+02:00 Roman Mamedov <rm@romanrm.net>:
>> If you could implement SSD caching in front of your FS (such as lvmcache or
>> bcache), that would work wonders for performance in general, and especially
>> for mount times. I have seen amazing results with lvmcache (of just 32 GB) for
>> a 14 TB FS.
> 
> I'm thinking about adding a SSD for my 4 disks RAID1 filesystem, but I
> have doubts about how to correctly do it in a multidevice filesystem.
> 
> I guess I should make 4 partitions on the SSD and pair them with my
> backing devices, then create the btrfs on top of bcache0, bcache1,...
> is this the right way to do it?
If you are going to use bcache, you don't need separate caches for each 
device (and in fact, you're probably better off sharing a cache across 
devices).

If instead you're going to use dm-cache/LVM, you will need two logical 
volumes per-device for the cache, one big one (for the actual cache), 
and one little one (for metadata, usually a few hundred MB is fine).

In general though, you're correct, it is preferred to do things in the 
order you suggested.  It is technically possible sometimes to convert an 
existing device to being cached in-place, but it's risky, and restoring 
from a backup onto a clean filesystem has other benefits too.
