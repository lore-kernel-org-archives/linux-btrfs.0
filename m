Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34134 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752060AbcFTVfV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jun 2016 17:35:21 -0400
Received: by mail-ob0-f179.google.com with SMTP id ru5so560890obc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Jun 2016 14:35:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160620204049.GA1986@hungrycats.org>
References: <20160620034427.GK15597@hungrycats.org>
	<20160620231351.1833a341@natsu>
	<20160620191112.GL15597@hungrycats.org>
	<CAJCQCtR9uAn58KJKEjCsbyLYJTQVqMx-ghsVp_MjLBF-aiikcg@mail.gmail.com>
	<20160620204049.GA1986@hungrycats.org>
Date: Mon, 20 Jun 2016 15:27:03 -0600
Message-ID: <CAJCQCtR5pV53mFyGWxRxm69zwF5_sEvNRRRvOSgnZ1t8KZdc3g@mail.gmail.com>
Subject: Re: Adventures in btrfs raid5 disk recovery
From: Chris Murphy <lists@colorremedies.com>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: Chris Murphy <lists@colorremedies.com>, Roman Mamedov <rm@romanrm.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 20, 2016 at 2:40 PM, Zygo Blaxell
<ce3g8jdj@umail.furryterror.org> wrote:
> On Mon, Jun 20, 2016 at 01:30:11PM -0600, Chris Murphy wrote:

>> For me the critical question is what does "some corrupted sectors" mean?
>
> On other raid5 arrays, I would observe a small amount of corruption every
> time there was a system crash (some of which were triggered by disk
> failures, some not).

What test are you using to determine there is corruption, and how much
data is corrupted? Is this on every disk? Non-deterministically fewer
than all disks? Have you identified this as a torn write or
misdirected write or is it just garbage at some sectors? And what's
the size? Partial sector? Partial md chunk (or fs block?)

>  It looked like any writes in progress at the time
> of the failure would be damaged.  In the past I would just mop up the
> corrupt files (they were always the last extents written, easy to find
> with find-new or scrub) and have no further problems.

This is on Btrfs? This isn't supposed to be possible. Even a literal
overwrite of a file is not an overwrite on Btrfs unless the file is
nodatacow. Data extents get written, then the metadata is updated to
point to those new blocks. There should be flush or fua requests to
make sure the order is such that the fs points to either the old or
new file, in either case uncorrupted. That's why I'm curious about the
nature of this corruption. It sounds like your hardware is not exactly
honoring flush requests.

With md raid and any other file system, it's pure luck that such
corrupted writes would only affect data extents and not the fs
metadata. Corrupted fs metadata is not well tolerated by any file
system, not least of which is most of them have no idea the metadata
is corrupt. At least Btrfs can determine this and if there's another
copy use that or just stop and face plant before more damage happens.
Maybe an exception now is XFS v5 metadata which employs checksumming.
But it still doesn't know if data extents are wrong (i.e. a torn or
misdirected write).

I've had perhaps a hundred power off during write with Btrfs and SSD
and I don't ever see corrupt files. It's definitely not normal to see
this with Btrfs.


> In the earlier
> cases there were no new instances of corruption after the initial failure
> event and manual cleanup.
>
> Now that I did a little deeper into this, I do see one fairly significant
> piece of data:
>
>         root@host:~# btrfs dev stat /data | grep -v ' 0$'
>         [/dev/vdc].corruption_errs 16774
>         [/dev/vde].write_io_errs   121
>         [/dev/vde].read_io_errs    4
>         [devid:8].read_io_errs    16
>
> Prior to the failure of devid:8, vde had 121 write errors and 4 read
> errors (these counter values are months old and the errors were long
> since repaired by scrub).  The 16774 corruption errors on vdc are all
> new since the devid:8 failure, though.

On md RAID 5 and 6, if the array gets parity mismatch counts above 0
doing a scrub (check > md/sync_action) there's a hardware problem.
It's entirely possible you've found a bug, but it must be extremely
obscure to basically not have hit everyone trying Btrfs raid56. I
think you need to track down the source of this corruption and stop it
 however possible; whether that's changing hardware, or making sure
the system isn't crashing.

-- 
Chris Murphy
