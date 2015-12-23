Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-18.italiaonline.it ([212.48.25.146]:58652 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932282AbbLWSUg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 13:20:36 -0500
Reply-To: kreijack@inwind.it
Subject: Re: Loss of connection to Half of the drives
References: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
 <CAJCQCtStfVppb-NU0EjeAVf6cs08cdcWCEDYLx4zMoOzbG0W+A@mail.gmail.com>
 <CAC=t97Ac07=ZFZ1nShfWc0ik50D90hBJM3bSEiLmHbKK36G9Xw@mail.gmail.com>
 <pan$9b1ad$a377a340$8346d054$a731dd54@cox.net>
 <CAC=t97BW6vYgi7edM=PknJDep9nJxDbOYpgPKi6L2u-J3hMwqQ@mail.gmail.com>
To: Donald Pearson <donaldwhpearson@gmail.com>, Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <567AE5F0.6060005@inwind.it>
Date: Wed, 23 Dec 2015 19:20:32 +0100
MIME-Version: 1.0
In-Reply-To: <CAC=t97BW6vYgi7edM=PknJDep9nJxDbOYpgPKi6L2u-J3hMwqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-23 16:53, Donald Pearson wrote:
[...]
> 
> Additionally real Raid10 will run circles around what BTRFS is doing
> in terms of performance.  In the 20 drive array you're striping across
> 10 drives, in BTRFS right now you're striping across 2 no matter what.
> So not only do I lose in terms of resilience I lose in terms of
> performance.  I assume that N-way-mirroring used with BTRFS Raid10
> will also increase the stripe width so that will level out the
> performance but you're always going to be short a drive for equal
> resilience.

In case of RAID10,on the best of my knowledge, BTRFS allocate each CHUNK across *all* the available devices. It uses the usual RAID0 (==striping) over a RAID1 (mirroring).

What you are describing is the BTRFS RAID1; i.e. LINEAR over a RAID1:each chunk is allocated in *two*, only *two* different disks from the disks pool; the disks are the ones with the largest free space. Each chunk may be allocated on a different *pair* of disks.

> And finally the elephant in the room that comes with the necessary
> 11-way mirroring is that the usable capacity of that 20 drive array.
> Remember, pea brain so my math may be wrong in application and
> calculation but if it's made of 1T drives for 20T raw, there is only
> 1.82T usable (20 / 11) and if I'm completely off in that figure the
> point is still that such a high level of mirroring is going to
> excessively consume drive space.

Ducan talked about a N-way mirroring, where each disks contains a copy of the same data. Nobody talked about N-way mirroring where N is less than the number of the available disks.

To be honest in the past appeared some patches to implement a generalized RAID-NxM raid, where N are the total disk, M are the redundancy disks: i.e. the filesystem could allow a drop of M disks (see http://www.spinics.net/lists/linux-btrfs/msg29245.html).

BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
