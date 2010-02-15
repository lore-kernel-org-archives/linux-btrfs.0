From: jim owens <owens6336@gmail.com>
Subject: Re: [PATCH V2] Btrfs: Full direct I/O and AIO read implementation.
Date: Mon, 15 Feb 2010 14:18:15 -0500
Message-ID: <4B799DF7.9090008@gmail.com>
References: <4B7300BE.5000909@hp.com> <20100212192804.GE4191@localhost.localdomain> <4B77521F.2060105@gmail.com> <20100215164255.GG11057@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Chris Mason <chris.mason@oracle.com>,
	jim owens <owens6336@gmail.com>,
	Josef Bacik <josef@redhat.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100215164255.GG11057@think>
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason wrote:
> Thanks to both Jim and Josef for their time on this one.  More comments
> below.
> 
> On Sat, Feb 13, 2010 at 08:30:07PM -0500, jim owens wrote:
>> Josef Bacik wrote:
>>> On Wed, Feb 10, 2010 at 01:53:50PM -0500, jim owens wrote:
>>>> +	/* traditional 512-byte device sector alignment is the
>> The problem that I did not explain in my comment is that other fs's
>> get the blocksize from 1 device bdi, which usually will be 512.  But
>> the btrfs bdi covers all volumes and gives the btrf logical 4096 size.
>> If we do what is done in direct-io.c then we only allow access on 4k
>> (or in the future larger logical) boundaries.
> 
> We can record the smallest alignment while scanning the devices and just
> use that.  In general 4K is good enough, although some other database
> company might be more worried about smaller numbers.

So you are saying at mount time we will set a new field in a
btrfs data structure that we can use here instead of the hard-code.
With today's disks this will usually be 512.

>>>> +getlock:
>>>> +	mutex_lock(&diocb->inode->i_mutex);
>>>> +		
>>> We don't need the i_mutex here.
>> I disagree, see following code.  If we don't hold the mutex then
>> we can have a new writer between the ordered wait and i_size_read()
>> so I would blow up if the file size was less than user-specified
>> data_len at ordered wait but grows before I fetch the file size.
>> I will not have flushed that new data to disk but will read it.
> 
> Using the extent lock should be enough.  File write doesn't use the
> extent lock before changing i_size, but we do use the extent lock before
> we actually add the metadata pointers.  The end result should be that if
> someone races in during an O_DIRECT read, the read will find either extent
> pointers for the old i_size (and return zeros like it should) or it will
> find extent pointers for the new i_size and everything will be on disk.
> 
> We get this for free because we don't update the extent pointers until
> the IO is done.
> 
>>>> +	/* ensure writeout and btree update on everything
>>>> +	 * we might read for checksum or compressed extents
>>>> +	 */
>>>> +	data_len = diocb->lockend + 1 - diocb->lockstart;
>>>> +	err = btrfs_wait_ordered_range(diocb->inode, diocb->lockstart, data_len);
>>>> +	if (err) {
>>>> +		diocb->error = err;
>>>> +		mutex_unlock(&diocb->inode->i_mutex);
>>>> +		return;
>>>> +	}
>>>> +	data_len = i_size_read(diocb->inode);
>>>> +	if (data_len < end)
>>>> +		end = data_len;
>>>> +	if (end <= diocb->start) {
>>>> +		mutex_unlock(&diocb->inode->i_mutex);
>>>> +		goto fail; /* 0 is returned past EOF */
>>>> +	}
>>>> +	if (!loop) {
>>>> +		loop++;
>>>> +		diocb->terminate = end;
>>>> +		diocb->lockend = ALIGN(diocb->terminate, diocb->blocksize) - 1;
>>>> +	}
>>>> +
>>>> +	lock_extent(io_tree, diocb->lockstart, diocb->lockend, GFP_NOFS);
>>> Ok so between teh btrfs_wait_ordered_range and the lock_extent we could have had
>>> another ordered extent come in, so here we should be checking to see if there is
>>> an ordered extent, and if there is put it and go back to getlock.  Look at
>>> btrfs_page_mkwrite() for an example of what I'm talking about.  It would
>>> probably be good to move all the size read stuff under the lock_extent(), but I
>>> couldn't quite figure out how to do it nicely, so either way.
>>>
>>>> +	mutex_unlock(&diocb->inode->i_mutex);
>> Holding the mutex elegantly fixes that whole problem
>> because I am protecting everything from new writes.
>>
> 
> But, we're making the performance of the common case (parallel reads)
> dramatically slower to close a small race.  Reads and writes are allowed
> to race, and the results are allowed to be undefined.  The only
> requirement is that we not return garbage (zeros, or good data only).

I agree with both why we don't want the mutex and that we don't care
about the read returning old or new data.

But in spite of what you said above, I found lock_extent() was
not enough and I needed the i_mutex.

The problem I had was that if btrfs_wait_ordered_range() does not
run on the new data, that data can still be on disk but the btree
checksum is wrong. I need the checksum forced into the btree so
I don't fail the comparison.

Even an overwrite when nodatacow is set will cause the same problem.

I can try to code something like btrfs_page_mkwrite() does and see
if that works, though I really question if that will be a dramatic
improvement in parallel read because now we have to take the lock
and search the ordered tree.  To me this will be a net loss of
performance on files that are not being modified as the i_mutex
does not slow down parallel readers except when the area they
are reading needs flushed.  And if the file is being modified in
the spot we are reading, without i_mutex we may need to flush
it multiple times, endlessly.  And unlike btrfs_page_mkwrite()
this code is not doing just 1 page.

Or am I getting something wrong?

> I think the temp buffer setup is the best place to start for
> O_DIRECT + compressed.

Not sure what you mean by that.

Maybe people have the same "brilliant idea" I had to read
compressed data into user memory and decompress it there.
Lucky for me, my test case quickly proved that I made a
huge blunder trying that.  Even putting just the first 4k
of 28k compressed data at the final 4k of the user's memory
did not work because all of the user's read was decompressed
from that 1st block.  Compression is not linear.

jim
