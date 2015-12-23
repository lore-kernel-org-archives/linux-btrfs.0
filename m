Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:35282 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbbLWXNr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Dec 2015 18:13:47 -0500
Received: by mail-ig0-f180.google.com with SMTP id to4so89549680igc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Dec 2015 15:13:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC=t97CP1Hn22R=ZV-jVmkbnFJ_V6Dt15Bi=H0ZNPSB2=ECuGg@mail.gmail.com>
References: <CAD=LdFREn-jTEXTHw_Q+zbnva3dSWtb_aKcYS+6paidBjH7U8A@mail.gmail.com>
	<CAJCQCtStfVppb-NU0EjeAVf6cs08cdcWCEDYLx4zMoOzbG0W+A@mail.gmail.com>
	<CAC=t97Ac07=ZFZ1nShfWc0ik50D90hBJM3bSEiLmHbKK36G9Xw@mail.gmail.com>
	<pan$9b1ad$a377a340$8346d054$a731dd54@cox.net>
	<CAC=t97BW6vYgi7edM=PknJDep9nJxDbOYpgPKi6L2u-J3hMwqQ@mail.gmail.com>
	<567AE5F0.6060005@inwind.it>
	<CAC=t97CP1Hn22R=ZV-jVmkbnFJ_V6Dt15Bi=H0ZNPSB2=ECuGg@mail.gmail.com>
Date: Wed, 23 Dec 2015 16:13:46 -0700
Message-ID: <CAJCQCtTNnrb_P367uqZLz7deGNUA3+1akzpKZn_vQxKvaJ6frA@mail.gmail.com>
Subject: Re: Loss of connection to Half of the drives
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 23, 2015 at 3:15 PM, Donald Pearson
<donaldwhpearson@gmail.com> wrote:
> On Wed, Dec 23, 2015 at 12:20 PM, Goffredo Baroncelli

>> Ducan talked about a N-way mirroring, where each disks contains a copy of the same data. Nobody talked about N-way mirroring where N is less than the number of the available disks.
>>
>
> Well that was certainly implied as the unimplemented solution to
> dropping half the drives that the OP tested.  N-way mirroring where N
> = the number of drives is just Raid1 on crack and not the Raid10
> use-case that the OP is asking about.

How does the OP's use case normally get implemented? For separate
controllers, this would need to be software raid10, but you'd need a
way to specify the drive pairings. How does mdadm create -l raid10
enable that? Or to make absolutely certain, do you put them all in a
container and then first create -l raid1, and then second create -l
raid0?

In any case, what you get is drive level granularity for mirroring. A
drive has an exact (excluding layout options, but still data exact)
copy. That's not true with Btrfs where the granularity is the data
chunk (1+GiB). A given drive's chunks will definitely have copies on
multiple drives rather than on a single drive. And those multiple
drives will variably be on both sides of a controller or drive
make/model division.

One of the major differences of Btrfs with all profiles is that it
deals with different sized devices elegantly. That's because of the
chunk level granularity.

So I think that having mirrors of drives rather than chunks means that
we have to have exact size drive pairings.



-- 
Chris Murphy
