Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f50.google.com ([209.85.214.50]:41762 "EHLO
        mail-it0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752208AbdLNNk3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Dec 2017 08:40:29 -0500
Received: by mail-it0-f50.google.com with SMTP id x28so11524235ita.0
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Dec 2017 05:40:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGqmi77HWCBmbt6+i7-31SuF-Ox_NTbtcSJAhn0jAuVc3q7Fqg@mail.gmail.com>
References: <CAGqmi76womfiPa_EkKiJ-BgxEcU1GjK7efrh8bWVD0kD+C9NrQ@mail.gmail.com>
 <CAGqmi74-Tap-K1xc4w9rUtVBZ7toesDgr3DiG_CjPSH86YbYmQ@mail.gmail.com>
 <pan$8770b$4eaee1a7$24cc02ce$7f0c8e7b@cox.net> <CAGqmi77HWCBmbt6+i7-31SuF-Ox_NTbtcSJAhn0jAuVc3q7Fqg@mail.gmail.com>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 14 Dec 2017 16:39:48 +0300
Message-ID: <CAGqmi74Xi5SDicEGbCt-69o-JYYMZBAyoxzS=Rbp2km-z=Vssg@mail.gmail.com>
Subject: Re: [BUG?] Defrag on compressed FS do massive data rewrites
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I send:
[PATCH] Btrfs: make should_defrag_range() understood compressed extents

If you want you can test that, it fix btrfs fi def and autodefrag
behavior with compressed data.
Also it understood if user try recompress data with old/new compression algo.

2017-12-14 14:27 GMT+03:00 Timofey Titovets <nefelim4ag@gmail.com>:
> 2017-12-14 8:58 GMT+03:00 Duncan <1i5t5.duncan@cox.net>:
>> Timofey Titovets posted on Thu, 14 Dec 2017 02:05:35 +0300 as excerpted:
>>
>>> Also, same problem exist for autodefrag case i.e.:
>>> write 4KiB at start of compressed file autodefrag code add that file to
>>> autodefrag queue, call btrfs_defrag_file, set range from start to u64-1.
>>> That will trigger to full file rewrite, as all extents are smaller then
>>> 256KiB.
>>>
>>> (if i understood all correctly).
>>
>> If so, it's rather ironic, because that's how I believed autodefrag to
>> work, whole-file, for quite some time.  Then I learned otherwise, but I
>> always enable both autodefrag and compress=lzo on all my btrfs, so it
>> looks like at least for my use-case, I was correct with the whole-file
>> assumption after all.  (Well, at least for files that are actually
>> compressed, I don't run compress-force=lzo, just compress=lzo, so a
>> reasonable number of files aren't actually compressed anyway, and they'd
>> do the partial-file rewrite I had learned to be normal.)
>>
>> --
>> Duncan - List replies preferred.   No HTML msgs.
>> "Every nonfree program has a lord, a master --
>> and if you use the program, he is your master."  Richard Stallman
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> btrfs fi def can easy avoid that problem if properly documented,
> but i think that fix must be in place, because "full rewrite" by
> autodefrag are unacceptable behaviour.
>
> How i see, "How it works":
> Both, defrag ioctl and autodefrag - call btrfs_defrag_file() (ioctl.c).
> btrfs_defrag_file() set extent_thresh to args, if args not provided
> (autodefrag not initialize range->extent_thresh);
> use default:
> if (extent_thresh == 0)
>      extent_thresh = SZ_256K;
>
> Later btrfs_defrag_file() try defrag file from start by "index" (page
> number from start, file virtually splitted to page sized blocks).
> Than it call should_defrag_range(), if need make i+1 or skip range by
> info from should_defrag_range().
>
> should_defrag_range() get extent for specified start offset:
> em = defrag_lookup_extent(inode, start);
>
> Later (em->len >= thresh || (!next_mergeable && !prev_mergeable)) will
> fail condition because len (<128KiB) < thresh (256KiB or 32MiB usual).
> So extent will be rewritten.
>
> struct extent_map{}; have two potential useful info:
>
> ...
> u64 len;
> ...
>
> unsigned int compress_type;
> ...
>
> As i see by code len store "real" length, so
> in theory that just need to add additional check later like:
> if (em->len = BTRFS_MAX_UNCOMPRESSED && em->compress_type > 0)
>     ret = 0;
>
> That must fix problem by "true" insight check for compressed extents.
>
> Thanks.
>
> P.S.
> (May be someone from more experienced devs can comment that?)
>
> --
> Have a nice day,
> Timofey.



-- 
Have a nice day,
Timofey.
