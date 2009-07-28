From: Chris Mason <chris.mason@oracle.com>
Subject: Re: First impression (pure user)
Date: Tue, 28 Jul 2009 07:22:18 -0400
Message-ID: <20090728112218.GC3667@think>
References: <200907241237.18071@fortytwo.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Adrian von Bidder <avbidder@fortytwo.ch>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200907241237.18071@fortytwo.ch>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 24, 2009 at 12:37:13PM +0200, Adrian von Bidder wrote:
> Heyho!
> 
> Just a first impression report from a pure user.  I've started to play 
> around with btrfs a bit, without using any btrfs-specific features so far, 
> though.

Hi, thanks for sending this along.

> 
> 700G, ca. 1/2 full, tons of small files, lots of hardlinks ("dirvish" backup 
> trees of my workstations at home.)
> 
> The disk is currently attached to a very old machine that serves as home 
> server/router, so only 128M RAM and very slow CPU (350MHz PentiumII.)  And 
> only USB 1, no less, which I didn't realize when I bought the disk :-)  
> Since dirvish only writes new files, I can live with it for now.
> 
> Software: Debian packages, btrfs-tools 0.19 and kernel 2.6.31-rc1 (soon to 
> be rc3)
> 
> btrfs-convert (using my desktop, which is more or less ok performance-wise, 
> not the old machine): still took ca. 10h.

The btrfs-convert speeds are mostly limited by the speed that you can
read the ext3 metadata and data.  If you do the conversion without doing
csums, it is faster because it doesn't have to read the ext3 data.

>  * some progress indication would be nice (needn't be very accurate, but it 
> would be nice if it could tell me if I'm about to wait another hour or 
> another day...)

Definitely.

>  * documentation: what happens when I kill btrfs-convert?  Will I have an 
> ext3 with only free space having been written to, or will I have an 
> unfinished btrfs that I need to rollback with btrfs-convert?  Documentation 
> would be nice.  (I haven't tried what happens.)

You'll have one or the other, but not something halfway between.
> 
> Ok, now I have a btrfs, attached it to the old router.
> 
> I'm now collecting data if the slow CPU or the slow USB is worse by 
> enabling/disabling -o compress on the mount (will metadata be compressed as 
> well?)

Only data is compressed.

> 
> Since it basically worked: now tried to delete the image file in the 
> ext2_saved subvolume, which exposed very unexpected behaviour:  it takes 
> ages (ok, we're still on USB1 and the file is huge, after all) and then it 
> kicks the oom killer into action; the system then becomes unusable.  Plenty 
> of swapspace free, so I guess "rm" uses quite a bit kernel memory.  The 
> backtraces I've seen all are just about tasks the OOM killer got rid of, 
> nothing into the btrfs code.

Ouch, I haven't seen this but I'll try to reproduce it.

> 
> On a faster machine with more memory and USB2, removing the image file 
> worked, but I was still surprised at how long it took.  Quite some time was 
> spent with vmstat reporting only 1-4M/s reads (dd manages ~20M/s to that 
> disk, full USB2); I can't tell if it was seeking wildly or if it was CPU 
> (sorry, didn't think to watch.)
> 
> After, it seems the free space isn't tracked properly, the removed image 
> file should have freed up lots of space but no increase in free space is 
> reported by df.

The free space won't show up immediately, it takes a full commit before
you'll see it (run sync).  The conversion reuses all of the ext3 data
blocks, so the only free space you get back is the ext3 metadata. 
> 
> Ok, after all those crashes, I'll now run btrfsck just to be safe. (I 
> haven't so far, given that it'll take ages...)
> 
> Again, progress indication would be nice.
> 
> And: I notice that btrfsck /dev/sda1 doesn't complain even if the device is 
> currently mounted.  Is online fsck already implemented?  Or will fsck run 
> just in readonly mode?  A warning would be appropriate.

Yes, we do need a warning ;)

> 
> Ok, enough complaints.  I'm amazed at what you guys are doing, and await 
> eagerly the moment where I can switch my compuers to btrfs fully (ENOSPC 
> handling and the ability to remove snapshots/subvolumes are the critical 
> bits for me, and of course it shouldn't eat data.  Then creating snapshots 
> before "aptitude upgrade" orgies will make trying out new stuff so much 
> more fun!

Thanks for trying things out and writing up your experience.

> Btw, will it be possible to designate a new snapshot 
> the "default" snapshot and remove the old default?  Not critical, though.)

Yes.

-chris

