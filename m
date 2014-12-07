Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f47.google.com ([209.85.213.47]:59534 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbaLGQqA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 11:46:00 -0500
Received: by mail-yh0-f47.google.com with SMTP id f73so1693940yha.20
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Dec 2014 08:45:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAPs0BigCcMG9KCdgf0Jyd9p1Bji7BW6J3iHW521i-bJMMdZ=rQ@mail.gmail.com>
References: <CAPs0BigJG7_Z34iZXdjSQjSkMGi6SOMnbf60_DjYTotrmqYJ8w@mail.gmail.com>
	<547FD4E6.7020108@cn.fujitsu.com>
	<CAPs0BigCcMG9KCdgf0Jyd9p1Bji7BW6J3iHW521i-bJMMdZ=rQ@mail.gmail.com>
Date: Sun, 7 Dec 2014 11:45:59 -0500
Message-ID: <CAPs0BijmLGv+3Mt=3A-4iWUqaiTxXjTBobdyxge1e7xjUgfT0Q@mail.gmail.com>
Subject: Re: If btrfs-find-root doesn't find tree roots is the filesystem lost?
From: Sandy McArthur Jr <sandymac@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 7, 2014 at 12:50 AM, Sandy McArthur Jr <sandymac@gmail.com> wrote:
> Would the `btrfs check` output below indicate "only small error" and
> that a --repair is likely to succeed?

It did. Thanks Qu and Duncan.

dmesg suggests I have some scrubbing to do:
[220283.369150] BTRFS: bdev /dev/sdh1 errs: wr 0, rd 0, flush 0,
corrupt 5, gen 0
[220283.369159] BTRFS: bdev /dev/sdf1 errs: wr 0, rd 0, flush 0,
corrupt 5, gen 0
[220283.369163] BTRFS: bdev /dev/sdi1 errs: wr 0, rd 0, flush 0,
corrupt 5, gen 0



On Sun, Dec 7, 2014 at 12:50 AM, Sandy McArthur Jr <sandymac@gmail.com> wrote:
> On Wed, Dec 3, 2014 at 10:28 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> You can pass the bytenr to --tree-root option.
>> If btrfsck reports no or only small error, you can try btrfsck --repair
>> --tree-root <bytenr> to fix it.
>
> Would the `btrfs check` output below indicate "only small error" and
> that a --repair is likely to succeed? Alternatively, I can buy some
> more disk try a real `btrfs restore` per Duncan's email.
> Also, If I repair this filesystem should I migrate the data off of it anyway?
>
> btrfs-progs # ./btrfs check --tree-root 18948467019776 /dev/sdb1
> parent transid verify failed on 18948467019776 wanted 720141 found 720122
> parent transid verify failed on 18948467019776 wanted 720141 found 720122
> parent transid verify failed on 18948467019776 wanted 720141 found 720122
> parent transid verify failed on 18948467019776 wanted 720141 found 720122
> Ignoring transid failure
> Checking filesystem on /dev/sdb1
> UUID: 94b3345e-2589-423c-a228-d569bf94ab58
> checking extents
> checking free space cache
> btrfs: space cache generation (720139) does not match inode (720096)
> failed to load free space cache for block group 4324327424
> btrfs: space cache generation (720141) does not match inode (720122)
> failed to load free space cache for block group 5398069248
> btrfs: space cache generation (720140) does not match inode (720122)
> failed to load free space cache for block group 6471811072
> btrfs: space cache generation (720141) does not match inode (720122)
> failed to load free space cache for block group 8619294720
> btrfs: space cache generation (720140) does not match inode (720122)
> failed to load free space cache for block group 9693036544
> btrfs: space cache generation (720141) does not match inode (720122)
> failed to load free space cache for block group 10766778368
> btrfs: space cache generation (720124) does not match inode (720122)
> failed to load free space cache for block group 11840520192
> btrfs: space cache generation (720140) does not match inode (720122)
> failed to load free space cache for block group 13988003840
> btrfs: space cache generation (720140) does not match inode (720109)
> failed to load free space cache for block group 16135487488
> btrfs: space cache generation (720139) does not match inode (720096)
> failed to load free space cache for block group 15552105938944
> btrfs: space cache generation (720141) does not match inode (720108)
> failed to load free space cache for block group 16355264823296
> btrfs: space cache generation (720124) does not match inode (720122)
> failed to load free space cache for block group 18948351328256
> checking fs roots
> checking csums
> checking root refs
> Transid errors in file system
> found 7236014922773 bytes used err is 1
> total csum bytes: 11993511604
> total tree bytes: 15886303232
> total fs tree bytes: 1177964544
> total extent tree bytes: 739074048
> btree space waste bytes: 1543948503
> file data blocks allocated: 173683188744192
>  referenced 12257655894016
> Btrfs v3.17.3-dirty
>
>
>
>
> On Wed, Dec 3, 2014 at 10:28 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>
>> -------- Original Message --------
>> Subject: If btrfs-find-root doesn't find tree roots is the filesystem lost?
>> From: Sandy McArthur Jr <sandymac@gmail.com>
>> To: linux-btrfs@vger.kernel.org <linux-btrfs@vger.kernel.org>
>> Date: 2014年12月04日 09:20
>>>
>>> I have a many-disk btrfs filesystem that I cannot access after a
>>> crash. When I run btrfs-find-root I get lots of "Well block [#] seems
>>> great [...]" lines but zero "Generation: [...]" lines.
>>> Is this filesystem lost?
>>>
>>>
>>> Context info below. I'll upgrade to a 3.17.4 kernel soon and try again
>>> just in case.
>>>
>>> mcplex src # uname -a
>>> Linux mcplex 3.16.5-gentoo #1 SMP Mon Dec 1 22:03:39 EST 2014 x86_64
>>> Intel(R) Core(TM) i7-2600S CPU @ 2.80GHz GenuineIntel GNU/Linux
>>>
>>> mcplex src #   btrfs --version
>>> Btrfs v3.17.2
>>>
>>> mcplex src #   btrfs fi show
>>> parent transid verify failed on 18948425080832 wanted 720141 found 720122
>>> parent transid verify failed on 18948425080832 wanted 720141 found 720122
>>> parent transid verify failed on 18948425080832 wanted 720141 found 720122
>>> parent transid verify failed on 18948425080832 wanted 720141 found 720122
>>> Ignoring transid failure
>>> Couldn't setup extent tree
>>> Couldn't setup device tree
>>> Label: 'mcmedia'  uuid: 94b3345e-2589-423c-a228-d569bf94ab58
>>> Total devices 10 FS bytes used 11.38TiB
>>> devid    1 size 2.73TiB used 2.27TiB path /dev/sdb1
>>> devid    2 size 2.73TiB used 2.27TiB path /dev/sdc1
>>> devid    3 size 2.73TiB used 2.27TiB path /dev/sdd1
>>> devid    5 size 2.73TiB used 2.27TiB path /dev/sde1
>>> devid    6 size 2.73TiB used 2.27TiB path /dev/sdf1
>>> devid    7 size 2.73TiB used 2.27TiB path /dev/sdg1
>>> devid    8 size 3.64TiB used 3.18TiB path /dev/sdh1
>>> devid    9 size 3.64TiB used 3.18TiB path /dev/sdi1
>>> devid   10 size 3.64TiB used 1.40TiB path /dev/sdj1
>>> devid   11 size 3.64TiB used 1.40TiB path /dev/sdk1
>>>
>>> Btrfs v3.17.2
>>>
>>> [Note: devid #4 isn't there because it was cleanly removed months ago.]
>>>
>>> The relevent dmesg output from attempting to access the filesystem
>>> [85870.630827] BTRFS info (device sdc1): enabling auto recovery
>>> [85870.630832] BTRFS info (device sdc1): disk space caching is enabled
>>> [85870.848351] parent transid verify failed on 18948425080832 wanted
>>> 720141 found 720122
>>> [85870.848848] parent transid verify failed on 18948425080832 wanted
>>> 720141 found 720122
>>> [85870.848852] BTRFS: failed to read tree root on sdc1
>>> [85870.849365] parent transid verify failed on 18948425080832 wanted
>>> 720141 found 720122
>>> [85870.849974] parent transid verify failed on 18948425080832 wanted
>>> 720141 found 720122
>>> [85870.849976] BTRFS: failed to read tree root on sdc1
>>> [85870.850602] parent transid verify failed on 18948423397376 wanted
>>> 720140 found 720113
>>> [85870.851228] parent transid verify failed on 18948423397376 wanted
>>> 720140 found 720113
>>> [85870.851230] BTRFS: failed to read tree root on sdc1
>>> [85870.851857] parent transid verify failed on 18948466679808 wanted
>>> 720139 found 720091
>>> [85870.852482] parent transid verify failed on 18948466679808 wanted
>>> 720139 found 720091
>>> [85870.852485] BTRFS: failed to read tree root on sdc1
>>> [85870.853120] parent transid verify failed on 18948421505024 wanted
>>> 720138 found 720122
>>> [85870.853731] parent transid verify failed on 18948421505024 wanted
>>> 720138 found 720122
>>> [85870.853734] BTRFS: failed to read tree root on sdc1
>>> [85870.985258] BTRFS: open_ctree failed
>>
>> Only transid error,IMHO it should be recoverable.
>>>
>>>
>>> mcplex src # btrfs-find-root /dev/sdh1
>>> Super think's the tree root is at 18948425080832, chunk root 22179840
>>> Well block 31789056 seems great, but generation doesn't match,
>>> have=720011, want=720141 level 0
>>> [many lines similar to the above repeated a lot but no Generation lines]
>>>
>> Since it is a transid mismatch problem, it is common since btrfs-find-root
>> can't find the root which completely
>> matches with the transid in btrfs super block.
>>
>> In that case, btrfs-find-root is a very good help tool to find the real root
>> but you need to find it by hand(in 3.17.2).
>> 1. The root node should have the highest level
>> 2. The higher generation, the higher chance the fs can be recovered using
>> that root.
>>
>> Or you can try my patch sent sometimes ago:
>> https://patchwork.kernel.org/patch/5285521/
>>
>> With this patch, btrfs-find-root should only output the highest level node
>> and sort them with generation,
>> which can help you find the best tree root.
>>
>> After you got the possible root bytenr(something like "31789056" in your
>> output), with the following patch:
>> https://patchwork.kernel.org/patch/5206201/
>>
>> You can pass the bytenr to --tree-root option.
>> If btrfsck reports no or only small error, you can try btrfsck --repair
>> --tree-root <bytenr> to fix it.
>>
>> Thank,
>> Qu
>
>
>
> --
> Sandy McArthur
>
> "He who dares not offend cannot be honest."
> - Thomas Paine



-- 
Sandy McArthur

"He who dares not offend cannot be honest."
- Thomas Paine
