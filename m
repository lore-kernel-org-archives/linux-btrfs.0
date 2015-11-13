Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58982 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754404AbbKMCwj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 21:52:39 -0500
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1447365063.7045.7.camel@scientia.net>
 <5645474D.8000804@cn.fujitsu.com> <1447381613.7045.21.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56455073.1060406@cn.fujitsu.com>
Date: Fri, 13 Nov 2015 10:52:35 +0800
MIME-Version: 1.0
In-Reply-To: <1447381613.7045.21.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Christoph Anton Mitterer wrote on 2015/11/13 03:26 +0100:
> Hey.
>
> On Fri, 2015-11-13 at 10:13 +0800, Qu Wenruo wrote:
>> Like this one, if any extent type doesn't match with its chunk, like
>> metadata extent in a data chunk, btrfsck will report like that.
> So these errors... are they anything serious? I.e. like data
> loss/corruption? Or is it more a "cosmetic" issue?
>
> And would there be a way for btrfs check to repair that thing?
>
> And is there a way to find out to which file these extents belong?

It can be done by the btrfs-debug-tree way.
But it's never a user-friendly one...
Not sure if there is a good tool.

>
>
>> The filesystem seems to be a converted one from ext*.
> No,it was not... any other reasons that could cause this?
>
> It's actually a very plain btrfs... no RAID, no qgroups,... the only
> thing I really did was creating snapshots and incrementally send'ing
> them to other btrfs (i.e. the backups).
> I'd have expected that btrfs is more or less table in these cases.
>

So there is some bug hidden...

>
>> But some user, like Roman Mamedov in the maillist, said a balance
>> operation can solve it.
>> It's worthy trying but it may also cause unknown bugs.
> So what's the safest way? Copying off all data and creating the fs from
> scratch?
> If so, is there a (safe) way to copy a fully fs with the snapshots?

I'm not a experienced btrfs user, so no good advice here.

>
> But as I've said, this wasn't an ext converted fs, so in case I do this
> or the balance we probably loose any chances to further debug.

You can provide the output of "btrfs-debug-tree -t 2 <dev>" to help 
further debug.
It would be quite big, so it's better to zip it.

Although it may not help a lot, but at least I can tell you which file 
extents are affected. (By the hard way, I can only tell you which inode 
in which subvolume is affected, all in numeric form)

And I could get enough info to determine what's the wrong type.
(data extent in metadata chunk or vice verse, or even system chunk is 
involved)

>
> And is there any way to tell more certain, whether the balance would
> help or whether I'd just get more possibly even hidden corruptions? I
> mean right... well it would be painful to recover from the most recent
> backup, but not extremely painful.

When extent and chunk type get wrong, only god knows what will happen...
So no useful help here.

>
>
> Right now I'm doing a full read-only scrub, which will take a while as
> it's a nearly full 8TB HDD, so far no errors.

If the type mismatch errors are the only error output from fsck, then 
scrub should not help or report anything useful.

And at last, what's the kernel and btrfs-progs version?

Thanks,
Qu

>
>
> Thanks,
> Chris.
>
