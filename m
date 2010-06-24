From: David Woodhouse <dwmw2@infradead.org>
Subject: RE: Btrfs: broken file system design (was Unbound(?) internal
 fragmentation in Btrfs)
Date: Thu, 24 Jun 2010 10:50:13 +0100
Message-ID: <1277373013.21395.0.camel@localhost>
References: <4C07C321.8010000@redhat.com>
	 <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com>
	 <4C1B7560.1000806@gmail.com>
	 <AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com>
	 <4C1BA3E5.7020400@gmail.com> <20100623234031.GF7058@shareable.org>
	 <469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
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

On Wed, 2010-06-23 at 20:43 -0700, Daniel Taylor wrote:
> There is also the issue of btrfs over RAID (which I know is not
> entirely sensible, but which will happen). 

Well, we could discourage that by merging the RAID support that's been
pending for a while.... but I suspect Chris is a bit busy right now :)

-- 
dwmw2
