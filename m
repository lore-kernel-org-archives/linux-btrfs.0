From: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Subject: RE: Btrfs: broken file system design (was Unbound(?) internal 	fragmentation in Btrfs)
Date: Wed, 23 Jun 2010 20:43:01 -0700
Message-ID: <469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com>
References: <4C07C321.8010000@redhat.com> <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com> <4C1B7560.1000806@gmail.com> <AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com> <4C1BA3E5.7020400@gmail.com> <20100623234031.GF7058@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Cc: "Daniel J Blueman" <daniel.blueman@gmail.com>,
	"Mat" <jackdachef@gmail.com>,
	"LKML" <linux-kernel@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>,
	"Chris Mason" <chris.mason@oracle.com>,
	"Ric Wheeler" <rwheeler@redhat.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Linus Torvalds" <torvalds@linux-foundation.org>,
	"The development of BTRFS" <linux-btrfs@vger.kernel.org>
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100623234031.GF7058@shareable.org>
List-ID: <linux-btrfs.vger.kernel.org>

Just an FYI reminder.  The original test (2K files) is utterly
pathological for disk drives with 4K physical sectors, such as
those now shipping from WD, Seagate, and others.  Some of the
SSDs have larger (16K0 or smaller blocks (2K).  There is also
the issue of btrfs over RAID (which I know is not entirely
sensible, but which will happen).

The absolute minimum allocation size for data should be the same
as, and aligned with, the underlying disk block size.  If that
results in underutilization, I think that's a good thing for
performance, compared to read-modify-write cycles to update
partial disk blocks. 

