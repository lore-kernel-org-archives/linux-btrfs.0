Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35890 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750922AbdHaLqA (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 07:46:00 -0400
Received: by mail-io0-f169.google.com with SMTP id f99so13139525ioi.3
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Aug 2017 04:45:59 -0700 (PDT)
Subject: Re: mount time for big filesystems
To: Roman Mamedov <rm@romanrm.net>,
        Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>
Cc: linux-btrfs@vger.kernel.org
References: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com>
 <20170831163656.6be88191@natsu>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <d4214656-ec36-4a1e-7c4d-a528c0ae61be@gmail.com>
Date: Thu, 31 Aug 2017 07:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <20170831163656.6be88191@natsu>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-31 07:36, Roman Mamedov wrote:
> On Thu, 31 Aug 2017 12:43:19 +0200
> Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com> wrote:
> 
>> Hi,
>> this 37T filesystem took some times to mount. It has 47
>> subvolumes/snapshots and is mounted with
>> noatime,compress=zlib,space_cache. Is it normal, due to its size?
> 
> If you could implement SSD caching in front of your FS (such as lvmcache or
> bcache), that would work wonders for performance in general, and especially
> for mount times. I have seen amazing results with lvmcache (of just 32 GB) for
> a 14 TB FS.
If you use dm-cache (what LVM uses), you need to be _VERY_ careful and 
can't use it safely at all with multi-device volumes because it leaves 
the underlying block device exposed.
> 
> As for in general, with your FS size perhaps you should be using
> "space_cache=v2" for better performance, but I'm not sure if that will have
> any effect on mount time (aside from slowing down the first mount with that).
It shouldn't have any other impact on mount time, but it may speed up 
other operations.
