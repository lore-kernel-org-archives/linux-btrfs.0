From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] direct-io: do not merge logically non-contiguous
	requests
Date: Fri, 21 May 2010 11:21:11 -0400
Message-ID: <20100521152111.GB16049@infradead.org>
References: <1274300694-8976-1-git-send-email-josef@redhat.com> <1274300694-8976-3-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, hch@infradead.org,
	akpm@linux-foundation.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1274300694-8976-3-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 19, 2010 at 04:24:51PM -0400, Josef Bacik wrote:
> Btrfs cannot handle having logically non-contiguous requests submitted.  For
> example if you have
> 
> Logical:  [0-4095][HOLE][8192-12287]
> Physical: [0-4095]      [4096-8191]
> 
> Normally the DIO code would put these into the same BIO's.  The problem is we
> need to know exactly what offset is associated with what BIO so we can do our
> checksumming and unlocking properly, so putting them in the same BIO doesn't
> work.  So add another check where we submit the current BIO if the physical
> blocks are not contigous OR the logical blocks are not contiguous.

This gets us slightly less optimal I/O patters for other filesystems in
this case.  But it's probably corner case enough to not care and make it
the default.

But please make the comment in the comment as verbose as the commit
message so that people understand why we're doing this when reading the
code in a few years.

