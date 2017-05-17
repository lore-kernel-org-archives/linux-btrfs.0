Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:35700 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdEQJpS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 05:45:18 -0400
Date: Wed, 17 May 2017 11:45:15 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: =?utf-8?Q?=C5=81ukasz_Wr=C3=B3blewski?= <lw@nri.pl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: RAID 6 corrupted
Message-ID: <20170517094515.6goz3eqjejqymhzc@angband.pl>
References: <CA+M=Xp3+YQkeVNLkSZw77zMdia2LwSiaEaR=6Ejs0z2TvW2xwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CA+M=Xp3+YQkeVNLkSZw77zMdia2LwSiaEaR=6Ejs0z2TvW2xwg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 17, 2017 at 10:27:53AM +0200, Łukasz Wróblewski wrote:
> About two years ago I created RAID 6 consisting of 5 disks with BTRFS.
> One of the disks has crashed.
> I started to exchange it for another, but I did something wrong.
> Or at the time, RAID56 support was experimental in BTRFS.

It still is experimental.  And not experimental as in "might have some
bugs", but as in "eats babies for breakfast".

> There was a situation where I could not mount the partition again.
> 
> I decided to put the disks aside and wait for the better tools.
> A newer version of BTRFS in the hope that I can retrieve the data.
> 
> Currently the situation looks like this:
>  ~ # uname -a
> Linux localhost 4.10.12-coreos #1 SMP Tue Apr 25 22:08:35 UTC 2017
> x86_64 AMD FX(tm)-6100 Six-Core Processor AuthenticAMD GNU/Linux

There were no RAID5/6 improvements for a long while, until a batch of fixes
got merged into 4.12-rc1 (yes, the first rc that Linus pushed just this
Sunday).

I'm not knowledgeable about this code, though -- I merely did some
superficial tests.  These tests show drastic improvement over 4.11 but I
don't even know how in-line repair is affected (I looked mostly as scrub).

>  ~ # btrfs --version
> btrfs-progs v4.4.1
>  ~ # btrfs fi show
> warning devid 1 not found already
> warning devid 4 not found already
> bytenr mismatch, want=2373780258816, have=0
> warning, device 7 is missing
> warning, device 1 is missing

So you have _two_ missing drives.  RAID6 should still recover from that, but
at least in 4.11 and earlier there were some serious problems.  No idea if
4.12-rc1 is better here.

> bytenr mismatch, want=2093993689088, have=0
> ERROR: cannot read chunk root
> Label: none  uuid: 50127310-d15c-49ca-8cdd-8798ea0fda2e
> Total devices 5 FS bytes used 5.44TiB
> devid    2 size 1.82TiB used 1.82TiB path /dev/sde
> devid    3 size 1.82TiB used 1.82TiB path /dev/sdc
> devid    5 size 1.82TiB used 1.82TiB path /dev/sdb
> *** Some devices missing
> 
> Label: 'DDR'  uuid: 4a9f6a0f-e41f-48a5-a566-507349d47b30
> Total devices 7 FS bytes used 477.15GiB
> devid    4 size 1.82TiB used 7.00GiB path /dev/sdd
> *** Some devices missing
> 
>  ~ # mount /dev/sdb /mnt/
> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
>  ~ # dmesg | tail
> [ 2612.350751] BTRFS info (device sde): disk space caching is enabled
> [ 2612.378507] BTRFS error (device sde): failed to read chunk tree: -5
> [ 2612.393729] BTRFS error (device sde): open_ctree failed
>  ~ # mount -o usebackuproot /dev/sdb /mnt/
> mount: wrong fs type, bad option, bad superblock on /dev/sdb,
>        missing codepage or helper program, or other error
> 
>        In some cases useful info is found in syslog - try
>        dmesg | tail or so.
>  ~ # dmesg | tail
> [ 2675.427445] BTRFS info (device sde): trying to use backup root at mount time
> [ 2675.434528] BTRFS info (device sde): disk space caching is enabled
> [ 2675.442031] BTRFS error (device sde): failed to read chunk tree: -5
> [ 2675.457321] BTRFS error (device sde): open_ctree failed
>  ~ #
> 
> 
> "fi show" shows two systems.
> It should really be one, but devid 4 should belong to
> uuid: 50127310-d15c-49ca-8cdd-8798ea0fda2e

This is one of the disks that are missing, so that's ok.  (Well, why it's
not a part of the filesystem anymore is not ok, but I'm speaking about
behaviour after the failure.)

> I tried
> ./btrfs restore /dev/sdb /mnt/restore
> 
> ...
> Trying another mirror
> Trying another mirror
> Trying another mirror
> Trying another mirror
> Trying another mirror
> Trying another mirror
> Trying another mirror
> Trying another mirror
> Trying another mirror
> Trying another mirror
> Trying another mirror
> Trying another mirror
> Trying another mirror
> bytenr mismatch, want=2373682249728, have=0
> bytenr mismatch, want=2373682233344, have=0
> bytenr mismatch, want=2373682249728, have=0
> Error searching -5
> Error searching /mnt/....
> 
> But little data has been recovered.

Restore is userspace rather than kernel, I don't know what kind of fixes it
had recently, but 4.4 you're using lacks almost two years of development, so
I'd try a more recent version before trying more involved steps.

> Can I retrieve my data?

If you do, I'd recommend switching to at least -mraid1 (RAID1 metadata
RAID5/6 data) -- a bug that hits a data block makes you lose a single file,
one that hits metadata tends to result in total filesystem loss, and RAID1
is quite reliable already.

> How can I do this?

That's the trick question. :/


Meow!
-- 
Don't be racist.  White, amber or black, all beers should be judged based
solely on their merits.  Heck, even if occasionally a cider applies for a
beer's job, why not?
On the other hand, corpo lager is not a race.
