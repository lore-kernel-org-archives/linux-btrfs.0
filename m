Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f54.google.com ([209.85.214.54]:53181 "EHLO
        mail-it0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932745AbeB1TYo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Feb 2018 14:24:44 -0500
Received: by mail-it0-f54.google.com with SMTP id k135so4794164ite.2
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Feb 2018 11:24:44 -0800 (PST)
Received: from [191.9.212.201] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.gmail.com with ESMTPSA id 62sm1715039iow.35.2018.02.28.11.24.41
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Feb 2018 11:24:42 -0800 (PST)
Subject: Re: btrfs space used issue
To: linux-btrfs@vger.kernel.org
References: <CAFmraXiqhYUvM3VDGHp3Zj0i5SMH_Koy6Ed4B6W092-SVFSNVg@mail.gmail.com>
 <pan$e116f$e5aa2400$88c9d453$f5589ed1@cox.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <2892a866-fdc3-b337-4cd4-2cd4a18b9f21@gmail.com>
Date: Wed, 28 Feb 2018 14:24:40 -0500
MIME-Version: 1.0
In-Reply-To: <pan$e116f$e5aa2400$88c9d453$f5589ed1@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018-02-28 14:09, Duncan wrote:
> vinayak hegde posted on Tue, 27 Feb 2018 18:39:51 +0530 as excerpted:
> 
>> I am using btrfs, But I am seeing du -sh and df -h showing huge size
>> difference on ssd.
>>
>> mount:
>> /dev/drbd1 on /dc/fileunifier.datacache type btrfs
>>
> (rw,noatime,nodiratime,flushoncommit,discard,nospace_cache,recovery,commit=5,subvolid=5,subvol=/)
>>
>>
>> du -sh /dc/fileunifier.datacache/ -  331G
>>
>> df -h /dev/drbd1      746G  346G  398G  47% /dc/fileunifier.datacache
>>
>> btrfs fi usage /dc/fileunifier.datacache/
>> Overall:
>>      Device size:         745.19GiB Device allocated:         368.06GiB
>>      Device unallocated:         377.13GiB Device missing:
>>      0.00B Used:             346.73GiB Free (estimated):
>>      396.36GiB    (min: 207.80GiB)
>>      Data ratio:                  1.00 Metadata ratio:              2.00
>>      Global reserve:         176.00MiB    (used: 0.00B)
>>
>> Data,single: Size:365.00GiB, Used:345.76GiB
>>     /dev/drbd1     365.00GiB
>>
>> Metadata,DUP: Size:1.50GiB, Used:493.23MiB
>>     /dev/drbd1       3.00GiB
>>
>> System,DUP: Size:32.00MiB, Used:80.00KiB
>>     /dev/drbd1      64.00MiB
>>
>> Unallocated:
>>     /dev/drbd1     377.13GiB
>>
>>
>> Even if we consider 6G metadata its 331+6 = 337.
>> where is 9GB used?
>>
>> Please explain.
> 
> Taking a somewhat higher level view than Austin's reply, on btrfs, plain
> df and to a somewhat lessor extent du[1] are at best good /estimations/
> of usage, and for df, space remaining.  Due to btrfs' COW/copy-on-write
> semantics and features such as the various replication/raid schemes,
> snapshotting, etc, btrfs makes available, that df/du don't really
> understand as they simply don't have and weren't /designed/ to have that
> level of filesystem-specific insight, they, particularly df due to its
> whole-filesystem focus, aren't particularly accurate on btrfs.  Consider
> their output more a "best estimate given the rough data we have
> available" sort of report.
> 
> To get the real filesystem focused picture, use btrfs filesystem usage,
> or btrfs filesystem show combined with btrfs filesystem df.  That's what
> you should trust, altho various utilities that check for available space
> before doing something often use the kernel-call equivalent of (plain) df
> to ensure they have the required space, so it's worthwhile to keep an eye
> on it as the filesystem fills, as well.  If it gets too out of sync with
> btrfs filesystem usage, or if btrfs filesystem usage unallocated drops
> below say five gigs or data or metadata size vs used shows a spread of
> multiple gigs (your data shows a spread of ~20 gigs ATM, but with 377
> gigs still unallocated it's no big deal; it would be a big deal if those
> were reversed, tho, only 20 gigs unallocated and a spread of 300+ gigs in
> data size vs used), then corrective action such as a filtered rebalance
> may be necessary.
> 
> There are entries in the FAQ discussing free space issues that you should
> definitely read if you haven't, altho they obviously address the general
> case, so if you have more questions about an individual case after having
> read them, here is a good place to ask. =:^)
> 
> Everything having to do with "space" (see both the 1/Important-questions
> and 4/Common-questions sections) here:
> 
> https://btrfs.wiki.kernel.org/index.php/FAQ
> 
> Meanwhile, it's worth noting that not entirely intuitively, btrfs' COW
> implementation can "waste" space on larger files that are mostly, but not
> entirely, rewritten.  An example is the best way to demonstrate.
> Consider each x a used block and each - an unused but still referenced
> block:
> 
> Original file, written as a single extent (diagram works best with
> monospace, not arbitrarily rewrapped):
> 
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> 
> First rewrite of part of it:
> 
> xxxxxxxxxxx------xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
>             xxxxxx
> 
> 
> Nth rewrite, where some blocks of the original still remain as originally
> written:
> 
> ------------------xxx------------------------------
>             xxx---
> xxxx----xxx
>      xxxx
>                       xxxxxxxxxxxxxxxxxxxxx---xxxxxx
>                                            xxx
>                xxx
> 
> 
> As you can see, that first really large extent remains fully referenced,
> altho only three blocks of it remain in actual use.  All those -- won't
> be returned to free space until those last three blocks get rewritten as
> well, thus freeing the entire original extent.
> 
> I believe this effect is what Austin was referencing when he suggested
> the defrag, tho defrag won't necessarily /entirely/ clear it up.  One way
> to be /sure/ it's cleared up would be to rewrite the entire file,
> deleting the original, either by copying it to a different filesystem and
> back (with the off-filesystem copy guaranteeing that it can't use reflinks
> to the existing extents), or by using cp's --reflink=never option.
> (FWIW, I prefer the former, just to be sure, using temporary copies to a
> suitably sized tmpfs for speed where possible, tho obviously if the file
> is larger than your memory size that's not possible.)
Correct, this is why I recommended trying a defrag.  I've actually never 
seen things so bad that a simple defrag didn't fix them however (though 
I have seen a few cases where the target extent size had to be set 
higher than the default of 20MB).  Also, as counter-intuitive as it 
might sound, autodefrag really doesn't help much with this, and can 
actually make things worse.

This is also one of the things I was referring to in item 6of the list 
of causes I gave, partly because I couldn't come up with a good way to 
explain it clearly (which I feel you did an excellent job of above), 
with the other big one being handling of xattrs and ACL's (which get 
accounted by `df` but generally aren't by `du` (at least, not reliably).
> 
> Of course where applicable, snapshots and dedup keep reflink-references
> to the old extents, so they must be adjusted or deleted as well, to
> properly free that space.
> 
> ---
> [1] du: Because its purpose is different.  du's primary purpose is
> telling you in detail what space files take up, per-file and per-
> directory, without particular regard to usage on the filesystem itself.
> df's focus, by contrast, is on the filesystem as a whole.  So where two
> files share the same extent due to reflinking, du should and does count
> that usage for each file, because that's what each file /uses/ even if
> they both use the same extents.
