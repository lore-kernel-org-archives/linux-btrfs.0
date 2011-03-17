From: Josef Bacik <josef@redhat.com>
Subject: Re: How to implement raid1 repair
Date: Thu, 17 Mar 2011 13:19:11 -0400
Message-ID: <20110317171911.GA11704@dhcp231-156.rdu.redhat.com>
References: <4D821ED3.5050605@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org, linux-raid@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D821ED3.5050605@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 17, 2011 at 03:46:43PM +0100, Jan Schmidt wrote:
> Hello everyone,
> 
> Currently, btrfs has its own raid1 but no repair mechanism for bad
> checksums or EIOs. While trying to implement such a repair mechanism,
> several more or less general questions came up.
> 
> There are two different retry paths for data and metadata. (If you know
> or don't care how btrfs handles read errors: goto questions)
> 
> The data path: btrfs_io_failed_hook is called for each failed bio (EIO
> or checksum error). Currently, it does not know which mirror failed at
> first, because normally btrfs_map_block is called with mirror_num=0,
> leading to a path where find_live_mirror picks one of them. The error
> recovery strategy is then to explicitly read available mirrors one after
> the other until one succeeds. In case the very first read picked mirror
> 1 and failed, the retry code will most likely fail at mirror 1 as well.
> It would be nice to know which mirror was picked formerly and directly
> try the other.
> 

So why not add a new field to the btrfs_multi_bio that tells you which mirror
we're acting on so that the endio stuff can know?  That should be relatively
simple to accomplish.

> The metadata path: there is no failure hook, instead there is a loop in
> btree_read_extent_buffer_pages, also starting off at mirror_num=0, which
> again leaves the decision to find_live_mirror. If there is an error for
> any page to be read, the same retry strategy is used as is in the data
> path. This obviously might leave you alone with unreadable data
> (consider page x is bad on mirror 1 and page x+1 is bad on mirror 2,
> both belonging to the same extent, you lose). It would be nice to have a
> mechanism at a lower level issuing page-sized retries. Of course,
> knowing which mirror is bad before trying mirror 1 again is desirable as
> well.
> 
> questions:
> I have a raid1 repair solution in mind (partially coded) for btrfs that
> can be implemented quite easily. However, I have some misgivings. All of
> the following questions would need a "yes" for my solution to stand:
> 
> - Is it acceptable to retry reading a block immediately after the disk
> said it won't work? Or in case of a successful read followed by a
> checksum error? (Which is already being done right now in btrfs.)
> 

You mean re-read the same block?  No thats not ok, if the checksum failed or the
drive returned with the buffer not uptodate then re-reading the thing isn't
likely to change anything, so just wastes time.

> - Is it acceptable to always write both mirrors if one is found to be
> bad (also consider ssds)?
> 

Yes, if one is bad we really want to re-write the bad one so we don't find it
again.

> If either of the answers is "no", tracking where the initial read came
> from seems inevitable. Tracking would be very easy if bios came back
> with unmodified values in bd_bdev and bd_sector, which is not the case.

Huh?  The bios come back with the bi_bdev/bi_sector they were submitted on, how
are you getting something different?  Thanks,

Josef
