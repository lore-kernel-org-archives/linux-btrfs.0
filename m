Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:56857 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdFOGqZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 02:46:25 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dLOXo-0003q6-I6
        for linux-btrfs@vger.kernel.org; Thu, 15 Jun 2017 08:46:16 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: csum failed root -9
Date: Thu, 15 Jun 2017 08:46:04 +0200
Message-ID: <20170615084604.2794d8b0@jupiter.sol.kaishome.de>
References: <CAPmG0jb=tokuCxBe6U3Rg+36X-70ptC2bhWx23e38ZxUjTgM4A@mail.gmail.com>
        <20170613072420.17314dbb@jupiter.sol.kaishome.de>
        <CAPmG0jbVju+S=jqmk+qr8L4MMe-5NirFVV8R7VQeczGjE=6Waw@mail.gmail.com>
        <CAPmG0jaVbfoL8-PpDT-=B+w_JH9H4ukJQm5UUkZFRKS6uSAs+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Wed, 14 Jun 2017 15:39:50 +0200
schrieb Henk Slager <eye1tm@gmail.com>:

> On Tue, Jun 13, 2017 at 12:47 PM, Henk Slager <eye1tm@gmail.com>
> wrote:
> > On Tue, Jun 13, 2017 at 7:24 AM, Kai Krakow <hurikhan77@gmail.com>
> > wrote:  
> >> Am Mon, 12 Jun 2017 11:00:31 +0200
> >> schrieb Henk Slager <eye1tm@gmail.com>:
> >>  
>  [...]  
> >>
> >> There's btrfs-progs v4.11 available...  
> >
> > I started:
> > # btrfs check -p --readonly /dev/mapper/smr
> > but it stopped with printing 'Killed' while checking extents. The
> > board has 8G RAM, no swap (yet), so I just started lowmem mode:
> > # btrfs check -p --mode lowmem --readonly /dev/mapper/smr
> >
> > Now after a 1 day 77 lines like this are printed:
> > ERROR: extent[5365470154752, 81920] referencer count mismatch (root:
> > 6310, owner: 1771130, offset: 33243062272) wanted: 1, have: 2
> >
> > It is still running, hopefully it will finish within 2 days. But
> > lateron I can compile/use latest progs from git. Same for kernel,
> > maybe with some tweaks/patches, but I think I will also plug the
> > disk into a faster machine then ( i7-4770 instead of the J1900 ).
> >  
>  [...]  
> >>
> >> What looks strange to me is that the parameters of the error
> >> reports seem to be rotated by one... See below:
> >>  
>  [...]  
> >>
> >> Why does it say "ino 1"? Does it mean devid 1?  
> >
> > On a 3-disk btrfs raid1 fs I see in the journal also "read error
> > corrected: ino 1" lines for all 3 disks. This was with a 4.10.x
> > kernel, ATM I don't know if this is right or wrong.
> >  
>  [...]  
> >>
> >> And why does it say "root -9"? Shouldn't it be "failed -9 root 257
> >> ino 515567616"? In that case the "off" value would be completely
> >> missing...
> >>
> >> Those "rotations" may mess up with where you try to locate the
> >> error on disk...  
> >
> > I hadn't looked at the numbers like that, but as you indicate, I
> > also think that the 1-block csum fail location is bogus because the
> > kernel calculates that based on some random corruption in critical
> > btrfs structures, also looking at the 77 referencer count
> > mismatches. A negative root ID is already a sort of red flag. When
> > I can mount the fs again after the check is finished, I can
> > hopefully use the output of the check to get clearer how big the
> > 'damage' is.  
> 
> The btrfs lowmem mode check ends with:
> 
> ERROR: root 7331 EXTENT_DATA[928390 3506176] shouldn't be hole
> ERROR: errors found in fs roots
> found 6968612982784 bytes used, error(s) found
> total csum bytes: 6786376404
> total tree bytes: 25656016896
> total fs tree bytes: 14857535488
> total extent tree bytes: 3237216256
> btree space waste bytes: 3072362630
> file data blocks allocated: 38874881994752
>  referenced 36477629964288
> 
> In total 2000+ of those "shouldn't be hole" lines.
> 
> A non-lowmem check, now done with kernel 4.11.4 and progs v4.11 and
> 16G swap added ends with 'noerrors found'

Don't trust lowmem mode too much. The developer of lowmem mode may tell
you more about specific edge cases.

> W.r.t. holes, maybe it is woth to mention the super-flags:
> incompat_flags          0x369
>                         ( MIXED_BACKREF |
>                           COMPRESS_LZO |
>                           BIG_METADATA |
>                           EXTENDED_IREF |
>                           SKINNY_METADATA |
>                           NO_HOLES )

I think it's not worth to follow up on this holes topic: I guess it was
a false report of lowmem mode, and it was fixed with 4.11 btrfs progs.

> The fs has received snapshots from source fs that had NO_HOLES enabled
> for some time, but after registed this bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=121321
> I put back that NO_HOLES flag to zero on the source fs. It seems I
> forgot to do that on the 8TB target/backup fs. But I don't know if
> there is a relation between this flag flipping and the btrfs check
> error messages.
> 
> I think I leave it as is for the time being, unless there is some news
> how to fix things with low risk (or maybe via a temp overlay snapshot
> with DM). But the lowmem check took 2 days, that's not really fun.
> The goal for the 8TB fs is to have an up to 7 year snapshot history at
> sometime, now the oldest snapshot is from early 2014, so almost
> halfway :)

Btrfs is still much too unstable to trust 7 years worth of backup to
it. You will probably loose it at some point, especially while many
snapshots are still such a huge performance breaker in btrfs. I suggest
trying out also other alternatives like borg backup for such a project.


-- 
Regards,
Kai

Replies to list-only preferred.

