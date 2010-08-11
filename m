From: Josef Bacik <josef@redhat.com>
Subject: Re: PATCH 3/6 - direct-io: do not merge logically non-contiguous
	requests
Date: Tue, 10 Aug 2010 21:55:52 -0400
Message-ID: <20100811015552.GC9349@dhcp231-156.rdu.redhat.com>
References: <4C5BE8DB.5030503@linux.vnet.ibm.com> <20100806120358.GA31601@infradead.org> <4C5D0BC2.1040706@linux.vnet.ibm.com> <x49ocdab9bt.fsf@segfault.boston.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <x49ocdab9bt.fsf@segfault.boston.devel.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 10, 2010 at 02:40:06PM -0400, Jeff Moyer wrote:
> Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com> writes:
> 
> > On 08/06/2010 02:03 PM, Christoph Hellwig wrote:
> >> Something is deeply wrong here.  Raw block device access has a 1:1
> >> mapping between logical and physical block numbers.  They really should
> >> never be non-contiguous.
> >
> > At least I did nothing I know about to break it :-)
> 
> I think Christoph missed that you were using ext2, not the block device.
> 
> > As I mentioned just iozone using direct I/O (-I flag of iozone then
> > using O_DIRECT for the file) on a ext2 file-system.
> > The file system was coming clean out of mkfs the file was written with
> > iozone one step before the traced read run.
> >
> > The only uncommon thing here might be the block device, which is a
> > scsi disk on our SAN servers (I'm running on s390) - so the driver in
> > charge is zfcp (drivers/s390/scsi/).
> > I could use dasd (drivers/s390/block) disks as well, but I have no
> > blktrace of them yet - what I already know is that they show a similar
> > cost increase. On monday I should be able to get machine resources to
> > verify that both disk types are affected.
> >
> > Let me know if I can do anything else on my system to shed some light
> > on the matter.
> 
> Well, the problem is pretty obvious.  Inside submit_page_section, you
> have this code:
> 
> 	/*
> 	 * If there's a deferred page already there then send it.
> 	 */
> 	if (dio->cur_page) {
> 		ret = dio_send_cur_page(dio);
> 		page_cache_release(dio->cur_page);
> 		dio->cur_page = NULL;
> 		if (ret)
> 			goto out;
> 	}
> 
> 	page_cache_get(page);/* It is in dio */
> 	dio->cur_page = page;
> 	dio->cur_page_offset = offset;
> 	dio->cur_page_len = len;
> 	dio->cur_page_block = blocknr;
> 	dio->cur_page_fs_offset = dio->block_in_file << dio->blkbits;
> 
> Notice that we're processing a new page, so we submit the old page for
> I/O.
> 
> And in dio_send_cur_page, we have this:
> 
> 	if (dio->final_block_in_bio != dio->cur_page_block ||
> 	    cur_offset != bio_next_offset)
> 		dio_bio_submit(dio);
> 
> So, we are actually comparing values between two different pages, and of
> course, this doesn't work.  We're always one page behind in the I/O.
>

So above we have this

        loff_t cur_offset = dio->block_in_file << dio->blkbits;
        loff_t bio_next_offset = dio->logical_offset_in_bio +
                dio->bio->bi_size;


block_in_file is the logical offset of the current page we are working on.
logical_offset_in_bio is the logical offset of the first page in the bio, plus
bi_size gives us the logical offset that would come next for a contiguous page,
so if cur_offset != bio_next_offset then the range in the bio and the current
page we have are not right next to eachother, so it works just fine.  It's a
little tricky, but

dio->block_in_file - logical offset of current page
dio->logical_offset_in_bio - logical offset of first page added to the bio

So say blocksize of 4k, we do dio to 12k, the first time around
dio->block_in_file is 0, we set dio->cur_page, and move on to the next page, and
bio->block_in_file is set to 1.  We find that dio->cur_page is set, so we do
dio_send_cur_page().  Since !dio->bio we create a new bio, and set
dio->logical_offset_in_bio to 0, since thats the offset of dio->cur_page.  Then
we setup the next cur_page as the page for logical block 1, and
dio->block_in_file gets bumped to 2.  We map the next block and come into
dio_send_cur_page() again.  At this point cur_offset would be 8192...and shit I
just realized what was wrong.  If you change

loff_t cur_offset = dio->block_in_file << dio->blkbits;

to

loff_t cur_offset = dio->cur_page_fs_offset << dio->blkbits;

That should fix the problem.  Sorry guys, I screwed that up.  I'll look at this
again tomorrow after I've had my 2 hours of sleep and see if this all still
makes sense, but I think the above should fixe the performance thing.  As for
the dio->boundary thing, dio_bio_submit() sets dio->boundary to 0, so the same
bio won't be submitted twice.  Thanks,

Josef
