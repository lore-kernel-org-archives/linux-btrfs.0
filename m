Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35680 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752537AbdIAXCu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Sep 2017 19:02:50 -0400
From: Josef Bacik <jbacik@fb.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Date: Fri, 1 Sep 2017 23:01:30 +0000
Message-ID: <11510543-DAC5-400B-8204-C1FCC12CF335@fb.com>
References: <20170715012216.njq6az3y34qyomtb@merlins.org>
 <20170715231245.GA28281@merlins.org> <20170829031637.GA15290@merlins.org>
 <F952197E-3A13-410A-B299-F5C0791A99DF@fb.com>
 <20170829143955.GD15290@merlins.org>
 <EEF8B32C-179F-431A-880F-A27AD96B4BEF@fb.com>
 <20170830034001.rlwaqsitco65exqi@merlins.org>
 <D6E7AD8E-AF2B-4A17-9692-FDE17F31A8D2@fb.com>
 <20170831173607.GM15290@merlins.org>
 <5320FF2E-D183-4D2A-A155-49424E1CD60F@fb.com>,<20170901204329.GH30689@merlins.org>
In-Reply-To: <20170901204329.GH30689@merlins.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You'll be fine, it's only happening on the one fs right?  That's 13gib of metadata with checksums and all that shit, it'll probably look like 8 or 9gib of ram worst case.  I'd mount with -o ref_verify and check the slab amount in /proc/meminfo to get an idea of real usage.  Once the mount is finished that'll be about as much metadata you will use, of course it'll grow as metadata usage grows but it should be nominal.  Thanks,

Josef

Sent from my iPhone

> On Sep 1, 2017, at 4:43 PM, Marc MERLIN <marc@merlins.org> wrote:
> 
>> On Thu, Aug 31, 2017 at 05:48:23PM +0000, Josef Bacik wrote:
>> We are using 4.11 in production at fb with backports from recent (a month ago?) stuff.  Iâ€™m relatively certain nothing bad will happen, and this branch has the most recent fsync() corruption fix (which exists in your kernel so itâ€™s not new).  That said if you are uncomfortable I can rebase this patch onto whatever base you want and push out a branch, itâ€™s your choice.  Keep in mind this is going to hold a lot of shit in memory, so I hope you have enough, and Iâ€™d definitely remove the sleepâ€™s from your script, thereâ€™s no telling if this is a race condition or not and the overhead of the ref-verify stuff may cause it to be less likely to happen.  Thanks,
> 
> Thanks for the warning. I have 32GB of RAM in the server, and I probably use
> 8. Most of the rest is so that I can do btrfs check --repair without the
> machine dying :-/
> 
> I am concerned that I have a lot more metadata than I have memory:
> gargamel:~# btrfs fi df /mnt/btrfs_pool1
> Data, single: total=10.66TiB, used=10.60TiB
> System, DUP: total=32.00MiB, used=1.20MiB
> Metadata, DUP: total=58.00GiB, used=12.76GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> gargamel:~# btrfs fi df /mnt/btrfs_pool2
> Data, single: total=5.07TiB, used=4.78TiB
> System, DUP: total=8.00MiB, used=640.00KiB
> Metadata, DUP: total=70.50GiB, used=66.58GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> That's 13GB + 67GB.
> Is it going to fall over if I only have 32GB of RAM?
> 
> If I stop mounting /mnt/btrfs_pool2 for a while, will 32GB of RAM
> cover the 13GB of metadata from /mnt/btrfs_pool1 ?
> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                      .... what McDonalds is to gourmet cooking
> Home page: https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.merlins.org_&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=sDzg6MvHymKOUgI8SFIm4Q&m=9sSxC-1zmDEfNiAWSOeOTrz03WlT5Fd1j_U0WK0kfPk&s=YbE1JGIKZGAAWnKVWJfwkj0Fu_GC6OYF7fmbfjcrqHY&e=   
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
