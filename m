Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from torres.zugschlus.de ([85.214.131.164]:39700 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbcCEO2j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Mar 2016 09:28:39 -0500
Received: from mh by torres.zugschlus.de with local (Exim 4.84)
	(envelope-from <mh+linux-btrfs@zugschlus.de>)
	id 1acDC9-0002Rz-3v
	for linux-btrfs@vger.kernel.org; Sat, 05 Mar 2016 15:28:37 +0100
Date: Sat, 5 Mar 2016 15:28:36 +0100
From: Marc Haber <mh+linux-btrfs@zugschlus.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Again, no space left on device while rebalancing and recipe
 doesnt work
Message-ID: <20160305142836.GD1902@torres.zugschlus.de>
References: <20160227211450.GS26042@torres.zugschlus.de>
 <56D3A56A.20809@cn.fujitsu.com>
 <20160229153352.GE2334@torres.zugschlus.de>
 <56D4E621.3010604@cn.fujitsu.com>
 <20160301065448.GJ2334@torres.zugschlus.de>
 <56D54393.8060307@cn.fujitsu.com>
 <pan$b2129$4febff94$eb9a65a0$72f9d0cf@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <pan$b2129$4febff94$eb9a65a0$72f9d0cf@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have not seen this message coming back to the mailing list. Was it
again too long?

I have pastebinned the log at http://paste.debian.net/412118/

On Tue, Mar 01, 2016 at 08:51:32PM +0000, Duncan wrote:
> There has been something bothering me about this thread that I wasn't 
> quite pinning down, but here it is.
> 
> If you look at the btrfs fi df/usage numbers, data chunk total vs. used 
> are very close to one another (113 GiB total, 112.77 GiB used, single 
> profile, assuming GiB data chunks, that's only a fraction of a single 
> data chunk unused), so balance would seem to be getting thru them just 
> fine.

Where would you see those numbers? I have those, pre-balance:

Mar  2 20:28:01 fan root: Data, single: total=77.00GiB, used=76.35GiB
Mar  2 20:28:01 fan root: System, DUP: total=32.00MiB, used=48.00KiB
Mar  2 20:28:01 fan root: Metadata, DUP: total=86.50GiB, used=2.11GiB
Mar  2 20:28:01 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B

> But there's a /huge/ spread between total vs. used metadata (32 GiB 
> total, under 4 GiB used, clearly _many_ empty or nearly empty chunks), 
> implying that has not been successfully balanced in quite some time, if 
> ever.

This is possible, yes.

>   So I'd surmise the problem is in metadata, not in data.
> 
> Which would explain why balancing data works fine, but a whole-filesystem 
> balance doesn't, because it's getting stuck on the metadata, not the data.
> 
> Now the balance metadata filters include system as well, by default, and 
> the -mprofiles=dup and -sprofiles=dup balances finished, apparently 
> without error, which throws a wrench into my theory.

Also finishes without changing things, post-balance:
Mar  2 21:55:37 fan root: Data, single: total=77.00GiB, used=76.36GiB
Mar  2 21:55:37 fan root: System, DUP: total=32.00MiB, used=80.00KiB
Mar  2 21:55:37 fan root: Metadata, DUP: total=99.00GiB, used=2.11GiB
Mar  2 21:55:37 fan root: GlobalReserve, single: total=512.00MiB, used=0.00B

Wait, Metadata used actually _grew_???

> But while we have the btrfs fi df from before the attempt with the 
> profiles filters, we don't have the same output from after.
s
We now have everything. New log attached.

> > I'd like to remove unused snapshots and keep the number of them to 4
> > digits, as a workaround.
> 
> I'll strongly second that recommendation.  Btrfs is known to have 
> snapshot scaling issues at 10K snapshots and above.  My strong 
> recommendation is to limit snapshots per filesystem to 3000 or less, with 
> a target of 2000 per filesystem or less if possible, and an ideal of 1000 
> per filesystem or less if it's practical to keep it to that, which it 
> should be with thinning, if you're only snapshotting 1-2 subvolumes, but 
> may not be if you're snapshotting more.

I'm snapshotting /home every 10 minutes, the filesystem that I have
been posting logs from has about 400 snapshots, and snapshot cleanup
works fine. The slow snapshot removal is a different filesystem on the
same host which is on a rotating rust HDD, and is much bigger.

> By 3000 snapshots per filesystem, you'll be beginning to notice slowdowns 
> in some btrfs maintenance commands if you're sensitive to it, tho it's 
> still at least practical to work with, and by 10K, it's generally 
> noticeable by all, at least once they thin down to 2K or so, as it's 
> suddenly faster again!  Above 100K, some btrfs maintenance commands slow 
> to a crawl and doing that sort of maintenance really becomes impractical 
> enough that it's generally easier to backup what you need to and blow 
> away the filesystem to start again with a new one, than it is to try to 
> recover the existing filesystem to a workable state, given that 
> maintenance can at that point take days to weeks.

Ouch. This shold not be the case, or btrfs subvolume snapshot should
at least emit a warning. It is not good that it is so easy to get a
filesystem into a state this bad.

> So 5-digits of snapshots on a filesystem is definitely well outside of 
> the recommended range, to the point that in some cases, particularly 
> approaching 6-digits of snapshots, it'll be more practical to simply 
> ditch the filesystem and start over, than to try to work with it any 
> longer.  Just don't do it; setup your thinning schedule so your peak is 
> 3000 snapshots per filesystem or under, and you won't have that problem 
> to worry about. =:^)

That needs to be documented prominently. Ths ZFS fanbois will love that.

> Oh, and btrfs quota management exacerbates the scaling issues 
> dramatically.  If you're using btrfs quotas

Am not, thankfully.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
