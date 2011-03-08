From: Alexey A Nikitin <moonwalker@syrius.us>
Subject: Re: BTRFS fsck tool
Date: Mon, 7 Mar 2011 22:52:44 -0600
Message-ID: <AANLkTimaX2K=Uf-HZ7+dWN20Qt7Xntj+NoRiC7xN770=@mail.gmail.com>
References: <AANLkTim1+n4OJcm1iYMQKQZyN9jT2uFUYjAM6=x4pY2g@mail.gmail.com> <4D7591CC.6060301@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Spelic <spelic@shiftmail.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D7591CC.6060301@shiftmail.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011/3/7 Spelic <spelic@shiftmail.org>
>
> On 03/05/2011 12:59 AM, Alexey A Nikitin wrote:
> > Hi, everybody
> >
> > I have BTRFS RAID0 setup with two disks. After some incident where I
> > had to force shutdown machine this array won't mount anymore
>
>
> Have you "reset" the machine or cut the power?

4s power button.

> is this your scenario? If you leave the power and stop submitting writes
> to the disks (like with a reset) the filesystem should be preserved, if
> that sentence is true.
> Did you cut the power while there was some process writing to it? If the
> kernel was panicked it is probably safe to cut the power (because the
> last write happened long time ago and disks had time to put that to the
> platters)

Disks were idle. Kernel didn't panic, machine lost network and that
old laptop has weird glitch that if you start it with closed lid
screen will never come back on later on unless you restart it. Since I
have no external monitor and at the time magic SysRq was disabled I
had no other option but to force shutdown it and then start it up
again. All of the btrfs partitions on internal drive are perfectly
fine.

> Also what disks brand/model do you have? The sentence speaks about disks
> which don't honour flush+FUA requests, I think. Enterprise disks should
> honour that, consumer disks might not.

Disks in question are two plain consumer grade Samsung 2TB SATA disks
in external USB 2.0/eSATA enclosures with independent power supplies,
connected through USB 2.0 due to lack of eSATA support in that old
laptop that works as my home server.

> I am interesed in what happened because I am evaluating using btrfs for
> very large backups (still losing those wouldn't be totally nice)

If it is just a backup I wouldn't bother with performance and features
if I were you and would go instead with most tested and reliable
system that still provides the bare minimum of absolutely must
features. While the snapshots feature is a nice thing to have, IMHO
it's not exactly for stash-away backups. I'd go instead with ext3 or
XFS, depending on the size of files and overall size of backups. The
only reason why I went experimenting with btrfs RAID0 on my USB setup
is because I'm a reckless experimenter when it doesn't involve
production systems.


Best,

Alexey

--
This message was created with 100% recycled electrons
