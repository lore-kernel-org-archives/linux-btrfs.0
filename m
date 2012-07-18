Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:38355 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab2GRVti convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 17:49:38 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: brtfs on top of dmcrypt with SSD -> Trim or no Trim
Date: Wed, 18 Jul 2012 23:49:36 +0200
Cc: Marc MERLIN <marc@merlins.org>, Chris Mason <chris.mason@oracle.com>,
        mbroz@redhat.com, Calvin Walton <calvin.walton@kepstin.ca>,
        jeff@deserettechnology.com
References: <20120202124241.GW16796@shiny> <20120130003754.GD4380@merlins.org> <20120718181316.GD16899@merlins.org> (sfid-20120718_202113_607986_DAB11319)
In-Reply-To: <20120718181316.GD16899@merlins.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201207182349.36798.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 18. Juli 2012 schrieb Marc MERLIN:
> On Sat, Feb 18, 2012 at 08:07:02AM -0800, Marc MERLIN wrote:
> > On Sat, Feb 18, 2012 at 01:39:24PM +0100, Martin Steigerwald wrote:
> > > To Milan Broz: Well now I noticed that you linked to your own blog
> > > entry.
> > 
> > He did not, I'm the one who did.
> > I asked a bunch of questions since the online docs didn't address
> > them for me. Some of you answered those for me, I asked access to
> > the wiki and I updated the wiki to have the information you gave me.
> > 
> > While I have no inherent bias one way or another, obviously I did put
> > some of your opinions on the wiki :)
> > 
> > > Please do not take my below statements personally - I might have
> > > written them a bit harshly. Actually I do not really know whether
> > > your statement that TRIM is overrated is correct, but before
> > > believing that TRIM does not give much advantage, I would like to
> > > see at least some evidence of any sort, cause for me my
> > > explaination below that it should make a difference at least seems
> > > logical to me.
> > 
> > That sounds like a reasonable request to me.
> > 
> > In the meantime I changed the page to
> > 'Does Btrfs support TRIM/discard?
> > 
> > "-o discard" is supported, but can have some negative consequences on
> > performance on some SSDs or at least whether it adds worthwhile
> > performance is up for debate depending on who you ask, and makes
> > undeletion/recovery near impossible while being a security problem
> > if you use dm-crypt underneath (see
> > http://asalor.blogspot.com/2011/08/trim-dm-crypt-problems.html ),
> > therefore it is not enabled by default. You are welcome to run your
> > own benchmarks and post them here, with the caveat that they'll be
> > very SSD firmware specific.'
> > 
> > I'll leave further edits to others ;)
> 
> TL;DR:
> I'm going to change the FAQ to say people should use TRIM with dmcrypt
> because not doing so definitely causes some lesser SSDs to suck, or
> possibly even fail and lose our data.

I can´t comment on dm-crypt since I do not use it.

I am still not convinced that dm-crypt is the best way to go about 
encryption especially for SSDs. But its more of a gut feeling than 
anything that I can explain easily.

I use ecryptfs, formerly encfs, but encfs is much slower. The advantage 
for me is that I can backup my data without decrypting and reencrypting it 
just with rsync as long as I exclude the uncrypted view on the data. I 
also always thought not being block device based would be an advantage 
too, but I am not so sure about it anymore.

Disadvantage would be some information leakage like amount of file and 
directory layout and approximate sizes of files. And the need to handle the 
swap partition separately. What I do not even do right now.

> Longer version:
> Ok, so several months later I can report back with useful info.
> 
> Not using TRIM on my Crucial RealSSD C300 256GB is most likely what
> caused its garbage collection algorithm to fail (killing the drive and
> all its data), and it was also causing BRTFS to hang badly when I was
> getting within 10GB of the drive getting full.

How did you know that it was its garbage collection algorithm?

> I reported some problems I had with btrfs being very slow and hanging
> when I only had 10GB free, and I'm now convinced that it was the SSD
> that was at fault.
> 
> On the Crucial RealSSD C300 256GB, and from talking to their tech
> support and other folks who happened to have gotten that 'drive' at
> work and also got weird unexplained failures, I'm convinced that even
> its latest 007 firmware (the firmware it shipped with would just hang
> the system for a few seconds every so often so I did upgrade to 007
> early on), the drive does very poorly without TRIM when it's getting
> close to full.
> In my case, I hit a bug that is likely firmware and caused the drive to
> die (not show up on the bus anymore). I went through special reset,
> power on but don't talk to it procedures that eventually brought the
> drive back after 4 hours of trying, except the drive is now 'blank',
> all the partitions and data are gone as far as the controller is
> concerned.
> (yes, I had backups, thanks for asking :) ).
> 
> From talking to their techs and other folks, it seems clear that TRIM
> is greatly encouraged, and I'm pretty sure that had I used TRIM, I
> would not have hit the problems that caused my drive to fail and suck
> so much when it was getting full.

I still think that telling the SSD about free space is helping it to 
balance its wear leveling process.

Say I have a 10 GB file that I newer ever touch again. The SSD firmware will 
likely begin to move it around to blocks with more write accesses in order 
to use that blocks that have once be written to for further writes. For 
that wear leveling its beneficial if the SSD has free blocks to move stuff 
to. The more the better it seems to me. Cause if it only has little free 
space it possibly has to do more moving around to equally distribute write 
accesses.

> Now, I still think that the Crucial RealSSD C300 256GB has poor
> firmware compared to some of its competition and there is no excuse
> for it just dying like that, but I'm going to change the FAQ to
> recommend that people do use TRIM if they can, even if they use
> dm-crypt (assuming their kernel is at least 3.2.0).
> 
> Any objections and/or comments?

I still only use fstrim from time to time. About once a week or after lots 
of drive churning or removing lots of data. I also have a logical volume 
of about 20 GiB that I keep free for most of the time. And other filesystem 
are quite full, but there is also some little free space of about 20-30 
GiB together. So it should be about 40-50 GiB free most of the time.

The 300 GB Intel SSD 320 in this ThinkPad T520 is still fine after about 1 
year and 2-3 months. I do not see any performance degradation whatsover so 
far. Last time I looked also SMART data looked fine, but I have not much 
experience with SMART on SSDs so far.

Regards,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
