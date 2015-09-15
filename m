Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45543 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751414AbbIOBbh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Sep 2015 21:31:37 -0400
Subject: Re: unable to mount multi disk volume with recovery mode
To: Anand Jain <anand.jain@oracle.com>
References: <CAEyaVk+QnDb5sbfMtV_pGbkwA4BB9ODpVv-_hdMJWjuPbGG+Xg@mail.gmail.com>
 <55F66855.4010000@cn.fujitsu.com> <55F696F9.7090708@oracle.com>
CC: Ivan Petrovic <ivan@ipplus.rs>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55F774F0.2050001@cn.fujitsu.com>
Date: Tue, 15 Sep 2015 09:31:28 +0800
MIME-Version: 1.0
In-Reply-To: <55F696F9.7090708@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Aand,

Anand Jain wrote on 2015/09/14 17:44 +0800:
>
>
> Hi Qu,
>
>> Unfortunately, single mode means no duplication.
>> And degrade mount only works for RAID level with
>> duplication(DUP,RAID1/5/6/10).
>
> further to the below commit.
>
>   commit 95669976bd7d30ae265db938ecb46a6b7f8cb893
>      Btrfs: don't consider the missing device when allocating new chunks
>
> in case of 2-disk RAID1 mounted with only one good disk, we would create
> Single profile and actually the created single profiles are still
> workable with one disk failed.

Yep, that's the case, and Zhao Lei also found the problem and is still 
working on it internally.

But we are doing it in a more flex amd robust method:

No global missing device number check, but do per-chunk check against 
its stripes at mount time, to ensure it meets the minimum number for 
degradable condition.

So for single/raid0 chunk, they still can't be degraded mounted, if any 
of its stripe is missing.

> And so the proposed patch below will let
> single profile to be mount in this context..
>    [PATCH 23/23] Btrfs: allow -o rw,degraded for single group profile
>
> to recover when missing disk is replaced balance convert can migrate
> single profiles back to RAID1 profile.
>
> Also your explanation for degraded is correct, I am ok to use a new new
> mount option (like auto-reduced-profile ?) if needed / confusing.
Sorry for the confusion I caused.
But for above case, IHMO "degraded" is still the proper term.

For 2 disks, 1 missing, single chunk case, if the chunk is in the good 
disk, it should be a good chunk, no need to be degraded.

>
> Any comments / feedbacks are welcome.

But for the patch, I'd like to do it in the manner I mentioned:
Check every chunk for whether it's possible to be degraded,
other than current whole fs missing device check.

Thanks,
Qu

>
> Thanks, Anand
