From: Jan Schmidt <mail@jan-o-sch.net>
Subject: Re: [PATCH v2] xfstests: new check 278 to ensure btrfs backref integrity
Date: Wed, 04 Jan 2012 18:04:51 +0100
Message-ID: <4F0486B3.8010301@jan-o-sch.net>
References: <1324552138-30584-1-git-send-email-list.btrfs@jan-o-sch.net> <20120104163946.GA8153@infradead.org> <4F0485FE.8000405@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Christoph Hellwig <hch@infradead.org>,
	Jan Schmidt <list.btrfs@jan-o-sch.net>, xfs@oss.sgi.com,
	linux-btrfs@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0485FE.8000405@sandeen.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 04.01.2012 18:01, Eric Sandeen wrote:
> 276 got merged on Dec 28 before my requests for fixup, I guess?  And it
> explicitly sets FSTYP=btrfs which is why it fails.
> 
> the 278 patch v2 in this thread works ok for me.
> 
> so munging the 278 patch here into the existing 276 should be the
> right approach.

Yeah we figured that out on irc some minutes ago :-)

I'm currently building v2 as an incremental patch to 276 (without rename
to 278) and send it as

   [PATCH] xfstests: fixup check 276

soon.

-Jan
