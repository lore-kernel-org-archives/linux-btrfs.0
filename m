From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 3/6] direct-io: do not merge logically non-contiguous
	requests
Date: Fri, 21 May 2010 11:37:45 -0400
Message-ID: <20100521153745.GP32248@dhcp231-156.rdu.redhat.com>
References: <1274300694-8976-1-git-send-email-josef@redhat.com> <1274300694-8976-3-git-send-email-josef@redhat.com> <20100521152111.GB16049@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100521152111.GB16049@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 21, 2010 at 11:21:11AM -0400, Christoph Hellwig wrote:
> On Wed, May 19, 2010 at 04:24:51PM -0400, Josef Bacik wrote:
> > Btrfs cannot handle having logically non-contiguous requests submitted.  For
> > example if you have
> > 
> > Logical:  [0-4095][HOLE][8192-12287]
> > Physical: [0-4095]      [4096-8191]
> > 
> > Normally the DIO code would put these into the same BIO's.  The problem is we
> > need to know exactly what offset is associated with what BIO so we can do our
> > checksumming and unlocking properly, so putting them in the same BIO doesn't
> > work.  So add another check where we submit the current BIO if the physical
> > blocks are not contigous OR the logical blocks are not contiguous.
> 
> This gets us slightly less optimal I/O patters for other filesystems in
> this case.  But it's probably corner case enough to not care and make it
> the default.
> 
> But please make the comment in the comment as verbose as the commit
> message so that people understand why we're doing this when reading the
> code in a few years.
> 

So after I sent this I thought that maybe I could make that test _only_ if we
provide submit_bio, that way it only affects btrfs and not everybody else, would
you prefer I do something like that?  I will make the commit log a bit more
verbose.  Thanks,

Josef
