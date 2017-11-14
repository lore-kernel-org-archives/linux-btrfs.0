Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:52394 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752638AbdKNKU1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 14 Nov 2017 05:20:27 -0500
Received: by mail-it0-f52.google.com with SMTP id n134so9341540itg.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Nov 2017 02:20:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171010173608.GS3521@twin.jikos.cz>
References: <20171003150604.19596-1-nefelim4ag@gmail.com> <20171003150604.19596-5-nefelim4ag@gmail.com>
 <20171010173608.GS3521@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 14 Nov 2017 13:19:46 +0300
Message-ID: <CAGqmi77a+s+vi0YcOomydefzH5X45ELbRL=G9EQYdEa79LktNA@mail.gmail.com>
Subject: Re: [PATCH 4/4] Btrfs: btrfs_dedupe_file_range() ioctl, remove 16MiB restriction
To: David Sterba <dsterba@suse.cz>, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, i just thinking that i can test that and send you some feedback,
But for now, no time.
I will check that later and try adds memory reusing.

So, just ignore patches for now.

Thanks

2017-10-10 20:36 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Tue, Oct 03, 2017 at 06:06:04PM +0300, Timofey Titovets wrote:
>> At now btrfs_dedupe_file_range() restricted to 16MiB range for
>> limit locking time and memory requirement for dedup ioctl()
>>
>> For too big input rage code silently set range to 16MiB
>>
>> Let's remove that restriction by do iterating over dedup range.
>> That's backward compatible and will not change anything for request
>> less then 16MiB.
>
> This would make the ioctl more pleasant to use. So far I haven't found
> any problems to do the iteration. One possible speedup could be done to
> avoid the repeated allocations in btrfs_extent_same if we're going to
> iterate more than once.
>
> As this would mean the 16MiB length restriction is gone, this needs to
> bubble up to the documentation
> (http://man7.org/linux/man-pages/man2/ioctl_fideduperange.2.html)
>
> Have you tested the behaviour with larger ranges?



-- 
Have a nice day,
Timofey.
