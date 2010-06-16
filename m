From: Daniel J Blueman <daniel.blueman@gmail.com>
Subject: Re: Confused by performance
Date: Wed, 16 Jun 2010 22:44:32 +0100
Message-ID: <AANLkTil5TqpPNlz17zah_oRX2P-tfIo3puR9SLXcLVG6@mail.gmail.com>
References: <4BFAEABD.2070700@noir.com>
	<4BFF2024.3040509@noir.com>
	<4C191330.5060905@noir.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "K. Richard Pixley" <rich@noir.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C191330.5060905@noir.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 16, 2010 at 7:08 PM, K. Richard Pixley <rich@noir.com> wrot=
e:
> Once again I'm stumped by some performance numbers and hoping for som=
e
> insight.
>
> Using an 8-core server, building in parallel, I'm building some code.=
 =A0Using
> ext2 over a 5-way, (5 disk), lvm partition, I can build that code in =
35
> minutes. =A0Tests with dd on the raw disk and lvm partitions show me =
that I'm
> getting near linear improvement from the raw stripe, even with dd run=
s
> exceeding 10G, so I think that convinces me that my disks and control=
ler
> subsystem are capable of operating in parallel and in concert. =A0hdp=
arm -t
> numbers seem to support what I'm seeing from dd.
>
> Running the same build, same parallelism, over a btrfs (defaults) par=
tition
> on a single drive, I'm seeing very consistent build times around an h=
our,
> which is reasonable. =A0I get a little under an hour on ext4 single d=
isk,
> again, very consistently.
>
> However, if I build a btrfs file system across the 5 disks, my build =
times
> decline to around 1.5 - 2hrs, although there's about a 30min variatio=
n
> between different runs.
>
> If I build a btrfs file system across the 5-way lvm stripe, I get eve=
n worse
> performance at around 2.5hrs per build, with about a 45min variation =
between
> runs.
>
> I can't explain these last two results. =A0Any theories?

Try mounting the BTRFS filesystem with 'nobarrier', since this may be
an obvious difference. Also, for metadata-write-intensive workloads,
when creating the filesystem try 'mkfs.btrfs -m single'. Of course,
all this doesn't explain the variance.

I'd say it's worth emplying 'blktrace' to see what happening at a
lower level, and even eg varying between deadline/CFQ I/O schedulers.

Daniel
--=20
Daniel J Blueman
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
