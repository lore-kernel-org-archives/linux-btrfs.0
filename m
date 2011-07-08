From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Memory leak?
Date: Fri, 08 Jul 2011 11:06:08 -0400
Message-ID: <1310137241-sup-8158@shiny>
References: <20110703190913.GA4474@yahoo.fr> <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com> <20110706081111.GA6931@yahoo.fr> <20110708124429.GB4284@yahoo.fr>
Content-Type: text/plain; charset=UTF-8
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110708124429.GB4284@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Stephane Chazelas's message of 2011-07-08 08:44:29 -0400:
> 2011-07-06 09:11:11 +0100, Stephane Chazelas:
> > 2011-07-03 13:38:57 -0600, cwillu:
> > > On Sun, Jul 3, 2011 at 1:09 PM, Stephane Chazelas
> > > <stephane_chazelas@yahoo.fr> wrote:
> > [...]
> > > > Now, on a few occasions (actually, most of the time), when I
> > > > rsynced the data (about 2.5TB) onto the external drive, the
> > > > system would crash after some time with "Out of memory and no
> > > > killable process". Basically, something in kernel was allocating
> > > > the whole memory, then oom mass killed everybody and crash.
> > [...]
> > > Look at the output of slabtop (should be installed by default, procfs
> > > package), before rsync for comparison, and during.
> > 
> > Hi,
> > 
> > so, no crash this time
> [...]
> 
> Another attempt, again onto an empty drive, this time with
> 3.0.0-rc6. Exact same scenario.
> 
> slabinfo:

> Got another "invalid opcode" in btrfs-fixup-0. That was in the
> middle of transfering a 3.6GB file. I've got one and only one of
> those during one boot time when doing that rsync.

So the invalidate opcode in btrfs-fixup-0 is the big problem.  We're
either failing to write because we weren't able to allocate memory (and
not dealing with it properly) or there is a bigger problem.

Does the btrfs-fixup-0 oops come before or after the ooms?

Please send along any oops output during the run.  Only the first
(earliest) oops matters.

I would do two things.  First, I'd turn off compress_force.  There's no
explicit reason for this, it just seems like the mostly likely place for
a bug.

If the oops comes after the oom messages, please grab a sysrq-t and
sysrq-w output (you'll need some way to log the console if you do this).
What we really need to see is what kswapd is doing.  That's usually
where the inodes get freed.

-chris
