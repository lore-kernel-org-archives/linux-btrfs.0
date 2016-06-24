Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f53.google.com ([209.85.218.53]:33956 "EHLO
	mail-oi0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340AbcFXRdo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 13:33:44 -0400
Received: by mail-oi0-f53.google.com with SMTP id s66so124394391oif.1
        for <linux-btrfs@vger.kernel.org>; Fri, 24 Jun 2016 10:33:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAA91j0WVMBv1TMpyC+hvtcwd3ZPepr3oVNg4g2qPjPy4Lf5UxQ@mail.gmail.com>
References: <20160620034427.GK15597@hungrycats.org> <20160620231351.1833a341@natsu>
 <20160620191112.GL15597@hungrycats.org> <CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
 <20160620204049.GA1986@hungrycats.org> <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
 <20160621015559.GM15597@hungrycats.org> <CAJCQCtRUUd+moK25N3704ZG54cFrCw1-Uxm2QO-XF9g0=mHazw@mail.gmail.com>
 <CAJCQCtT57k7Mirq=d6wTewY6EzvJE0g28EbmG9wLk+6cTASEEg@mail.gmail.com>
 <20160624020712.GC14667@hungrycats.org> <CAJCQCtSt832VcaKanj9cn9wY6+FZ68G9mOuSS=8i-AzmGQuV9g@mail.gmail.com>
 <CAA91j0WVMBv1TMpyC+hvtcwd3ZPepr3oVNg4g2qPjPy4Lf5UxQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Fri, 24 Jun 2016 11:33:41 -0600
Message-ID: <CAJCQCtQTojwvx59bkov39jZ_bywVgdUVq+5Kz578ba5mxpNYHA@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
To: Andrei Borzenkov <arvidjaar@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 4:16 AM, Andrei Borzenkov <arvidjaar@gmail.com> wrote:
> On Fri, Jun 24, 2016 at 8:20 AM, Chris Murphy <lists@colorremedies.com> wrote:
>
>> [root@f24s ~]# filefrag -v /mnt/5/*
>> Filesystem type is: 9123683e
>> File size of /mnt/5/a.txt is 16383 (4 blocks of 4096 bytes)
>>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>>    0:        0..       3:    2931712..   2931715:      4:             last,eof
>
> Hmm ... I wonder what is wrong here (openSUSE Tumbleweed)
>
> nohostname:~ # filefrag -v /mnt/1
> Filesystem type is: 9123683e
> File size of /mnt/1 is 3072 (1 block of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..       0:     269376..    269376:      1:             last,eof
> /mnt/1: 1 extent found
>
> But!
>
> nohostname:~ # filefrag -v /etc/passwd
> Filesystem type is: 9123683e
> File size of /etc/passwd is 1527 (1 block of 4096 bytes)
>  ext:     logical_offset:        physical_offset: length:   expected: flags:
>    0:        0..    4095:          0..      4095:   4096:
> last,not_aligned,inline,eof
> /etc/passwd: 1 extent found
> nohostname:~ #
>
> Why it works for one filesystem but does not work for an other one?
> ...
>>
>> So at the old address, it shows the "aaaaa..." is still there. And at
>> the added single block for this file at new logical and physical
>> addresses, is the modification substituting the first "a" for "g".
>>
>> In this case, no rmw, no partial stripe modification, and no data
>> already on-disk is at risk.
>
> You misunderstand the nature of problem. What is put at risk is data
> that is already on disk and "shares" parity with new data.
>
> As example, here are the first 64K in several extents on 4 disk RAID5
> with so far single data chunk
>
>         item 6 key (FIRST_CHUNK_TREE CHUNK_ITEM 1103101952) itemoff
> 15491 itemsize 176
>                 chunk length 3221225472 owner 2 stripe_len 65536
>                 type DATA|RAID5 num_stripes 4
>                         stripe 0 devid 4 offset 9437184
>                         dev uuid: ed13e42e-1633-4230-891c-897e86d1c0be
>                         stripe 1 devid 3 offset 9437184
>                         dev uuid: 10032b95-3f48-4ea0-a9ee-90064c53da1f
>                         stripe 2 devid 2 offset 1074790400
>                         dev uuid: cd749bd9-3d72-43b4-89a8-45e4a92658cf
>                         stripe 3 devid 1 offset 1094713344
>                         dev uuid: 41538b9f-3869-4c32-b3e2-30aa2ea1534e
>                 dev extent chunk_tree 3
>                 chunk objectid 256 chunk offset 1103101952 length 1073741824
>
>
>         item 5 key (1 DEV_EXTENT 1094713344) itemoff 16027 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk objectid 256 chunk offset 1103101952 length 1073741824
>         item 7 key (2 DEV_EXTENT 1074790400) itemoff 15931 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk objectid 256 chunk offset 1103101952 length 1073741824
>         item 9 key (3 DEV_EXTENT 9437184) itemoff 15835 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk objectid 256 chunk offset 1103101952 length 1073741824
>         item 11 key (4 DEV_EXTENT 9437184) itemoff 15739 itemsize 48
>                 dev extent chunk_tree 3
>                 chunk objectid 256 chunk offset 1103101952 length 1073741824
>
> where devid 1 = sdb1, 2 = sdc1 etc.
>
> Now let's write some data (I created several files) up to 64K in size:
>
> mirror 1 logical 1103364096 physical 1074855936 device /dev/sdc1
> mirror 2 logical 1103364096 physical 9502720 device /dev/sde1
> mirror 1 logical 1103368192 physical 1074860032 device /dev/sdc1
> mirror 2 logical 1103368192 physical 9506816 device /dev/sde1
> mirror 1 logical 1103372288 physical 1074864128 device /dev/sdc1
> mirror 2 logical 1103372288 physical 9510912 device /dev/sde1
> mirror 1 logical 1103376384 physical 1074868224 device /dev/sdc1
> mirror 2 logical 1103376384 physical 9515008 device /dev/sde1
> mirror 1 logical 1103380480 physical 1074872320 device /dev/sdc1
> mirror 2 logical 1103380480 physical 9519104 device /dev/sde1
>
> Note that btrfs allocates 64K on the same device before switching to
> the next one. What is a bit misleading here, sdc1 is data and sde1 is
> parity (you can see it in checksum tree, where only items for sdc1
> exist).
>
> Now let's write next 64k and see what happens
>
> nohostname:~ # btrfs-map-logical -l 1103429632 -b 65536 /dev/sdb1
> mirror 1 logical 1103429632 physical 1094778880 device /dev/sdb1
> mirror 2 logical 1103429632 physical 9502720 device /dev/sde1
>
> See? btrfs now allocates new stripe on sdb1; this stripe is at the
> same offset as previous one on sdc1 (64K) and so shares the same
> parity stripe on sde1.

Yep, I've seen this also. What's not clear is if there's any
optimization where it's doing partial strip writes, i.e. only a
certain sector needs updating so only that sector is written. The md
driver does have this optimization for raid5 I don't think it does for
raid6. So either someone familiar with the code needs to tell us, or
someone needs to do some tracing (not difficult but the output is
super verbose).

In any case it's a risk when parity is not cow'd but in any case if it
were stale or corrupt, a rebuild that depends on parity will rebuild
bad data, and that bad data is discoverable. It's not silent, so I
don't think it's completely correct to say there's a write hole. It's
more correct to say parity is now cow'd therefore the first part of
the write hole can happen, it's just not going to result in silent
corruption if there's an interruption writing the parity.

So far I haven't seen data extents not be cow'd, which I think we'd
agree is a bigger problem if that were to happen.

>If you compare 64K on sde1 at offset 9502720
> before and after, you will see that it has changed. INPLACE. Without
> CoW. This is exactly what puts existing data on sdc1 at risk - if sdb1
> is updated but sde1 is not, attempt to reconstruct data on sdc1 will
> either fail (if we have checksums) or result in silent corruption.

Which happens with any implementation that does rmw, partial stripe
writes have all sorts of other problems also. The ZFS way of dealing
with this is carrying a boatload of additional metadata to account for
variable stripe size so that they can cow everything. And it gets
massively fragmented as well. So there's a tradeoff for everything.



-- 
Chris Murphy
