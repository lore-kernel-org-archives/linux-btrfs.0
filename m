Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:37525 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933993AbdKPQcL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 11:32:11 -0500
Received: by mail-it0-f50.google.com with SMTP id m191so685410itg.2
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 08:32:11 -0800 (PST)
Subject: Re: zstd compression
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAK5rZE51onZEE_f2xg4nxPriU9YQq5AARDLs-BTZL2RaGSCTXA@mail.gmail.com>
 <43412efa-ff56-9682-c8f7-a5966b87b10e@lukas-pirl.de>
 <CAK5rZE7rLToV7t+6pZhTbN2+JQj=W67Y5mESNhpaF0ehZzObOA@mail.gmail.com>
 <361d92ee-9aee-35e1-024d-45ec5b79902b@gmail.com>
 <pan$c02ea$c0c093a$d0320b0d$d9d43196@cox.net>
 <37eb6ee9-2f7e-de42-3f7c-32db11d7648a@gmail.com>
 <pan$a1486$84968dd3$dcbd0f46$977f6603@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <6d10a13a-f4b4-3688-4445-8dd2f645c222@gmail.com>
Date: Thu, 16 Nov 2017 11:32:06 -0500
MIME-Version: 1.0
In-Reply-To: <pan$a1486$84968dd3$dcbd0f46$977f6603@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-11-16 08:43, Duncan wrote:
> Austin S. Hemmelgarn posted on Thu, 16 Nov 2017 07:30:47 -0500 as
> excerpted:
> 
>> On 2017-11-15 16:31, Duncan wrote:
>>> Austin S. Hemmelgarn posted on Wed, 15 Nov 2017 07:57:06 -0500 as
>>> excerpted:
>>>
>>>> The 'compress' and 'compress-force' mount options only impact newly
>>>> written data.  The compression used is stored with the metadata for
>>>> the extents themselves, so any existing data on the volume will be
>>>> read just fine with whatever compression method it was written with,
>>>> while new data will be written with the specified compression method.
>>>>
>>>> If you want to convert existing files, you can use the '-c' option to
>>>> the defrag command to do so.
>>>
>>> ... Being aware of course that using defrag to recompress files like
>>> that will break 100% of the existing reflinks, effectively (near)
>>> doubling data usage if the files are snapshotted, since the snapshot
>>> will now share 0% of its extents with the newly compressed files.
>> Good point, I forgot to mention that.
>>>
>>> (The actual effect shouldn't be quite that bad, as some files are
>>> likely to be uncompressed due to not compressing well, and I'm not sure
>>> if defrag -c rewrites them or not.  Further, if there's multiple
>>> snapshots data usage should only double with respect to the latest one,
>>> the data delta between it and previous snapshots won't be doubled as
>>> well.)
>> I'm pretty sure defrag is equivalent to 'compress-force', not
>> 'compress', but I may be wrong.
> 
> But... compress-force doesn't actually force compression _all_ the time.
> Rather, it forces btrfs to continue checking whether compression is worth
> it for each "block"[1] of the file, instead of giving up if the first
> quick try at the beginning says that block won't compress.
> 
> So what I'm saying is that if the snapshotted data is already compressed,
> think (pre-)compressed tarballs or image files such as jpeg that are
> unlikely to /easily/ compress further and might well actually be _bigger_
> once the compression algorithm is run over them, defrag -c will likely
> fail to compress them further even if it's the equivalent of compress-
> force, and thus /should/ leave them as-is, not breaking the reflinks of
> the snapshots and thus not doubling the data usage for that file, or more
> exactly, that extent of that file.
> 
> Tho come to think of it, is defrag -c that smart, to actually leave the
> data as-is if it doesn't compress further, or does it still rewrite it
> even if it doesn't compress, thus breaking the reflink and doubling the
> usage regardless?
I'm not certain how compression factors in, but if you aren't 
compressing the file, it will only get rewritten if it's fragmented 
(which is shy defragmenting the system root directory is usually 
insanely fast on most systems, stuff there is almost never fragmented).
> 
> ---
> [1] Block:  I'm not positive it's the usual 4K block in this case.  I
> think I read that it's 16K, but I might be confused on that.  But
> regardless the size, the point is, with compress-force btrfs won't give
> up like simple compress will if the first "block" doesn't compress, it'll
> keep trying.
> 
> Of course the new compression heuristic changes this a bit too, but the
> same general idea holds, compress-force continues to try for the entire
> file, compress will give up much faster.
I'm not actually sure, I would think it checks 128k blocks of data (the 
effective block size for compression), but if it doesn't it should be 
checking at the filesystem block size (which means 16k on most recently 
created filesystems).
