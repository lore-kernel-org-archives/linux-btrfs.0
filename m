From: Jamie Lokier <jamie@shareable.org>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal 	fragmentation in Btrfs)
Date: Thu, 24 Jun 2010 00:40:31 +0100
Message-ID: <20100623234031.GF7058@shareable.org>
References: <4C07C321.8010000@redhat.com> <AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com> <4C1B7560.1000806@gmail.com> <AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com> <4C1BA3E5.7020400@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
	Mat <jackdachef@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Ric Wheeler <rwheeler@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C1BA3E5.7020400@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Edward Shishkin wrote:
> I have noticed that events in Btrfs develop by scenario not predicted
> by the paper of academic Ohad Rodeh (in spite of the announce that
> Btrfs is based on this paper). This is why I have started to grumble..

In btrfs, "based on" means "started with the algorithm and ideas of",
not "uses the same algorithm as".

-- Jamie
