Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-03v.sys.comcast.net ([69.252.207.35]:41667 "EHLO
	resqmta-ch2-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751345AbaLJABF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Dec 2014 19:01:05 -0500
Message-ID: <54878D3E.8020809@pobox.com>
Date: Tue, 09 Dec 2014 16:01:02 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Patrik Lundquist <patrik.lundquist@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Fixing Btrfs Filesystem Full Problems typo?
References: <CAA7pwKNH-Cbd+_D+sCEJxxdervLC=_3_AzaywSE3mXi8MLydxw@mail.gmail.com>	<20141122222606.GO8916@merlins.org>	<CAA7pwKOSbdxaiN=_ERSQLnoPNBfO0cyzamuv=xsWtvpro-+JJg@mail.gmail.com>	<20141123000503.GQ32735@carfax.org.uk>	<20141123010742.GA16599@merlins.org>	<pan$5df6$ab571fd5$d428faeb$f4fcc034@cox.net>	<CAA7pwKOAvTNAprN+pebZ3Qow-U2SBjLP_XbVXcVKY4NeFS_qRQ@mail.gmail.com>	<pan$1cbab$ed4a0087$b6b58a81$490b38ad@cox.net>	<CAA7pwKNPV3PCLP3s_MzoMG2da6Rfsy9HM=b8o8u87QqDV5WB+w@mail.gmail.com> <CAA7pwKOtOeCL-40EjqmEZ=NR=7Nfz_1Kzx2X4O105ndKGJMkrA@mail.gmail.com> <54878A65.2080403@pobox.com>
In-Reply-To: <54878A65.2080403@pobox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/09/2014 03:48 PM, Robert White wrote:
> On 12/09/2014 02:29 PM, Patrik Lundquist wrote:
>  > (stuff depicting a nearly full file system).
>
> Having taken another look at it all, I'd bet (there is not sufficient
> information to be _sure_ from the output you've provided) that you don't
> have the necessary 1Gb free on your disk slice to allocate another data
> extent. The COW portion of some consolidation event is being blocked for
> lack of any place to put the condensed/congealed result of balancing one
> or more of your blocks. You are gong to have to grow your filesystem by
> at least 1 gig to get the balance to complete as-is; or alternately
> remove at least a gig worth of "large files" (e.g. files that are stored
> in a DATA extent as opposed to small ones stored in the metadata).
>
> In the alternate, if you have a "bigger drive" to use, then add that
> device to the file system (q.v. "btrfs device add /dev/sdd1 /muntpoint")
> and then remove the current device (q.v. "btrfs device delete /dev/sdc1
> /mountpoint"). You now have the filesystem on a bigger media where stuff
> can happen correctly.
>
> At _that_ point you can RAID the larger device to equally sized peers
> etc. if your actual goal is to establish full redundancy.
>
> ===
>
> If the whole raiding thing was about running out of space, then you are
> actually "done" as soon as you add the second device. It will be used
> automatically, and you can balance over to it directly or not as you see
> fit.
>
> In particular if you have another drive/slice of equal size and you
> intend to spread out onto it, your best choices are ::
>
> btrfs device add /dev/sdd1 /mp

EDIT :: SLIGHT BOO BOO maybe...

You may not have enough data chunks to get the -dconvert=raid0 to run 
right (I've never done the experiment but you are probably still 
COW-blocked) away as I don't know if the convert will drop back to "make 
room" mode and just bump some data aside before doing the conversion. So 
you might need to do a limited data balance before you do either of the 
below.

btrfs balance start -dlimit=20 /mp #20 is a wild guess at a good number

This will examine 20 chunks, and likely move at least one or two, if not 
all twenty, onto the second drive. This will make room for the 
subsequent raid0 segments on the first drive.


>
> btrfs balance start -dconvert=raid0 -mconvert=dup -sconvert=dup /mp
> --or--
> btrfs balance start -dconvert=raid0 -mconvert=raid1 -sconvert=raid1 /mp
>
> (the latter is more preservative of information a failed media, but
> since your bulk data isn't being stored redundantly it probably doesn't
> matter which you use.)
>
> Once the second drive is in place you'll have the room you need for the
> balances to finish.
>
> In the second model you'll be spreading your bulk data out onto the two
> drives "evenly" via striping (raid0) and your metadata will be
> duplicated between the two slices.
>
> If you are adding storage and you are _not_ going to be adding it all
> with -dconvert=raid1, it doesn't matter that you don't currently have
> the needed space for a balance to complete on the currently full media.
> If you are trying to raid1 your entire filesystem when you are already
> effectively out of space, you will find no joy. Adding a full media
> raid1 is a no-op for available space.
>

(EDIT::Continued.) Worse case, just add the second device and run a 
balance with no arguments to spread your data out. Then run the format 
specific conversions to get it all rational and optimal.

Full filesystems always get into corner cases.
