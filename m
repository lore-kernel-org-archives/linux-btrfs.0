From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Date: Tue, 30 Aug 2011 18:17:02 -0700
Message-ID: <4E5D8B8E.8030401@oracle.com>
References: <1309275199-10801-1-git-send-email-josef@redhat.com> <1309275199-10801-5-git-send-email-josef@redhat.com> <20110825060632.GA9933@infradead.org> <20110825064039.GO3162@dastard> <0A267E55-7772-438D-B6A7-89B73020F311@dilger.ca> <20110826013528.GW3162@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Andreas Dilger <adilger@dilger.ca>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	xfs@oss.sgi.com, viro@ZenIV.linux.org.uk, dchinner@redhat.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110826013528.GW3162@dastard>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/25/2011 06:35 PM, Dave Chinner wrote:
> Agreed, that's the way I'd interpret it, too. So perhaps we need to
> ensure that this interpretation is actually tested by this test?
>
> How about some definitions to work by:
>
> Data: a range of the file that contains valid data, regardless of
> whether it exists in memory or on disk. The valid data can be
> preceeded and/or followed by an arbitrary number of zero bytes
> dependent on the underlying implementation of hole detection.
>
> Hole: a range of the file that contains no data or is made up
> entirely of  NULL (zero) data. Holes include preallocated ranges of
> files that have not had actual data written to them.
>
> Does that make sense? It has sufficient flexibility in it for the
> existing generic "non-implementation", allows for filesystems to
> define their own hole detection boundaries (e.g. filesystem block
> size), and effectively defines how preallocated ranges from
> fallocate() should be treated (i.e. as holes). If we can agree on
> those definitions, I think that we should document them in both the
> kernel and the man page that defines SEEK_HOLE/SEEK_DATA so everyone
> is on the same page...

We should not tie in the definition to existing fs technologies. Instead
we should let the fs weigh the cost of providing accurate information
with the possible gain in performance.

Data:
A range in a file that could contain something other than nulls.
If in doubt, it is data.

Hole:
A range in a file that only contains nulls.
