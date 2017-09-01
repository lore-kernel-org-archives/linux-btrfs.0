Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:33930 "EHLO
        mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751862AbdIAL2c (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 07:28:32 -0400
Received: by mail-io0-f195.google.com with SMTP id z67so759217iof.1
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 04:28:32 -0700 (PDT)
Subject: Re: [btrfs-progs] Bug in mkfs.btrfs -r
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, kreijack@inwind.it,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7d08fad3-1a73-08c1-dbb1-e845f88cf039@libero.it>
 <113498a8-e9c4-0a9e-c9b0-14489512ee49@gmx.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6faf4ff6-6913-bfce-6e48-f161452a713a@gmail.com>
Date: Fri, 1 Sep 2017 07:28:28 -0400
MIME-Version: 1.0
In-Reply-To: <113498a8-e9c4-0a9e-c9b0-14489512ee49@gmx.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-08-31 20:13, Qu Wenruo wrote:
> 
> 
> On 2017年09月01日 01:27, Goffredo Baroncelli wrote:
>> Hi All,
>>
>>
>> I found a bug in mkfs.btrfs, when it is used the option '-r'. It seems 
>> that it is not visible the full disk.
> 
> Despite the new bug you found, -r has several existing bugs.
Is this actually a bug though?  Every other filesystem creation  tool 
that I know of that offers functionality like this generates the 
filesystem just large enough to contain the data you want in it, so I 
would argue that making this use the whole device is actually breaking 
consistency with other tools, not to mention removing functionality that 
is useful (even aside from the system image generation use case I 
mentioned, there are other practical applications (seed 'device' 
generation comes to mind).
> 
> For example it will create dev extent starting from physical offset 0, 
> while kernel and mkfs will avoid that range, as 0~1M on each device is 
> reserved.
> 
> According to the code, -r will modify chunk layout by itself, not the 
> traditional way kernel is doing.
> 
> I'll fix them (if I'm not a lazybone), before that fix, please don't use 
> -r option as it's not well maintained or fully tested.
FWIW, based on my own testing, filesystems generated with '-r' work just 
fine as long as you don't try to embed boot code in the FS itself.

