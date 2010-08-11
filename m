From: Josef Bacik <josef@redhat.com>
Subject: Re: PATCH 3/6 - direct-io: do not merge logically non-contiguous
	requests
Date: Wed, 11 Aug 2010 10:08:41 -0400
Message-ID: <20100811140841.GD9349@dhcp231-156.rdu.redhat.com>
References: <4C5BE8DB.5030503@linux.vnet.ibm.com> <20100806120358.GA31601@infradead.org> <4C5D0BC2.1040706@linux.vnet.ibm.com> <x49ocdab9bt.fsf@segfault.boston.devel.redhat.com> <20100811015552.GC9349@dhcp231-156.rdu.redhat.com> <x49zkwtb7ou.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>,
	Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <x49zkwtb7ou.fsf@segfault.boston.devel.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 11, 2010 at 09:27:45AM -0400, Jeff Moyer wrote:
> Josef Bacik <josef@redhat.com> writes:
> 
> > So say blocksize of 4k, we do dio to 12k, the first time around
> > dio->block_in_file is 0, we set dio->cur_page, and move on to the next page, and
> > bio->block_in_file is set to 1.  We find that dio->cur_page is set, so we do
> > dio_send_cur_page().  Since !dio->bio we create a new bio, and set
> > dio->logical_offset_in_bio to 0, since thats the offset of dio->cur_page.  Then
> > we setup the next cur_page as the page for logical block 1, and
> > dio->block_in_file gets bumped to 2.  We map the next block and come into
> > dio_send_cur_page() again.  At this point cur_offset would be 8192...and shit I
> > just realized what was wrong.  If you change
> >
> > loff_t cur_offset = dio->block_in_file << dio->blkbits;
> >
> > to
> >
> > loff_t cur_offset = dio->cur_page_fs_offset << dio->blkbits;
> 
> Sorry, I wasn't very clear in my description, but you figured it out.
> ;-)  Of course, cur_page_fs_offset is already in bytes, so that left
> shift is not necessary.
>

Ah right, sorry.
 
> > That should fix the problem.  Sorry guys, I screwed that up.  I'll look at this
> > again tomorrow after I've had my 2 hours of sleep and see if this all still
> > makes sense, but I think the above should fixe the performance thing.  As for
> > the dio->boundary thing, dio_bio_submit() sets dio->boundary to 0, so the same
> > bio won't be submitted twice.
> 
> While I don't doubt that you are right, I will sleep better at night if
> we do an else if.  (To be fair, this ambiguity was not introduced by
> you).
> 
> I've tested this patch, added printk's and watched blktrace to verify
> that we don't split up I/Os.  So long as no one objects, I'll post this
> for inclusion in a new thread.
> 
> Thanks for looking into it, Josef.
>

No problem, thanks for making me look at it again.  You can add

Acked-by: Josef Bacik <josef@redhat.com>

Thanks,

Josef 
