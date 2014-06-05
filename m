Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46742 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaFEEpV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 5 Jun 2014 00:45:21 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WsPYF-0001Ff-9c
	for linux-btrfs@vger.kernel.org; Thu, 05 Jun 2014 06:45:19 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 06:45:19 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 05 Jun 2014 06:45:19 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Very slow filesystem
Date: Thu, 5 Jun 2014 04:45:07 +0000 (UTC)
Message-ID: <pan$66344$1e737ea5$54405fe6$fc9c8098@cox.net>
References: <CAEezp7uMXA3t8-GDVcVzx9An+hPBZmynYZ-wUXzhJuP93czs1w@mail.gmail.com>
	<pan$765af$b28af9a8$903ce16b$940baf34@cox.net>
	<CAG1y0seEWf0RqDuJgG3Jx9iz-yPLh8piQ00dMAQ9aPLeCEp3vA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fajar A. Nugraha posted on Thu, 05 Jun 2014 10:22:49 +0700 as excerpted:

> (resending to the list as plain text, the original reply was rejected
> due to HTML format)
> 
> On Thu, Jun 5, 2014 at 10:05 AM, Duncan <1i5t5.duncan@cox.net> wrote:
>>
>> Igor M posted on Thu, 05 Jun 2014 00:15:31 +0200 as excerpted:
>>
>> > Why btrfs becames EXTREMELY slow after some time (months) of usage ?
>> > This is now happened second time, first time I though it was hard
>> > drive fault, but now drive seems ok.
>> > Filesystem is mounted with compress-force=lzo and is used for MySQL
>> > databases, files are mostly big 2G-8G.
>>
>> That's the problem right there, database access pattern on files over 1
>> GiB in size, but the problem along with the fix has been repeated over
>> and over and over and over... again on this list, and it's covered on
>> the btrfs wiki as well
> 
> Which part on the wiki? It's not on
> https://btrfs.wiki.kernel.org/index.php/FAQ or
> https://btrfs.wiki.kernel.org/index.php/UseCases

Most of the discussion and information is on the list, but there's a 
limited amount of information on the wiki in at least three places.  Two 
are on the mount options page, in the autodefrag and nodatacow options 
description:

* Autodefrag says it's well suited to bdb and sqlite dbs but not vm 
images or big dbs (yet).

* Nodatacow says performance gain is usually under 5% *UNLESS* the 
workload is random writes to large db files, where the difference can be 
VERY large.  (There's also mention of the fact that this turns off 
checksumming and compression.)

Of course that's the nodatacow mount option, not the NOCOW file 
attribute, which isn't to my knowledge discussed on the wiki, and given 
the wiki wording, one does indeed have to read a bit between the lines, 
but it is there if one looks.  That was certainly enough hint for me to 
mark the issue for further study as I did my initial pre-mkfs.btrfs 
research, for instance, and that it was a problem, with additional 
detail, was quickly confirmed once I checked the list.

* Additionally, there some discussion in the FAQ under "Can copy-on-write 
be turned off for data blocks?", including discussion of the command used 
(chattr +C), a link to a script, a shell commands example, and the hint 
"will produce file suitable for a raw VM image -- the blocks will be 
updated in-place and are preallocated."


FWIW, if I did wiki editing there'd probably be a dedicated page 
discussing it, but for better or worse, I seem to work best on mailing 
lists and newsgroups, and every time I've tried contributing on the web, 
even when it has been to a web forum which one would think would be close 
enough to lists/groups for me to adapt to, it simply hasn't gone much of 
anywhere.  So these days I let other people more comfortable with editing 
wikis or doing web forums do that (and sometimes people do that by either 
actually quoting my list post nearly verbatim or simply linking to it, 
which I'm fine with, as after all that's where much of the info I post 
comes from in the first place), and I stick to the lists.  Since I don't 
directly contribute to the wiki I don't much criticize it, but there are 
indeed at least hints there for those who can read them, something I did 
myself so I know it's not asking the impossible.

> If COW and rewrite is the main issue, why don't zfs experience the
> extreme slowdown (that is, not if you have sufficient free space
> available, like 20% or so)?

My personal opinion?  Primarily two things:

1) zfs is far more mature than btrfs and has been in production usage for 
many years now, while btrfs is still barely getting the huge warnings 
stripped off.  There's a lot of btrfs optimization possible that simply 
hasn't occurred yet as the focus is still real data-destruction-risk 
bugs, and in fact, btrfs isn't yet feature-complete either, so there's 
still focus on raw feature development as well.  When btrfs gets to the 
maturity level that zfs is at now, I expect a lot of the problems we have 
now will have been dramatically reduced if not eliminated.  (And the devs 
are indeed working on this problem, among others.)

2) Stating the obvious, while both btrfs and zfs are COW based and have 
other similarities, btrfs is an different filesystem, with an entirely 
different implementation and somewhat different emphasis.  There 
consequently WILL be some differences, even when they're both mature 
filesystems.  It's entirely possible that something about the btrfs 
implementation makes it less suitable in general to this particular use-
case.

Additionally, while I don't have zfs experience myself nor do I find it a 
particularly feasible option for me due to licensing and political 
issues, from what I've read it tends to handle certain issues by simply 
throwing gigs on gigs of memory at the problem.  Btrfs is designed to 
require far less memory, and as such, will by definition be somewhat more 
limited in spots.  (Arguably, this is simply a specific case of #2 above, 
they're individual filesystems with differing implementation and 
emphasis, so WILL by definition have different ideal use-cases.)

Meanwhile, there's that specific mention of 20% zfs free-space available, 
above.  On btrfs, as long as some amount of chunk-space remains 
unallocated to chunks, percentage free-space has little to no effect on 
performance.  And with metadata chunk-sizes of a quarter gig and data 
chunk-sizes of a gig, at the terabyte filesystem scale that equates to 
well under 1% free, before free-space becomes a performance issue at all.

So if indeed zfs is like many other filesystems in requiring 10-20% 
freespace in ordered to perform at best efficiency (I really don't know 
if that's the case or not, but it is part of the claim above), then that 
again simply emphasizes the differences between zfs and btrfs, since that 
literally has zero bearing at all on btrfs efficiency.

Rather, at least until btrfs gets automatic entirely unattended 
chunkspace rebalance triggering the btrfs issue is far more likely to be 
literally running out of either data or metadata space as all the chunks 
with freespace are allocated to the other one.  (Usually, it's metadata 
that runs out first, with lots of free space tied up in nearly empty data 
chunks.  But it can be either.  Of course a currently manually triggered 
rebalance can be used to solve this problem, but at present, it IS 
manually triggered, no automatic rebalancing functionality at all.)

So while zfs and btrfs might be similarly based on COW technology, they 
really are entirely different filesystems, with vastly different maturity 
levels and some pretty big differences in behavior as well as licensing 
and political philosophy, certainly now, but potentially even as btrfs 
matures to match zfs maturity, too.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

