From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Fri, 1 Jul 2011 05:37:02 -0400
Message-ID: <20110701093702.GA28684@infradead.org>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
 <1309275199-10801-5-git-send-email-josef@redhat.com>
 <20110629065306.GC1026@dastard>
 <20110629074021.GA26086@infradead.org>
 <4E0B019E.8080800@draigBrady.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>,
	xfs@oss.sgi.com, viro@ZenIV.linux.org.uk,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: P?draig Brady <P@draigBrady.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4E0B019E.8080800@draigBrady.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 29, 2011 at 11:42:38AM +0100, P?draig Brady wrote:
> There is the argument, that if this interface can distinguish
> these dirty unwritten extents, then why can't the fiemap interface too?
> The advantage of the fiemap interface is that it can distinguish
> empty extents vs holes. Empty extents will become increasingly common
> I think, given the fragmentation and space guarantee benefits they give.
> It would be cool for cp for example to be able to efficiently copy
> empty extents from source to dest.

That brings us back to square one.  FIEMAP is supposed to tell you about
the physical layout on disk.  Unwritten extents physically always are
there, but whether they might have to be copied depends entirely on
in-core state.  Finding that incore state in addition is not all that
easy compared to simply walking the extents.  People might decide it's
worth for an interface like SEEK_HOLE specificly asking for that, but
grafting it into FIEMAP through the backdoor is a horrible idea.
