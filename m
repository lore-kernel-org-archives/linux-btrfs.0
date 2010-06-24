From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal
	fragmentation in Btrfs)
Date: Wed, 23 Jun 2010 21:51:12 -0700
Message-ID: <AANLkTil5Gl0-rWClRsLZby_c37bQu5RB_tCgHsxTFshO@mail.gmail.com>
References: <4C07C321.8010000@redhat.com>
	<AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>
	<4C1B7560.1000806@gmail.com>
	<AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com>
	<4C1BA3E5.7020400@gmail.com>
	<20100623234031.GF7058@shareable.org>
	<469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
	Mat <jackdachef@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Daniel Taylor <Daniel.Taylor@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 23, 2010 at 8:43 PM, Daniel Taylor <Daniel.Taylor@wdc.com> =
wrote:
> Just an FYI reminder. =C2=A0The original test (2K files) is utterly
> pathological for disk drives with 4K physical sectors, such as
> those now shipping from WD, Seagate, and others. =C2=A0Some of the
> SSDs have larger (16K0 or smaller blocks (2K). =C2=A0There is also
> the issue of btrfs over RAID (which I know is not entirely
> sensible, but which will happen).
>
> The absolute minimum allocation size for data should be the same
> as, and aligned with, the underlying disk block size. =C2=A0If that
> results in underutilization, I think that's a good thing for
> performance, compared to read-modify-write cycles to update
> partial disk blocks.

Block size =3D 4k

Btrfs packs smaller objects into the blocks in certain cases.
