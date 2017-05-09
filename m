Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:43389 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751334AbdEIBtW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 May 2017 21:49:22 -0400
Date: Tue, 9 May 2017 03:49:12 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH ping] btrfs: warn about RAID5/6 being experimental at
 mount time
Message-ID: <20170509014912.kjc6tjwuw4l4kvyh@angband.pl>
References: <20170419210745.15263-1-kilobyte@angband.pl>
 <20170426021416.us4zj2blho26sjgc@angband.pl>
 <20170505194530.GP10575@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170505194530.GP10575@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 05, 2017 at 09:45:30PM +0200, David Sterba wrote:
> On Wed, Apr 26, 2017 at 04:14:16AM +0200, Adam Borowski wrote:
> > On Wed, Apr 19, 2017 at 11:07:45PM +0200, Adam Borowski wrote:
> > > Too many people come complaining about losing their data -- and indeed,
> > > there's no warning outside a wiki and the mailing list tribal knowledge.
> > > Message severity chosen for consistency with XFS -- "alert" makes dmesg
> > > produce nice red background which should get the point across.
> > ...
> > > I intend to ask for inclusion of this one (or an equivalent) in 4.9, either
> > > in Debian or via GregKH -- while for us kernels "that old" are history,
> > > regular users expect stable releases to be free of known serious data loss
> > > bugs.
> > 
> There are some raid56 fixes in 4.12, but IIRC the write hole is still
> unfixed so the warning is still valid even for 4.12. It would be easier
> to get the patch to 4.4 or 4.9 once it's in Linus tree.

I've taken pre-4.12 for a spin (mason/for-linus-4.12 atop of midway merge
window v4.11-10603-g13e098814037), and it indeed succeeds on a number of
tests I've thrown at it that 4.11 fails.  My tests were not exhaustive
(corruption at rest only, with no unclean shutdowns) but it looks good so
far.  So implementation bugs are getting ironed out; 4.9..4.11 had no
improvements but 4.12 is a nice step forward.

Still dies horribly on 32-bit.

Write hole is pretty nasty for metadata (likely to cause total filesystem
loss) but when on -draid{5,6} -mraid{1,10} it's nowhere as bad.  So for 4.12
it might be ok to put up big warnings only for metadata.  On the other hand,
data loss limited to 1-2 files is still data loss -- CoW is supposed to
never damage files already written.

A real fix is obviously better than slapping on warnings.

> > And here the severity is "critical -- causes serious data loss".

As for 4.9, though, the Debian release is coming very soon, and kernel
updates there require far more effort than the usual every 4-8 days GregKH
point release.  So I'd need to harass Ben Hutchings really soon (and
possibly it's already too late).

> > > +	if ((fs_info->avail_data_alloc_bits |
> > > +	     fs_info->avail_metadata_alloc_bits |
> > > +	     fs_info->avail_system_alloc_bits) &
> > > +	    BTRFS_BLOCK_GROUP_RAID56_MASK) {
> > > +		btrfs_alert(fs_info,
> > > +		"btrfs RAID5/6 is EXPERIMENTAL and has known data-loss bugs");

> > Doing this in the kernel should be better than in userspace (like
> > https://patchwork.kernel.org/patch/9450035/) as it can deal with a future
> > kernel with working RAID5/6 on old -progs; but if you prefer, I can finish
> > that patch and request its inclusion in Debian stretch -progs instead or in
> > addition to the above warning in the kernel.
> 
> I'll have look again.

I haven't addresses the concerns for the -progs patch -- at this moment
having you look there would be a waste of time.  So the question is: do you
want the warning to be in kernel (where it won't get out of sync), progs
(where it might be easier to notice) or both?


Meow!
-- 
Don't be racist.  White, amber or black, all beers should be judged based
solely on their merits.  Heck, even if occasionally a cider applies for a
beer's job, why not?
On the other hand, corpo lager is not a race.
