From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Btrfs: broken file system design
Date: Fri, 25 Jun 2010 11:15:55 +0200
Message-ID: <87hbkrealw.fsf@basil.nowhere.org>
References: <4C07C321.8010000@redhat.com>
	<AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>
	<4C1B7560.1000806@gmail.com>
	<AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com>
	<4C1BA3E5.7020400@gmail.com> <20100623234031.GF7058@shareable.org>
	<469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com>
	<AANLkTil5Gl0-rWClRsLZby_c37bQu5RB_tCgHsxTFshO@mail.gmail.com>
	<469D2D911E4BF043BFC8AD32E8E30F5B24AEBB@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Mike Fedyk" <mfedyk@mikefedyk.com>,
	"Daniel J Blueman" <daniel.blueman@gmail.com>,
	"Mat" <jackdachef@gmail.com>,
	"LKML" <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>,
	"Chris Mason" <chris.mason@oracle.com>,
	"Ric Wheeler" <rwheeler@redhat.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>,
	"The development of BTRFS" <linux-btrfs@vger.kernel.org>
To: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <469D2D911E4BF043BFC8AD32E8E30F5B24AEBB@wdscexbe07.sc.wdc.com>
	(Daniel Taylor's message of "Thu, 24 Jun 2010 15:06:03 -0700")
List-ID: <linux-btrfs.vger.kernel.org>

"Daniel Taylor" <Daniel.Taylor@wdc.com> writes:
>
> As long as no object smaller than the disk block size is ever
> flushed to media, and all flushed objects are aligned to the disk
> blocks, there should be no real performance hit from that.

The question is just how large such a block needs to be.
Traditionally some RAID controllers (and possibly some SSDs now) 
needed very large blocks upto MBs.

>
> Otherwise we end up with the damage for the ext[234] family, where
> the file blocks can be aligned, but the 1K inode updates cause
> the read-modify-write (RMW) cycles and and cost >10% performance
> hit for creation/update of large numbers of files.

Fixing that doesn't require a new file system layout, just some effort
to read/write inodes in batches of multiple of them. XFS did similar
things for a long time, I believe there were some efforts for this
for ext4 too.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
