Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35290 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbcCMD3K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Mar 2016 22:29:10 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aewiF-000515-H9
	for linux-btrfs@vger.kernel.org; Sun, 13 Mar 2016 04:29:03 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 04:29:03 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 13 Mar 2016 04:29:03 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Snapshots slowing system
Date: Sun, 13 Mar 2016 03:28:51 +0000 (UTC)
Message-ID: <pan$b315b$51883804$dab51362$72285105@cox.net>
References: <201603121301.u2CD1HCC022214@phoenix.vfire>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

pete posted on Sat, 12 Mar 2016 13:01:17 +0000 as excerpted:

> I hope this message stays within the thread on the list.  I had email
> problems and ended up hacking around with sendmail & grabbing the
> message id off of the web based group archives.

Looks like it should have as the reply-to looks right, but at least on 
gmane's news/nntp archive of the list (which is how I read and reply), it 
didn't.  But the thread was found easily enough.

>>I wondered whether you had elimated fragmentation, or any other known
>>gotchas, as a cause?
> 
> Subvolumes are mounted with the following options:
> autodefrag,relatime,compress=lzo,subvol=<sub vol name>

That relatime (which is the default), could be an issue.  See below.

> Not sure if there is much else to do about fragmentation apart from
> running a balance which would probally make thje machine v sluggish for
> a day or so.
> 
>>Out of curiosity, what is/was the utilisation of the disk? Were the
>>snapshots read-only or read-write?
> 
> root@phoenix:~# btrfs fi df /
> Data, single: total=101.03GiB, used=97.91GiB
> System, single: total=32.00MiB, used=16.00KiB
> Metadata, single: total=8.00GiB, used=5.29GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> root@phoenix:~# btrfs fi df /home
> Data, RAID1: total=1.99TiB, used=1.97TiB
> System, RAID1: total=32.00MiB, used=352.00KiB
> Metadata, RAID1: total=53.00GiB, used=50.22GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B

Normally when posting, either btrfs fi df *and* btrfs fi show are 
needed, /or/ (with a new enough btrfs-progs) btrfs fi usage.  And of 
course the kernel (4.0.4 in your case) and btrfs-progs (not posted, that 
I saw) versions.

Btrfs fi df shows the chunk allocation and usage within the chunks, but 
does not show the size of the filesystem or of individual devices.  Btrfs 
fi show, shows that, but not the chunk allocation and usage info.  Btrfs 
fi usage shows both, but it's a newer command that isn't available on old 
btrfs-progs, and was buggy for some layouts (raid56 and mixed-mode, where 
the bugs would cause the numbers to go negative, which would appear as 
EiB free (I wish!!)) until relatively recently.

> Hmm.  The system disk is getting a little tight. cddisk reports the
> partition I use for btrfs containing root as 127GB approx.  Not sure why
> it grows so much. Suspect that software updates can't help as snapshots
> will contain the legacy versions.  On the other hand they can be useful.

With the 127 GiB (I _guess_ it's GiB, 1024, not GB, 1000, multiplier, 
btrfs consistently uses the 1024 multiplier and properly specifies it 
using the XiB notation) for /, however, and the btrfs fi df sizes of 101 
GiB plus data and 8 GiB metadata (with system's 32 MiB a rounding error 
and global reserve actually taken from metadata, so it doesn't add to 
chunk reservation on its own) we can see that as you mention, it's 
starting to get tight, a bit under 110 GiB of 127 GiB, but that 17 GiB 
free isn't horrible, just slightly tight, as you said.

Tho it'll obviously be tighter if that's 127 GB, 1000 multiplier...

It's tight enough that particularly with the regular snapshotting, btrfs 
might be having to fragment more than it'd like.  Tho kudos for the 
_excellent_ snapshot rotation.  We regularly see folks in here with 100K 
or more snapshots per filesystem, and btrfs _does_ have scaling issues in 
that case.  But your rotation seems to be keeping it well below the 1-3K 
snapshots per filesystem recommended max, so that's obviously NOT you're 
problem, unless of course the snapshot deletion bugged out and they 
aren't being deleted as they should.

(Of course, you can check that by listing them, and I would indeed double-
check, as that _is_ the _usual_ problem we have with snapshots slowing 
things down, simply too many of them, hitting the known scaling issues 
btrfs had with over 10K snapshots per filesystem.  But FWIW I don't use 
snapshots here and thus don't deal with snapshots command-level detail.)


But as I mentioned above, that relatime mount option isn't your best 
choice, in the presence of heavy snapshotting.  Unless you KNOW you need 
atimes for something or other, noatime is _strongly_ recommended with 
snapshotting, because relatime, while /relatively/ better than 
strictatime, still updates atimes once a day for files you're accessing 
at least that frequently.

And that interacts badly with snapshots, particularly where few of the 
files themselves have changed, because in that case, a large share of the 
changes from one snapshot to another are going to be those atime updates 
themselves.  Ensuring that you're always using noatime avoids the atime 
updates entirely (well, unless the file itself changes and thus mtime 
changes as well), which should, in the normal most files unchanged 
snapshotting context, make for much smaller snapshot-exclusive sizes.

And you mention below that the snapshots are read-write, but generally 
used as read-only.  Does that include actually mounting them read-only?  
Because if not, and if they too are mounted the default relatime, 
accessing them is obviously going to be updating atimes the relatime-
default once per day there as well... triggering further divergence of 
snapshots from the subvolumes they are snapshots of and from each other...

> Is it likely the SSD?  If likely I could get a larger one, now is a good
> time with a new version of slackware imminent.  However, no point in
> spending money for the sake of it.

Not directly btrfs related, but when you do buy a new ssd, now or later, 
keep in mind that a lot of authorities recommend that for ssds you buy 
10-33% larger than you plan on actually provisioning, and that you leave 
that extra space entirely unprovisioned -- either leave that extra space 
entirely unpartitioned, or partition it, but don't put filesystems or 
anything else (swap, etc) on it.  This leaves those erase-blocks free to 
be used by the FTL for additional wear-leveling block-swap, thus helping 
maintain device speed as it ages, and with good wear-leveling firmware, 
should dramatically increase device usable lifetime, as well.

FWIW, I ended up going rather overboard with that here, as I knew I 
needed a bit under 128 GiB (1024, I was trying to fit it in 100 GiB, so I 
could get 120 or 128 GB (1000) and use the extra as slack, but that was 
going to be tighter than I actually wanted) and thus thought I'd get 140 
GB (1000) or so devices, but I ended up getting 256 GB (1000), as that's 
what was both in-stock and at a reasonable price and performance level.  
Of course that meant I spent somewhat more, but I put it on credit and 
paid it off in 2-3 months, before the interest ate up _all_ the price 
savings I got on it.  So I ended up being able to put a couple more 
partitions on the SSD that I had planned to keep on spinning rust, and 
_still_ was only to 130 GiB or so, so I was still close to only 50% 
actually partitioned and used.

But it has been nice since I basically don't need to worry about trim/
discard at all, tho I do have a cronjob setup to run fstrim every week or 
so.  And given the price on the 256 GB ssds, I actually didn't spend 
_that_ much more on them than I would have on 160 GB or 200 GB devices -- 
well either that or I'd have had to wait for them to get more in stock, 
since all the good-price/performance devices were out of stock in the 
120-200 GB range.

> All snapshots read-write.  However, I have mainly treated them as
> read-only. Does that make a difference?

See above.  It definitely will if you're not using noatime when mounting 
them.

>>Apropos Nada: quick shout out to Qu to wish him luck for the 4.6 merge.
> 
> I'm wondering if it is time for an update from 4.0.4?

The going list recommendation is to choose either current kernel track or 
LTS kernel track.  If you choose current kernel, the recommendation is to 
stick within 1-2 kernel cycles of newest current, which with 4.5 about to 
come out, means you would be on 4.3 at the oldest, and be looking at 4.4 
by now, again, on the current kernel track.

If you choose LTS kernels, until recently, the recommendation was again 
the latest two, but here LTS kernel cycles.  That would be 4.4 as the 
newest LTS and 4.1 previous to that.  However, 3.18, the LTS kernel 
previous to 4.1, has been holding up reasonably well, so while 4.1 would 
be preferred, 3.18 remains reasonably well supported as well.

You're on 4.0, which isn't an LTS kernel series and is thus, along with 
4.2, out of upstream's support window.  So it's past time to look at 
updating. =:^)  Given that you obviously do _not_ follow the last couple 
current kernels rule, I'd strongly recommend that you consider switching 
to an LTS kernel, and given that you're on 4.0 now, the 4.1 or 4.4 LTS 
kernels would be your best candidates.  4.1 should be supported for quite 
some time yet, both btrfs-wise and in general, and would be the minimal 
incremental upgrade, but of course if your object is to upgrade as far as 
you reasonably can when you /do/ upgrade, 4.4, the latest LTS, is perhaps 
your best candidate.

In normal operation, the btrfs-progs userspace version isn't as critical, 
as long as it has support for the features you're using, of course, 
because for most normal runtime tasks, all progs does is make the 
appropriate calls to the kernel to do the real work anyway.  But as soon 
as you find yourself trying to fix a filesystem that isn't working 
properly and possibly won't mount, btrfs-progs version becomes more 
critical, as the newest versions can fix more bugs than older versions, 
which didn't know about the bugs discovered since then.

As a result, a reasonable userspace rule of thumb is to use at _least_ a 
version corresponding to your kernel.  Newer is fine as well, but using 
at _least_ a version corresponding to your kernel means you're running a 
userspace that was developed with that kernel in mind, and also, as long 
as you're following kernel recommendations already, nicely keeps your 
userspace from getting /too/ outdated, to the point that the commands and 
output are enough different from current userspace to create problems 
when you post command output to the list, etc.

>>[Also, damn you autocorrection on my phone!]
> 
> Yep!

I'm one of those folks who still doesn't have a cell phone -- tho I have 
a VoIP adaptor hooked up to my internet, and and a cordless phone 
attached to it (and pay... about $30/year to a VoIP phone service for a 
phone number and US-domestic dialing without additional fees... tho 
obviously I have to keep an internet connection to keep that working, but 
that's why I don't have a cell, at the pitifully small full-speed data 
limits, I can't switch to cell for data, and it's simply not cost 
effective for voice when I can get full US phone coverage at no 
additional cost for what amounts to $2.50/mo.).

But FWIW, if you've not already discovered it, plug in phone autocorrect 
on youtube some day when you have some time, and be prepared to spend a 
few hours laughing your *** off!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

