From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: write(2) taking 4s
Date: Tue, 19 Jul 2011 10:32:52 +0100
Message-ID: <20110719093252.GA24559@yahoo.fr>
References: <20110709170959.GC4294@yahoo.fr>
 <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com>
 <20110709203649.GE4294@yahoo.fr>
 <1310301809-sup-9903@shiny>
 <20110710183728.GB4277@yahoo.fr>
 <20110711090121.GA2537@yahoo.fr>
 <20110716121210.GA5638@yahoo.fr>
 <20110717091737.GA4301@yahoo.fr>
 <chaz20110718103912.GA4014@seebyte.com>
 <20110718193725.GA6298@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110718193725.GA6298@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-18 20:37:25 +0100, Stephane Chazelas:
> 2011-07-18 11:39:12 +0100, Stephane Chazelas:
> > 2011-07-17 10:17:37 +0100, Stephane Chazelas:
> > > 2011-07-16 13:12:10 +0100, Stephane Chazelas:
> > > > Still on my btrfs-based backup system. I still see one BUG()
> > > > reached in btrfs-fixup per boot time, no memory exhaustion
> > > > anymore. There is now however something new: write performance
> > > > is down to a few bytes per second.
> > > [...]
> > > 
> > > The condition that was causing that seems to have cleared by
> > > itself this morning before 4am.
> > > 
> > > flush-btrfs-1 and sync are still in D state.
> > > 
> > > Can't really tell what cleared it. Could be when the first of
> > > the rsyncs ended as all the other ones (and ntfsclones from nbd
> > > devices) ended soon after
> > [...]
> > 
> > New nightly backup, and it's happening again. Started about 40
> > minutes after the start of the backup.
> [...]
> > Actively  running at the moment are 1 rsync and 3 ntfsclone.
> [...]
> 
> And then again today.
> 
> Interestingly, I "killall -STOP"ed all the ntfsclone and rsync
> processes and:
[...]
> Now 95% of the write(2)s take 4 seconds (while it was about 15%
> before I stopped the processes).
[...]

And this morning, after killing everything so that nothing was
writing to the FS anymore, 95% of write(2)s were delayed as well
(according to strace -Te write yes > file-on-btrfs).

Then I rebooted (sysrq-b) and am trying btrfsck (from
integration-20110705) on it, but btrfsck is using 8G of memory
on a system that has only 5G so it's swapping in and out
constantly and getting nowhere (and renders the system hardly usable)

I found
http://thread.gmane.org/gmane.comp.file-systems.btrfs/5716/focus=5728
from last year. Is that still the case?

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 1950 root      20   0 7684m 4.4g  232 R    4 91.1   4:22.87 btrfsck
(and still growing)

 vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 2  2 3232016 115232   4524   3520  698  708  3305   716  991  570  3  1 56 39
 0  2 3231816 111536   5976   3428 2964  532  4912   532 1569  683  1  0 46 53
 0  2 3231144 105832   8144   3536 3140   24  5324    24 1612  392  1  1 38 60
 0  2 3231532 104964   8180   3684 2672  900  2708   900 1017  324  1  1 34 64

-- 
Stephane
