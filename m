From: Mike Snitzer <snitzer@redhat.com>
Subject: dm-crypt barrier support is effective (was: Re: DM-CRYPT: Scale to
 multiple CPUs v3 on 2.6.37-rc* ?)
Date: Sun, 14 Nov 2010 15:59:26 -0500
Message-ID: <20101114205925.GA20451@redhat.com>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
 <4CD6B7FA.3050005@redhat.com>
 <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>
 <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
 <20101107194547.GA12521@basil.fritz.box>
 <4CD71C8B.1050604@redhat.com>
 <20101107230508.GB17592@basil.fritz.box>
 <20101108145809.GD29714@redhat.com>
 <1289238930-sup-9765@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	dm-devel <dm-devel@redhat.com>, Milan Broz <mbroz@redhat.com>,
	Matt <jackdachef@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	htd <htd@fancy-poultry.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1289238930-sup-9765@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 08 2010 at 12:59pm -0500,
Chris Mason <chris.mason@oracle.com> wrote:

> Excerpts from Mike Snitzer's message of 2010-11-08 09:58:09 -0500:
> > On Sun, Nov 07 2010 at  6:05pm -0500,
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > On Sun, Nov 07, 2010 at 10:39:23PM +0100, Milan Broz wrote:
> > > > On 11/07/2010 08:45 PM, Andi Kleen wrote:
> > > > >> I read about barrier-problems and data getting to the partition when
> > > > >> using dm-crypt and several layers so I don't know if that could be
> > > > >> related
> > > > > 
> > > > > Barriers seem to be totally broken on dm-crypt currently.
> > > > 
> > > > Can you explain it?
> > > 
> > > e.g. the btrfs mailing list is full of corruption reports
> > > on dm-crypt and most of the symptoms point to broken barriers.
> > 
> > [cc'ing linux-btrfs, hopefully in the future dm-devel will get cc'd when
> > concerns about DM come up on linux-btrfs (or other lists)]
> > 
> > I spoke with Josef Bacik and these corruption reports are apparently
> > against older kernels (e.g. <= 2.6.33).  I say <= 2.6.33 because:
> 
> We've consistently seen reports about corruptions on power hits with
> dm-crypt.  The logs didn't have any messages about barriers failing, but
> the corruptions were still there.  The most likely cause is that
> barriers just aren't getting through somehow.

Can't blame anyone for assuming as much (although it does create FUD)
but in practice (testing dm-crypt with ext4 using your barrier-test
script) I have not been able to see any evidence that dm-crypt's barrier
support is ineffective.

Could be that the barrier-test script isn't able to reproduce the unique
failure case that btrfs does (on power failure)?

> > > > Barriers/flush change should work, if it is broken, it is not only dm-crypt.
> > > > (dm-crypt simply relies on dm-core implementation, when barrier/flush
> > > > request come to dmcrypt, all previous IO must be already finished).
> > > 
> > > Possibly, at least it doesn't seem to work.
> > 
> > Can you please be more specific?  What test(s)?  What kernel(s)?
> > 
> > Any pointers to previous (and preferably: recent) reports would be
> > appreciated.

I still think we need specific bug reports that detail workloads and if
possible reproducers.

> > The DM barrier code has seen considerable change recently (via flush+fua
> > changes in 2.6.37).  Those changes have been tested quite a bit
> > (including ext4 consistency after a crash).
> > 
> > But even prior to those flush+fua changes DM's support for barriers
> > (Linux >= 2.6.31) was held to be robust.  No known (at least no
> > reported) issues with DM's barrier support.
> 
> I think it would be best to move forward with just hammering on the
> dm-crypt barriers:
> 
> http://oss.oracle.com/~mason/barrier-test
> 
> This script is the best I've found so far to reliably trigger
> corruptions with barriers off.  I'd start with ext3 + barriers off just
> to prove it corrupts things, then move to ext3 + barriers on.

I started with ext4 + barrier=0,journal_async_commit and could reliably
cause directory corruption (~75% of the time).  I then switched to
barrier=1 and could not cause corruption.

I then added dm-crypt and got the same results: with barrier=1 I could
not cause directory corruption.  barrier=0 resulted in directory
corruption (again ~75% of the time), no corruption occurred with
barrier=1.

Both 2.6.36 (original barrier code) and latest 2.6.37-rc1+ (new
flush+fua code) were tested.  6 iterations of barrier=0 and 10
iterations of barrier=1.

So my hope is we can now put this general dm-crypt barrier doubt to one
side and work together on identifying the cause of corruption when
dm-crypt is paired with btrfs.

Thanks,
Mike
