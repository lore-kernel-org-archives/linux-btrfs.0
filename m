From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
Date: Mon, 8 Nov 2010 09:58:09 -0500
Message-ID: <20101108145809.GD29714@redhat.com>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
 <4CD6B7FA.3050005@redhat.com>
 <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>
 <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
 <20101107194547.GA12521@basil.fritz.box>
 <4CD71C8B.1050604@redhat.com>
 <20101107230508.GB17592@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, dm-devel@redhat.com,
	Milan Broz <mbroz@redhat.com>, Matt <jackdachef@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd@fancy-poultry.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20101107230508.GB17592@basil.fritz.box>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 07 2010 at  6:05pm -0500,
Andi Kleen <andi@firstfloor.org> wrote:

> On Sun, Nov 07, 2010 at 10:39:23PM +0100, Milan Broz wrote:
> > On 11/07/2010 08:45 PM, Andi Kleen wrote:
> > >> I read about barrier-problems and data getting to the partition when
> > >> using dm-crypt and several layers so I don't know if that could be
> > >> related
> > > 
> > > Barriers seem to be totally broken on dm-crypt currently.
> > 
> > Can you explain it?
> 
> e.g. the btrfs mailing list is full of corruption reports
> on dm-crypt and most of the symptoms point to broken barriers.

[cc'ing linux-btrfs, hopefully in the future dm-devel will get cc'd when
concerns about DM come up on linux-btrfs (or other lists)]

I spoke with Josef Bacik and these corruption reports are apparently
against older kernels (e.g. <= 2.6.33).  I say <= 2.6.33 because:

https://btrfs.wiki.kernel.org/index.php/Gotchas states:
"btrfs volumes on top of dm-crypt block devices (and possibly LVM)
require write-caching to be turned off on the underlying HDD. Failing to
do so, in the event of a power failure, may result in corruption not yet
handled by btrfs code. (2.6.33)"

But Josef was not aware of any reports with kernels newer than 2.6.32
(F12).

Josef also noted that until last week btrfs wouldn't retry another
mirror in the face of some corruption, the fix is here:
http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-unstable.git;a=commit;h=cb44921a09221

This obviously doesn't fix any source of corruption but it makes btrfs
more resilient when it encounters the corruption.

> > Barriers/flush change should work, if it is broken, it is not only dm-crypt.
> > (dm-crypt simply relies on dm-core implementation, when barrier/flush
> > request come to dmcrypt, all previous IO must be already finished).
> 
> Possibly, at least it doesn't seem to work.

Can you please be more specific?  What test(s)?  What kernel(s)?

Any pointers to previous (and preferably: recent) reports would be
appreciated.

The DM barrier code has seen considerable change recently (via flush+fua
changes in 2.6.37).  Those changes have been tested quite a bit
(including ext4 consistency after a crash).

But even prior to those flush+fua changes DM's support for barriers
(Linux >= 2.6.31) was held to be robust.  No known (at least no
reported) issues with DM's barrier support.

Mike
