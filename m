Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63237 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751516AbdIALy5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Sep 2017 07:54:57 -0400
Subject: Re: [btrfs-progs] Bug in mkfs.btrfs -r
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, kreijack@inwind.it,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <7d08fad3-1a73-08c1-dbb1-e845f88cf039@libero.it>
 <113498a8-e9c4-0a9e-c9b0-14489512ee49@gmx.com>
 <6faf4ff6-6913-bfce-6e48-f161452a713a@gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <4332f4a4-1ba8-a13c-7f3b-77c56b87eaed@gmx.com>
Date: Fri, 1 Sep 2017 19:54:46 +0800
MIME-Version: 1.0
In-Reply-To: <6faf4ff6-6913-bfce-6e48-f161452a713a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月01日 19:28, Austin S. Hemmelgarn wrote:
> On 2017-08-31 20:13, Qu Wenruo wrote:
>>
>>
>> On 2017年09月01日 01:27, Goffredo Baroncelli wrote:
>>> Hi All,
>>>
>>>
>>> I found a bug in mkfs.btrfs, when it is used the option '-r'. It 
>>> seems that it is not visible the full disk.
>>
>> Despite the new bug you found, -r has several existing bugs.
> Is this actually a bug though?  Every other filesystem creation  tool 
> that I know of that offers functionality like this generates the 
> filesystem just large enough to contain the data you want in it,

At least I tried mkfs.ext4 with an almost empty directory (only one 512K 
file),
After mount the fs, there is still over 900M available space.

Even mkfs.ext4 doesn't explain much about its -d option, I think it's 
not the case, at least for -d option alone.

Thanks,
Qu

> so I 
> would argue that making this use the whole device is actually breaking 
> consistency with other tools, not to mention removing functionality that 
> is useful (even aside from the system image generation use case I 
> mentioned, there are other practical applications (seed 'device' 
> generation comes to mind).
>>
>> For example it will create dev extent starting from physical offset 0, 
>> while kernel and mkfs will avoid that range, as 0~1M on each device is 
>> reserved.
>>
>> According to the code, -r will modify chunk layout by itself, not the 
>> traditional way kernel is doing.
>>
>> I'll fix them (if I'm not a lazybone), before that fix, please don't 
>> use -r option as it's not well maintained or fully tested.
> FWIW, based on my own testing, filesystems generated with '-r' work just 
> fine as long as you don't try to embed boot code in the FS itself.
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
