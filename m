From: Jan Schmidt <list.btrfs@jan-o-sch.net>
Subject: Re: How to implement raid1 repair
Date: Thu, 17 Mar 2011 18:49:31 +0100
Message-ID: <4D8249AB.8030903@jan-o-sch.net>
References: <4D821ED3.5050605@jan-o-sch.net> <1300382863-sup-9183@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	linux-raid <linux-raid@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1300382863-sup-9183@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/17/2011 06:36 PM, Chris Mason wrote:
> Excerpts from Jan Schmidt's message of 2011-03-17 10:46:43 -0400:
>> Hello everyone,
>>
>> Currently, btrfs has its own raid1 but no repair mechanism for bad
>> checksums or EIOs. While trying to implement such a repair mechanism,
>> several more or less general questions came up.
>>
>> There are two different retry paths for data and metadata. (If you know
>> or don't care how btrfs handles read errors: goto questions)
> 
> You should talk with Ilya, who is working on replacing failed raid drives as
> well.

Thanks, I'll do that.

>>
>> The data path: btrfs_io_failed_hook is called for each failed bio (EIO
>> or checksum error). Currently, it does not know which mirror failed at
>> first, because normally btrfs_map_block is called with mirror_num=0,
>> leading to a path where find_live_mirror picks one of them. The error
>> recovery strategy is then to explicitly read available mirrors one after
>> the other until one succeeds. In case the very first read picked mirror
>> 1 and failed, the retry code will most likely fail at mirror 1 as well.
>> It would be nice to know which mirror was picked formerly and directly
>> try the other.
> 
> Agree with Josef here, change the code to record which one was used.
> The current bio submission stuff only keeps the btrfs_multi_bio struct
> around when a given IO spans more than one disk.  But you can easily
> change it to keep the struct around for all IOs.

I was about to write the same in reply to Josefs mail :-)

>> The metadata path: there is no failure hook, instead there is a loop in
>> btree_read_extent_buffer_pages, also starting off at mirror_num=0, which
>> again leaves the decision to find_live_mirror. If there is an error for
>> any page to be read, the same retry strategy is used as is in the data
>> path. This obviously might leave you alone with unreadable data
>> (consider page x is bad on mirror 1 and page x+1 is bad on mirror 2,
>> both belonging to the same extent, you lose). It would be nice to have a
>> mechanism at a lower level issuing page-sized retries. Of course,
>> knowing which mirror is bad before trying mirror 1 again is desirable as
>> well.
> 
> Currently the block size is always smaller than the stripe size.  But
> you have a good point.
> 
>>
>> questions:
>> I have a raid1 repair solution in mind (partially coded) for btrfs that
>> can be implemented quite easily. However, I have some misgivings. All of
>> the following questions would need a "yes" for my solution to stand:
>>
>> - Is it acceptable to retry reading a block immediately after the disk
>> said it won't work? Or in case of a successful read followed by a
>> checksum error? (Which is already being done right now in btrfs.)
> 
> In the initial implementation sure, but long term it's not the best.
> 
>>
>> - Is it acceptable to always write both mirrors if one is found to be
>> bad (also consider ssds)?
> 
> Sorry, I'd rather not overwrite the copy we know to be good.
> 
>>
>> If either of the answers is "no", tracking where the initial read came
>> from seems inevitable. Tracking would be very easy if bios came back
>> with unmodified values in bd_bdev and bd_sector, which is not the case.

First off, I'll go for the tracking part then.

I'll see whether implementing the retry mechanism somewhere near
end_bio_multi_stripe is a good thing or else, how to fiddle the
mirror_num further up so the code calling the hooks can care for the
retries and repairs.

Thanks!
-Jan
