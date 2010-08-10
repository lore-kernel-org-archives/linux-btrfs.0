From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: PATCH 3/6 - direct-io: do not merge logically non-contiguous requests
Date: Tue, 10 Aug 2010 14:40:06 -0400
Message-ID: <x49ocdab9bt.fsf@segfault.boston.devel.redhat.com>
References: <4C5BE8DB.5030503@linux.vnet.ibm.com>
	<20100806120358.GA31601@infradead.org>
	<4C5D0BC2.1040706@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	Josef Bacik <josef@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
To: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com> writes:

> On 08/06/2010 02:03 PM, Christoph Hellwig wrote:
>> Something is deeply wrong here.  Raw block device access has a 1:1
>> mapping between logical and physical block numbers.  They really should
>> never be non-contiguous.
>
> At least I did nothing I know about to break it :-)

I think Christoph missed that you were using ext2, not the block device.

> As I mentioned just iozone using direct I/O (-I flag of iozone then
> using O_DIRECT for the file) on a ext2 file-system.
> The file system was coming clean out of mkfs the file was written with
> iozone one step before the traced read run.
>
> The only uncommon thing here might be the block device, which is a
> scsi disk on our SAN servers (I'm running on s390) - so the driver in
> charge is zfcp (drivers/s390/scsi/).
> I could use dasd (drivers/s390/block) disks as well, but I have no
> blktrace of them yet - what I already know is that they show a similar
> cost increase. On monday I should be able to get machine resources to
> verify that both disk types are affected.
>
> Let me know if I can do anything else on my system to shed some light
> on the matter.

Well, the problem is pretty obvious.  Inside submit_page_section, you
have this code:

	/*
	 * If there's a deferred page already there then send it.
	 */
	if (dio->cur_page) {
		ret = dio_send_cur_page(dio);
		page_cache_release(dio->cur_page);
		dio->cur_page = NULL;
		if (ret)
			goto out;
	}

	page_cache_get(page);/* It is in dio */
	dio->cur_page = page;
	dio->cur_page_offset = offset;
	dio->cur_page_len = len;
	dio->cur_page_block = blocknr;
	dio->cur_page_fs_offset = dio->block_in_file << dio->blkbits;

Notice that we're processing a new page, so we submit the old page for
I/O.

And in dio_send_cur_page, we have this:

	if (dio->final_block_in_bio != dio->cur_page_block ||
	    cur_offset != bio_next_offset)
		dio_bio_submit(dio);

So, we are actually comparing values between two different pages, and of
course, this doesn't work.  We're always one page behind in the I/O.

Also, the block of code above is immediately followed by this:

	/*
	 * Submit now if the underlying fs is about to perform a
	 * metadata read
	 */
	if (dio->boundary)
		dio_bio_submit(dio);

So, it looks to me like this could result in submitting the same bio
twice if you are unlucky enough.  I'll see what I can do to fix this
up.

Cheers,
Jeff
