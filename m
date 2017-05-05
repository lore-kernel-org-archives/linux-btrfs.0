Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28918 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752585AbdEEBTe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 May 2017 21:19:34 -0400
Subject: Re: 4.11 relocate crash, null pointer + rolling back a filesystem by
 X hours?
To: Marc MERLIN <marc@merlins.org>, Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        <bo.li.liu@oracle.com>, <fdmanana@suse.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>
References: <20170501170641.GG3516@merlins.org>
 <20170501180856.GH3516@merlins.org>
 <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com>
 <20170502032346.ayhh3n3uh5d5ekbb@merlins.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <cc4ffae2-73d2-70bb-3c6c-0ec6a2bbaf13@cn.fujitsu.com>
Date: Fri, 5 May 2017 09:19:29 +0800
MIME-Version: 1.0
In-Reply-To: <20170502032346.ayhh3n3uh5d5ekbb@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 05/02/2017 11:23 AM, Marc MERLIN wrote:
> Hi Chris,
> 
> Thanks for the reply, much appreciated.
> 
> On Mon, May 01, 2017 at 07:50:22PM -0600, Chris Murphy wrote:
>> What about btfs check (no repair), without and then also with --mode=lowmem?
>>
>> In theory I like the idea of a 24 hour rollback; but in normal usage
>> Btrfs will eventually free up space containing stale and no longer
>> necessary metadata. Like the chunk tree, it's always changing, so you
>> get to a point, even with snapshots, that the old state of that tree
>> is just - gone. A snapshot of an fs tree does not make the chunk tree
>> frozen in time.
>   
> Right, of course, I was being way over optimistic here. I kind of forgot
> that metadata wasn't COW, my bad.
> 
>> In any case, it's a big problem in my mind if no existing tools can
>> fix a file system of this size. So before making anymore changes, make
>> sure you have a btrfs-image somewhere, even if it's huge. The offline
>> checker needs to be able to repair it, right now it's all we have for
>> such a case.
> 
> The image will be huge, and take maybe 24H to make (last time it took
> some silly amount of time like that), and honestly I'm not sure how
> useful it'll be.
> Outside of the kernel crashing if I do a btrfs balance, and hopefully
> the crash report I gave is good enough, the state I'm in is not btrfs'
> fault.
> 
> If I can't roll back to a reasonably working state, with data loss of a
> known quantity that I can recover from backup, I'll have to destroy and
> filesystem and recover from scratch, which will take multiple days.
> Since I can't wait too long before getting back to a working state, I
> think I'm going to try btrfs check --repair after a scrub to get a list
> of all the pathanmes/inodes that are known to be damaged, and work from
> there.
> Sounds reasonable?
> 
> Also, how is --mode=lowmem being useful?
> 
> And for re-parenting a sub-subvolume, is that possible?
> (I want to delete /sub1/ but I can't because I have /sub1/sub2 that's also a subvolume
> and I'm not sure how to re-parent sub2 to somewhere else so that I can subvolume delete
> sub1)
> 
> In the meantime, a simple check without repair looks like this. It will
> likely take many hours to complete:
> gargamel:/var/local/space# btrfs check /dev/mapper/dshelf2
> Checking filesystem on /dev/mapper/dshelf2
> UUID: 03e9a50c-1ae6-4782-ab9c-5f310a98e653
> checking extents
> checksum verify failed on 3096461459456 found 0E6B7980 wanted FBE5477A
> checksum verify failed on 3096461459456 found 0E6B7980 wanted FBE5477A
> checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
> checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
> checksum verify failed on 2899180224512 found ABBE39B0 wanted E0735D0E
> checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
> bytenr mismatch, want=2899180224512, have=3981076597540270796
> checksum verify failed on 1449488023552 found CECC36AF wanted 199FE6C5
> checksum verify failed on 1449488023552 found CECC36AF wanted 199FE6C5
> checksum verify failed on 1449544613888 found 895D691B wanted A0C64D2B
> checksum verify failed on 1449544613888 found 895D691B wanted A0C64D2B
> parent transid verify failed on 1671538819072 wanted 293964 found 293902
> parent transid verify failed on 1671538819072 wanted 293964 found 293902
> checksum verify failed on 1671603781632 found 18BC28D6 wanted 372655A0
> checksum verify failed on 1671603781632 found 18BC28D6 wanted 372655A0
> checksum verify failed on 1759425052672 found 843B59F1 wanted F0FF7D00
> checksum verify failed on 1759425052672 found 843B59F1 wanted F0FF7D00
> checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
> checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
> checksum verify failed on 2898779357184 found 96395131 wanted 433D6E09
> checksum verify failed on 2898779357184 found 96395131 wanted 433D6E09
> checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
> checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
> checksum verify failed on 2899180224512 found ABBE39B0 wanted E0735D0E
> checksum verify failed on 2899180224512 found 7A6D427F wanted 7E899EE5
> bytenr mismatch, want=2899180224512, have=3981076597540270796
> checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
> checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
> checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
> checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
> checksum verify failed on 2182657212416 found CD8EFC0C wanted 70847071
> (...)

Full output please.

I know it will be long, but the point here is, full output could help us 
to at least locate where the most corruption are.

If most corruption are only in extent tree, the chance to recover will 
increase hugely.

As extent tree is just a backref for all allocated extents, it's not 
really important if recovery (read) is the primary goal.

But if other tree (fs or subvolume tree important for you) also get 
corrupted, I'm afraid your last chance will be "btrfs restore" then.

Thanks,
Qu

> 
> Thanks,
> Marc
> 


