Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from snt004-omc4s12.hotmail.com ([65.55.90.215]:55606 "EHLO
        SNT004-OMC4S12.hotmail.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932714AbcJNWNm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Oct 2016 18:13:42 -0400
From: Alberto Bursi <alberto.bursi@outlook.it>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Copy BTRFS volume to another BTRFS volume including subvolumes
 and snapshots
Date: Fri, 14 Oct 2016 22:07:57 +0000
Message-ID: <AM3PR08MB06421C9E387257BB6945837C92DF0@AM3PR08MB0642.eurprd08.prod.outlook.com>
References: <AM3PR08MB06423820D86D1E408FFD766492DC0@AM3PR08MB0642.eurprd08.prod.outlook.com>
 <905eb030-f8d8-b7cc-dd27-2f55e0d812c5@gmail.com>
In-Reply-To: <905eb030-f8d8-b7cc-dd27-2f55e0d812c5@gmail.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/14/2016 01:38 PM, Austin S. Hemmelgarn wrote:
> On 2016-10-13 17:21, Alberto Bursi wrote:
>> Hi, I'm using OpenSUSE on a btrfs volume spanning 2 disks (set as raid1
>> for both metadata and data), no separate /home partition.
>> -----
>> I'd like to be able to clone verbatim the whole volume to another
>> volume, for backup purposes.
>>
>> Now, I think I can do that with a brutal partition clone from my
>> "recovery" (a debian system installed in another drive) and then doing
>> the procedures to deal with a lost drive.
>>
>> But I'd rather prefer a clone on a live system, and without doing a
>> brutal clone as that will keep the same UUIDs.
>>
>> I can(will) script this so even if it is a tedious process or it
>> involves writing a huge line in the commandline it's not an issue.
> I'm not sure there is any way to do this on a live system.  You
> essentially need to either do a block level copy and change the UUID's
> (which recent versions of btrfstune can do), or use send with some
> manual setup to get the subvolumes across.  Both options require the
> filesystem to be effectively read-only, which is not something that any
> modern Linux distro can reliably handle for more than a few minutes.
>
> If I had to do this, I'd go with the block level copy, since it requires
> a lot less effort, just make sure to use btrfstune to change the UUID's
> when the copy is done (that may take a while itself though, since it has
> to rewrite a lot of metadata).

Heh, one of the reasons I migrated to btrfs was that I wanted to do 
things like these on a live system.

With my script I can already generate any necessary folder structure and 
send over all subvolumes with a bunch of btrfs send | btrfs receive with 
like 5 lines of script.

I was hoping there was some neat trick with btrfs send | btrfs receive
that allowed me to send a snapshot of / to the / of the new volume.

With rsync (from a ro snapshot of /) it should be possible to use the 
subvolume list as exclusion list, but I'd have rather wanted to use a 
btrfs feature instead.

-Alberto
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
