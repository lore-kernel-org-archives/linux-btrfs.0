Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:42599 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933753AbdKPMax (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 07:30:53 -0500
Received: by mail-io0-f179.google.com with SMTP id u42so5063439ioi.9
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 04:30:52 -0800 (PST)
Subject: Re: zstd compression
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAK5rZE51onZEE_f2xg4nxPriU9YQq5AARDLs-BTZL2RaGSCTXA@mail.gmail.com>
 <43412efa-ff56-9682-c8f7-a5966b87b10e@lukas-pirl.de>
 <CAK5rZE7rLToV7t+6pZhTbN2+JQj=W67Y5mESNhpaF0ehZzObOA@mail.gmail.com>
 <361d92ee-9aee-35e1-024d-45ec5b79902b@gmail.com>
 <pan$c02ea$c0c093a$d0320b0d$d9d43196@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <37eb6ee9-2f7e-de42-3f7c-32db11d7648a@gmail.com>
Date: Thu, 16 Nov 2017 07:30:47 -0500
MIME-Version: 1.0
In-Reply-To: <pan$c02ea$c0c093a$d0320b0d$d9d43196@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-15 16:31, Duncan wrote:
> Austin S. Hemmelgarn posted on Wed, 15 Nov 2017 07:57:06 -0500 as
> excerpted:
> 
>> The 'compress' and 'compress-force' mount options only impact newly
>> written data.  The compression used is stored with the metadata for the
>> extents themselves, so any existing data on the volume will be read just
>> fine with whatever compression method it was written with, while new
>> data will be written with the specified compression method.
>>
>> If you want to convert existing files, you can use the '-c' option to
>> the defrag command to do so.
> 
> ... Being aware of course that using defrag to recompress files like that
> will break 100% of the existing reflinks, effectively (near) doubling
> data usage if the files are snapshotted, since the snapshot will now
> share 0% of its extents with the newly compressed files.
Good point, I forgot to mention that.
> 
> (The actual effect shouldn't be quite that bad, as some files are likely
> to be uncompressed due to not compressing well, and I'm not sure if
> defrag -c rewrites them or not.  Further, if there's multiple snapshots
> data usage should only double with respect to the latest one, the data
> delta between it and previous snapshots won't be doubled as well.)
I'm pretty sure defrag is equivalent to 'compress-force', not 
'compress', but I may be wrong.
> 
> While this makes sense if you think about it, it may not occur to some
> people until they've actually tried it, and see their data usage go way
> up instead of going down as they intuitively expected.  There have been
> posts to the list...
> 
> Of course if the data isn't snapshotted this doesn't apply and defrag -c
> to zstd should be fine. =:^)
> 

