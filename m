From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: write(2) taking 4s
Date: Mon, 18 Jul 2011 20:37:25 +0100
Message-ID: <20110718193725.GA6298@yahoo.fr>
References: <1310137241-sup-8158@shiny>
 <20110709170959.GC4294@yahoo.fr>
 <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com>
 <20110709203649.GE4294@yahoo.fr>
 <1310301809-sup-9903@shiny>
 <20110710183728.GB4277@yahoo.fr>
 <20110711090121.GA2537@yahoo.fr>
 <20110716121210.GA5638@yahoo.fr>
 <20110717091737.GA4301@yahoo.fr>
 <chaz20110718103912.GA4014@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110718103912.GA4014@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-18 11:39:12 +0100, Stephane Chazelas:
> 2011-07-17 10:17:37 +0100, Stephane Chazelas:
> > 2011-07-16 13:12:10 +0100, Stephane Chazelas:
> > > Still on my btrfs-based backup system. I still see one BUG()
> > > reached in btrfs-fixup per boot time, no memory exhaustion
> > > anymore. There is now however something new: write performance
> > > is down to a few bytes per second.
> > [...]
> > 
> > The condition that was causing that seems to have cleared by
> > itself this morning before 4am.
> > 
> > flush-btrfs-1 and sync are still in D state.
> > 
> > Can't really tell what cleared it. Could be when the first of
> > the rsyncs ended as all the other ones (and ntfsclones from nbd
> > devices) ended soon after
> [...]
> 
> New nightly backup, and it's happening again. Started about 40
> minutes after the start of the backup.
[...]
> Actively  running at the moment are 1 rsync and 3 ntfsclone.
[...]

And then again today.

Interestingly, I "killall -STOP"ed all the ntfsclone and rsync
processes and:

# strace -tt -Te write yes > a-file-on-the-btrfs-fs
20:23:26.635848 write(1, "y\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\n"..., 4096) = 4096 <4.095223>
20:23:30.731391 write(1, "y\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\n"..., 4096) = 4096 <4.095769>
20:23:34.827390 write(1, "y\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\n"..., 4096) = 4096 <4.095788>
20:23:38.923388 write(1, "y\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\ny\n"..., 4096) = 4096 <4.095771>

Now 95% of the write(2)s take 4 seconds (while it was about 15%
before I stopped the processes).

[304257.760119] yes             S ffff88001e8e3780     0 13179  13178 0x00000001
[304257.760119]  ffff88001e8e3780 0000000000000086 0000000000000000 ffffffff8160b020
[304257.760119]  00000000000127c0 ffff880074543fd8 ffff880074543fd8 00000000000127c0
[304257.760119]  ffff88001e8e3780 ffff880074542010 0000000000000286 0000000100000286
[304257.760119] Call Trace:
[304257.760119]  [<ffffffff81339912>] ? schedule_timeout+0xa0/0xd7
[304257.760119]  [<ffffffff8105238c>] ? lock_timer_base+0x49/0x49
[304257.760119]  [<ffffffffa0162e7d>] ? shrink_delalloc+0x100/0x14e [btrfs]
[304257.760119]  [<ffffffffa0163d66>] ? btrfs_delalloc_reserve_metadata+0xf9/0x10b [btrfs]
[304257.760119]  [<ffffffffa0167aa8>] ? btrfs_delalloc_reserve_space+0x20/0x3e [btrfs]
[304257.760119]  [<ffffffffa0182540>] ? __btrfs_buffered_write+0x137/0x2dc [btrfs]
[304257.760119]  [<ffffffffa017ad0e>] ? btrfs_dirty_inode+0x119/0x139 [btrfs]
[304257.760119]  [<ffffffffa0182a7a>] ? btrfs_file_aio_write+0x395/0x42b [btrfs]
[304257.760119]  [<ffffffff8100866d>] ? __switch_to+0x19c/0x288
[304257.760119]  [<ffffffff810fee6d>] ? do_sync_write+0xb1/0xea
[304257.760119]  [<ffffffff81056522>] ? ptrace_notify+0x7f/0x9d
[304257.760119]  [<ffffffff811691ce>] ? security_file_permission+0x18/0x2d
[304257.760119]  [<ffffffff810ff7c4>] ? vfs_write+0xa4/0xff
[304257.760119]  [<ffffffff810116a7>] ? syscall_trace_enter+0xb6/0x15b
[304257.760119]  [<ffffffff810ff8d5>] ? sys_write+0x45/0x6e
[304257.760119]  [<ffffffff81340027>] ? tracesys+0xd9/0xde

After killall -CONT, it's back to 15% write(2)s delayed.

What's going on?

-- 
Stephane
