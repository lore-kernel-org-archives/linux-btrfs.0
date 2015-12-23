Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:35175 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbbLWWPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 17:15:55 -0500
Received: by mail-ob0-f172.google.com with SMTP id 18so174852689obc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 14:15:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <567AE5F0.6060005@inwind.it>
References: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
 <CAJCQCtStfVppb-NU0EjeAVf6cs08cdcWCEDYLx4zMoOzbG0W+A@mail.gmail.com>
 <CAC=t97Ac07=ZFZ1nShfWc0ik50D90hBJM3bSEiLmHbKK36G9Xw@mail.gmail.com>
 <pan$9b1ad$a377a340$8346d054$a731dd54@cox.net> <CAC=t97BW6vYgi7edM=PknJDep9nJxDbOYpgPKi6L2u-J3hMwqQ@mail.gmail.com>
 <567AE5F0.6060005@inwind.it>
From: Donald Pearson <donaldwhpearson@gmail.com>
Date: Wed, 23 Dec 2015 16:15:35 -0600
Message-ID: <CAC=t97CP1Hn22R=ZV-jVmkbnFJ_V6Dt15Bi=H0ZNPSB2=ECuGg@mail.gmail.com>
Subject: Re: Loss of connection to Half of the drives
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 23, 2015 at 12:20 PM, Goffredo Baroncelli
<kreijack@inwind.it> wrote:
> On 2015-12-23 16:53, Donald Pearson wrote:
> [...]
>>
>> Additionally real Raid10 will run circles around what BTRFS is doing
>> in terms of performance.  In the 20 drive array you're striping across
>> 10 drives, in BTRFS right now you're striping across 2 no matter what.
>> So not only do I lose in terms of resilience I lose in terms of
>> performance.  I assume that N-way-mirroring used with BTRFS Raid10
>> will also increase the stripe width so that will level out the
>> performance but you're always going to be short a drive for equal
>> resilience.
>
> In case of RAID10,on the best of my knowledge, BTRFS allocate each CHUNK across *all* the available devices. It uses the usual RAID0 (==striping) over a RAID1 (mirroring).
>
> What you are describing is the BTRFS RAID1; i.e. LINEAR over a RAID1:each chunk is allocated in *two*, only *two* different disks from the disks pool; the disks are the ones with the largest free space. Each chunk may be allocated on a different *pair* of disks.
>

Okay so however the chunk is divided up, 2 copies of each chunk
division is written somewhere.  So I misunderstood, thanks for
clearing it up!

>> And finally the elephant in the room that comes with the necessary
>> 11-way mirroring is that the usable capacity of that 20 drive array.
>> Remember, pea brain so my math may be wrong in application and
>> calculation but if it's made of 1T drives for 20T raw, there is only
>> 1.82T usable (20 / 11) and if I'm completely off in that figure the
>> point is still that such a high level of mirroring is going to
>> excessively consume drive space.
>
> Ducan talked about a N-way mirroring, where each disks contains a copy of the same data. Nobody talked about N-way mirroring where N is less than the number of the available disks.
>

Well that was certainly implied as the unimplemented solution to
dropping half the drives that the OP tested.  N-way mirroring where N
= the number of drives is just Raid1 on crack and not the Raid10
use-case that the OP is asking about.

> To be honest in the past appeared some patches to implement a generalized RAID-NxM raid, where N are the total disk, M are the redundancy disks: i.e. the filesystem could allow a drop of M disks (see http://www.spinics.net/lists/linux-btrfs/msg29245.html).
>
> BR
> G.Baroncelli
>
>
> --
> gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
> Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5


Yeah that whole thing is pretty upsetting.
