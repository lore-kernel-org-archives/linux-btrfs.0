Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:37320 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaEGISs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 May 2014 04:18:48 -0400
Date: Wed, 7 May 2014 01:18:40 -0700
From: Marc MERLIN <marc@merlins.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: raid0 vs single, and should we allow -mdup by default on SSDs?
Message-ID: <20140507081840.GM10159@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$43f87$1b04f612$26876f7$5d505a6d@cox.net>
 <pan$31100$5edd829$14fe1b2f$4e1f4bd7@cox.net>
 <pan$a6ac4$b6e79aa$56ddd950$5b7b75c2@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris and other devs,

Does it really make sense to turn off -mdup on SSDs? I would argue that
no. In my case dmcrypt protected me from that, so I'm happy, but even if
I didn't use it, I'd want the protection of -mdup, even if the
protection mght only be partial.

On Tue, May 06, 2014 at 05:16:08PM +0000, Duncan wrote:
> Single only stripes in such extremely large (1 GiB data, quarter-GiB 
> metadata, per strip) chunks that it doesn't matter for speed, and then 
> only as a result of its chunk allocation policy.  If one can define such 
> large strips as striping, which it is in a way, but not really in the 
> practical sense.
 
Oh good, I didn't know it was that big.

> The effect of a lost device, then, is more or less random, tho for single 
> metadata the effect is likely to be quite large up to total loss, due to 
> the damage to the tree.  It's not out of thin air that the multi-device 

Yes. I totally use either -mdup or -mraid1.

> That contrasts with raid0, where the striping is at sizes well under a 
> chunk (memory page size or 4 MiB on x86/amd64 data I believe, tho the 
> fact that files under the 16 MiB node size may actually be entirely 
> folded into metadata and not have a data extent allocation at all skews 
> things for up to the 16 MiB metadata node size), so the definition of 
> "small file likely to be recovered" is **MUCH** smaller on raid0, than on 
> single.

Great to know, I'll use -m raid1 -d single next time.

> Effectively, raid0 data you're only (relatively) likely to recover files 
> smaller than 16 MiB, while single data, it's files smaller than 1 GiB.

Thanks much for that.

On Tue, May 06, 2014 at 07:05:52PM +0000, Duncan wrote:
> 1) In ordered to do that, btrfs (I guess mkfs.btrfs in this case) must be 
> able to detect that the device *IS* ssd.  Depending on the SSD, the 
> kernel version, and whether the btrfs is being created direct on bare-
> metal device or on some device layered (lvm or dmcrypt or whatever) on 
> top of the bare metal, btrfs may or may not successfully detect that.
> 
> Obviously in your case[1] the ssd wasn't detected.

Indeed.  I also found out why my SSD has -mdup: It's on top of dmcrypt
so btrfs failed to see it was and SSD and gave me -mdup. Good, that's
what I wanted anyway :)
 
> I believe I've seen you mention using dmcrypt or the like, however, which 
> probably doesn't pass whatever is used for ssd protection on thru, thus 
> explaining btrfs not seeing it and having to specify it yourself, if you 
> wish.
 
You guessed correctly, congrats.

> 2) The only reason I happen to know about the SSD metadata single-device 
> single mode default exception (where metadata otherwise defaults to dup 
> mode on single-device, and to raid1 mode on multi-device regardless of 
> the media), is as a result of I believe Chris Mason commenting on it in 
> an on-list reply.
> The reasoning given in that reply was not the erase-block reason I've 
> seen someone else mention here (and which doesn't quite make sense to me, 
> since I don't know why that would make a difference), but rather:

Yes. I personally don't think it's a good idea. Basically when having 2
copies, they could still end up on the same erase block, making them
less redundant.
My answer to that is 'so what?'
There are plenty of other times where dup would be useful on an SSD. I
really don't see the point of trying to it off by default just because
maybe in one case it would not offer extra protection.

> Some SSD firmware does automatic deduplication and compression.  On these 
> devices, DUP-mode would almost certainly be stored as a single internal 
> data block with two external address references anyway, so it would 
> actually be single in any case, and defaulting to single (a) doesn't hide 
> that fact, and (b) reduces overhead that's justified for safety 
> otherwise, but if the firmware is doing an end run around that safety 
> anyway, might as well just shortcut the overhead as well.

If some SSDs do this, let's not punish those have SSDs that don't.
 
> However, while the btrfs default will apply to all (detected) ssds, not 
> all ssds have firmware that does this internal deduplication!

Exactly.

On Tue, May 06, 2014 at 07:39:12PM +0000, Duncan wrote:
> Well, assuming that by -d linear you meant -d single. Btrfs doesn't call 
> it linear, tho at the data safety level, btrfs single is actually quite 
> comparable to mdadm linear.  =:^)  

Yes, I meant single, sorry :)
(aka linear for mdadm)
 
> > At the time I used -m raid1 -d raid0, but it sounds for slightly extra
> > recoverability, I should have ued -m raid1 -d linear (and yes, I
> > undertand that one should not consider a -d linear recoverable when a
> > drive went missing).
> 
> That appears to be a very good use of either -d raid0 or -d single, yes.  
> And since you're apparently not streaming such high resolution video that 
> you NEED the raid0, single does indeed give you a somewhat better chance 
> at recovery.
 
zoneminder saves 'video' as a stream of independent small jpegs, so I'm
good. Actually come to think of it they're so small that they probably
all ended up in the raid1 metadata. That also means that I'm not getting
twice the storage space like I planned to. Oh well...

Thanks for all the answers.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
