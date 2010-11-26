From: david grant <dg@david-grant.com>
Subject: Re: btrfs problems and fedora 14
Date: Fri, 26 Nov 2010 20:40:56 +1100
Message-ID: <1290764456.4380.20.camel@main-wireless>
References: <1290467983.24502.66.camel@main-wireless>
	 <AANLkTinuQU46BCL6WLM4hEc+ocXsbOGHoF3ppGbTOc8y@mail.gmail.com>
	 <AANLkTimkdtmjeO1Hzq5y1nL_ERNiJS1S0xn6Vu2_yyj=@mail.gmail.com>
	 <1290583953.2235.28.camel@main-wireless>
	 <AANLkTimhA5z8xB_t9bGCC4=jzezPhHTPzBPy=0PW9Kpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: C Anthony Risinger <anthony@extof.me>,
	Hugo Mills <hugo-lkml@carfax.org.uk>,
	Wenyi Liu <qingshenlwy@gmail.com>, linux-btrfs@vger.kernel.org
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimhA5z8xB_t9bGCC4=jzezPhHTPzBPy=0PW9Kpg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Thank you all for your help and in particular you cwillu (sounds
strangely formal!).

Yes, I can now boot into a snapshot but I thought it might be helpful to
explain why I thought otherwise.

I am totally anal about having backups of a current operating systems
and using those for testing I thought tat the best way to do this with
btrfs was to rsync the file system to another partition but exclude all
snapshots. This worked very well as long as I mounted only the root file
system of the copy but what I did was add snapshots to the copy and at
some point (probably at the start) the btree system was corrupted but I
only saw this on backtracking and checking all messages. Also, I didn't
want to boot from a snapshot of my working operating system for fear I
could screw things up and have to re-install from scratch.  In order to
try again, I deleted all snapshots from the original system, did an
rsync and checked the copy. I then made a snapshot of the copy via yum,
used rootflags and it worked!!

So, cwillu, after your scolding of me and your (perfectly reasonable)
questioning of my understanding, I did get it together for booting.

BUT I am still left with the problem that caused it for me: how do I
backup (clone?) a btrfs file system with snapshots to another btrfs
partition (apart from using dd). I just hope I don't get scolded again
and told I am not up to it.




On Wed, 2010-11-24 at 03:19 -0600, cwillu wrote: 
> On Wed, Nov 24, 2010 at 1:32 AM, david grant <dg@david-grant.com> wrote:
> > Hugo, you told me how to mount a snapshot. Thank you, that works but you
> > didn't tell me how to boot into it.
> 
> He also gave you the command to set the default subvolume/snapshot
> used if you don't provide one:  "btrfs subvolume set-default <id>
> <path>".  There's also a standard way to send mount options for the
> root filesystem, which would allow you to use the mount options he
> provided (which Anthony pointed out in his email).
> 
> > Anthony, I really hoped that you had provided the answer using grub but
> > all combinations of your suggestions result in a boot failure with
> > standard error message of unable to mount root because of of wrong fs
> > type etc. I assume that with your suggestion I need a standard fstab
> > entry with default options but it doesn't work even with subvol options.
> > I am always nervous of messing with the MBR so I want to stick with
> > grub.
> 
> He meant that you distribution uses an initial ram filesystem loaded
> into memory with necessary modules, placed in the same place as the
> kernel image that grub loads.  This is unrelated to the MBR.
> 
> > Perhaps this is a fedora problem but I have to say I find it very
> > strange that they tout btrfs as the future, particularly with respect to
> > rollbacks but provide no guide to doing this. I assume it is a
> > combination of grub boot parameters and fstab but nobody seems to know
> > what to do.
> 
> The future != the present.  Btrfs will make things like rollback easy
> to implement, but it's not implemented yet in useful way for an
> untechnical user.  The hard technical bits are over and done with by
> the time there are guides on the various forums about "how to do
> rollback with btrfs".
> 
> > I am not a techo so I just need simple instructions. Is there any other
> > site, I should be posting this on?
> 
> Not to belabour the point, but a more careful reading of what people
> told you would have gotten you up and running.  If those instructions
> were too technical, then you probably shouldn't be using btrfs yet:
> it's very much at a "some assembly required" stage, and if you don't
> understand how your system boots at a basic-but-technical level,
> you're either going to come away frustrated, or you're going to have
> to learn at least some "linux administrator 101".  :)
> 
> Understand what the commands people are giving you actually do, and
> you'll have this working in no time.
> 
> [sorry for sending this twice David, I consistently fail to hit "reply
> to all" when replying to mailing lists]  :(



