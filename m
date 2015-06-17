Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38861 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbbFQQTx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 12:19:53 -0400
Date: Wed, 17 Jun 2015 09:19:36 -0700
From: Marc MERLIN <marc@merlins.org>
To: Sander <sander@humilis.net>, Duncan <1i5t5.duncan@cox.net>,
        Chris Murphy <lists@colorremedies.com>
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20150617161936.GK16468@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRwy_beFwAH8=WV0VpVW3295rB4UY6WQ0ZJf+bXynuXnw@mail.gmail.com>
 <pan$d7e40$f0fd83dc$6357f1e5$a552946e@cox.net>
 <20150617105835.GA28982@panda>
Subject: Re: BTRFS: read error corrected: ino 1 off 226840576 (dev
 /dev/mapper/dshelf1 sector 459432)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 17, 2015 at 01:51:26PM +0000, Duncan wrote:
> > Also, if my actual data got corrupted, am I correct that btrfs will
> > detect the checksum failure and give me a different error message of a
> > read error that cannot be corrected?
> > 
> > I'll do a scrub later, for now I have to wait 20 hours for the raid
> > rebuild first.
> 
> Yes again.
 
Great, thanks for confirming.
Makes me happy to know that checksums and metadata DUP are helping me
out here.
With ext4 I'd have been worse off for sure.

> One thing I'd strongly recommend.  Once the rebuild is complete and you 
> do the scrub, there may well be both read/corrected errors, and 
> unverified errors.  AFAIK, the unverified errors are a result of bad 
> metadata blocks, so missing checksums for what they covered.  So once you 

I'm slightly confused here. If I have metadata DUP and checksums, how
can metadata blocks be unverified?
Data blocks being unverified, I understand, it would mean the data or
checksum is bad, but I expect that's a different error message I haven't
seen yet.
(I use sec.pl which Emails me any btrfs kernel log line that's not
whitelisted as being known/OK)

On Wed, Jun 17, 2015 at 08:58:18AM -0600, Chris Murphy wrote:
> I think more information is needed at the time of this entry, maybe
> the previous 20 entries or so. That Btrfs thinks there is a read error
> is different than when it thinks there's a checksum error. For example
> when I willfully corrupt one sector that I know contains metadata,
> then read the file or do a scrub:
> 
> [48466.824770] BTRFS: checksum error at logical 20971520 on dev
> /dev/sdb, sector 57344: metadata leaf (level 0) in tree 3
> [48466.829900] BTRFS: checksum error at logical 20971520 on dev
> /dev/sdb, sector 57344: metadata leaf (level 0) in tree 3
> [48466.834944] BTRFS: bdev /dev/sdb errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
> [48466.853589] BTRFS: fixed up error at logical 20971520 on dev /dev/sdb
> 
> I'd expect in your case you have a bdev line that reads rd 1, corrupt 0.

Thankfully I have 0 checksum errors.

I looked at all the warnings I got last night, and none are repeated, so it looks like
it's just minor corruption I got from re-adding a raid drive that wasn't
100% in sync with the others, and btrfs nicely fixing things for me.
Nice! 

BTRFS: read error corrected: ino 1 off 205565952 (dev /dev/mapper/dshelf1 sector 417880)
BTRFS: read error corrected: ino 1 off 216420352 (dev /dev/mapper/dshelf1 sector 439080)
BTRFS: read error corrected: ino 1 off 216424448 (dev /dev/mapper/dshelf1 sector 439088)
BTRFS: read error corrected: ino 1 off 216473600 (dev /dev/mapper/dshelf1 sector 439184)
BTRFS: read error corrected: ino 1 off 226656256 (dev /dev/mapper/dshelf1 sector 459072)
BTRFS: read error corrected: ino 1 off 226693120 (dev /dev/mapper/dshelf1 sector 459144)
BTRFS: read error corrected: ino 1 off 226729984 (dev /dev/mapper/dshelf1 sector 459216)
BTRFS: read error corrected: ino 1 off 226734080 (dev /dev/mapper/dshelf1 sector 459224)
BTRFS: read error corrected: ino 1 off 226742272 (dev /dev/mapper/dshelf1 sector 459240)
BTRFS: read error corrected: ino 1 off 226758656 (dev /dev/mapper/dshelf1 sector 459272)
BTRFS: read error corrected: ino 1 off 226783232 (dev /dev/mapper/dshelf1 sector 459320)
BTRFS: read error corrected: ino 1 off 226811904 (dev /dev/mapper/dshelf1 sector 459376)
BTRFS: read error corrected: ino 1 off 226840576 (dev /dev/mapper/dshelf1 sector 459432)
BTRFS: read error corrected: ino 1 off 226865152 (dev /dev/mapper/dshelf1 sector 459480)
BTRFS: read error corrected: ino 1 off 226975744 (dev /dev/mapper/dshelf1 sector 459696)
BTRFS: read error corrected: ino 1 off 228589568 (dev /dev/mapper/dshelf1 sector 462848)
BTRFS: read error corrected: ino 1 off 228601856 (dev /dev/mapper/dshelf1 sector 462872)
BTRFS: read error corrected: ino 1 off 228610048 (dev /dev/mapper/dshelf1 sector 462888)
BTRFS: read error corrected: ino 1 off 228614144 (dev /dev/mapper/dshelf1 sector 462896)
BTRFS: read error corrected: ino 1 off 228618240 (dev /dev/mapper/dshelf1 sector 462904)
BTRFS: read error corrected: ino 1 off 228626432 (dev /dev/mapper/dshelf1 sector 462920)
BTRFS: read error corrected: ino 1 off 228630528 (dev /dev/mapper/dshelf1 sector 462928)
BTRFS: read error corrected: ino 1 off 228638720 (dev /dev/mapper/dshelf1 sector 462944)
BTRFS: read error corrected: ino 1 off 228642816 (dev /dev/mapper/dshelf1 sector 462952)
BTRFS: read error corrected: ino 1 off 228646912 (dev /dev/mapper/dshelf1 sector 462960)
BTRFS: read error corrected: ino 1 off 228651008 (dev /dev/mapper/dshelf1 sector 462968)
BTRFS: read error corrected: ino 1 off 228708352 (dev /dev/mapper/dshelf1 sector 463080)
BTRFS: read error corrected: ino 1 off 228712448 (dev /dev/mapper/dshelf1 sector 463088)
BTRFS: read error corrected: ino 1 off 228716544 (dev /dev/mapper/dshelf1 sector 463096)
BTRFS: read error corrected: ino 1 off 228720640 (dev /dev/mapper/dshelf1 sector 463104)
BTRFS: read error corrected: ino 1 off 228724736 (dev /dev/mapper/dshelf1 sector 463112)
BTRFS: read error corrected: ino 1 off 228728832 (dev /dev/mapper/dshelf1 sector 463120)
BTRFS: read error corrected: ino 1 off 228732928 (dev /dev/mapper/dshelf1 sector 463128)
BTRFS: read error corrected: ino 1 off 228737024 (dev /dev/mapper/dshelf1 sector 463136)
BTRFS: read error corrected: ino 1 off 228741120 (dev /dev/mapper/dshelf1 sector 463144)
BTRFS: read error corrected: ino 1 off 228745216 (dev /dev/mapper/dshelf1 sector 463152)
BTRFS: read error corrected: ino 1 off 228749312 (dev /dev/mapper/dshelf1 sector 463160)
BTRFS: read error corrected: ino 1 off 228753408 (dev /dev/mapper/dshelf1 sector 463168)
BTRFS: read error corrected: ino 1 off 228761600 (dev /dev/mapper/dshelf1 sector 463184)
BTRFS: read error corrected: ino 1 off 228765696 (dev /dev/mapper/dshelf1 sector 463192)
BTRFS: read error corrected: ino 1 off 228769792 (dev /dev/mapper/dshelf1 sector 463200)
BTRFS: read error corrected: ino 1 off 228782080 (dev /dev/mapper/dshelf1 sector 463224)
BTRFS: read error corrected: ino 1 off 228786176 (dev /dev/mapper/dshelf1 sector 463232)
BTRFS: read error corrected: ino 1 off 228794368 (dev /dev/mapper/dshelf1 sector 463248)
BTRFS: read error corrected: ino 1 off 228802560 (dev /dev/mapper/dshelf1 sector 463264)
BTRFS: read error corrected: ino 1 off 228810752 (dev /dev/mapper/dshelf1 sector 463280)
BTRFS: read error corrected: ino 1 off 228814848 (dev /dev/mapper/dshelf1 sector 463288)
BTRFS: read error corrected: ino 1 off 228818944 (dev /dev/mapper/dshelf1 sector 463296)
BTRFS: read error corrected: ino 1 off 228941824 (dev /dev/mapper/dshelf1 sector 463536)
BTRFS: read error corrected: ino 1 off 228954112 (dev /dev/mapper/dshelf1 sector 463560)
BTRFS: read error corrected: ino 1 off 228958208 (dev /dev/mapper/dshelf1 sector 463568)
BTRFS: read error corrected: ino 1 off 228974592 (dev /dev/mapper/dshelf1 sector 463600)
BTRFS: read error corrected: ino 1 off 228978688 (dev /dev/mapper/dshelf1 sector 463608)
BTRFS: read error corrected: ino 1 off 228982784 (dev /dev/mapper/dshelf1 sector 463616)
BTRFS: read error corrected: ino 1 off 229011456 (dev /dev/mapper/dshelf1 sector 463672)
BTRFS: read error corrected: ino 1 off 229060608 (dev /dev/mapper/dshelf1 sector 463768)
BTRFS: read error corrected: ino 1 off 229068800 (dev /dev/mapper/dshelf1 sector 463784)
BTRFS: read error corrected: ino 1 off 229093376 (dev /dev/mapper/dshelf1 sector 463832)
BTRFS: read error corrected: ino 1 off 229113856 (dev /dev/mapper/dshelf1 sector 463872)
BTRFS: read error corrected: ino 1 off 229158912 (dev /dev/mapper/dshelf1 sector 463960)
BTRFS: read error corrected: ino 1 off 229371904 (dev /dev/mapper/dshelf1 sector 464376)
BTRFS: read error corrected: ino 1 off 229445632 (dev /dev/mapper/dshelf1 sector 464520)

> Yes, it looks like this when the file is directly read:
> 
> [ 1457.231316] BTRFS warning (device sdb): csum failed ino 257 off 0
> csum 3703877302 expected csum 1978138932
> [ 1457.231842] BTRFS warning (device sdb): csum failed ino 257 off 0
> csum 3703877302 expected csum 1978138932
> 
> It looks like this during a scrub:
> 
> [ 1540.865520] BTRFS: checksum error at logical 12845056 on dev
> /dev/sdb, sector 25088, root 5, inode 257, offset 0, length 4096,
> links 1 (path: grub2-install)
> [ 1540.865534] BTRFS: bdev /dev/sdb errs: wr 0, rd 0, flush 0, corrupt 1, gen 0
> [ 1540.866944] BTRFS: unable to fixup (regular) error at logical
> 12845056 on dev /dev/sdb

the only csum issue I have is this one
BTRFS: csum mismatch on free space cache

and btrfs knows how to handle that one.

Thanks for the answers, it sounds like I'm all good.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
