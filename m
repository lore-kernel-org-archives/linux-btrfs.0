Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:47108 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab2EUPBo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 May 2012 11:01:44 -0400
Message-ID: <4FBA57BC.9080407@giantdisaster.de>
Date: Mon, 21 May 2012 16:57:00 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: David Sterba <dave@jikos.cz>
Subject: Re: [PATCH v3 3/3] Btrfs: read device stats on mount, write modified
 ones during commit
References: <cover.1337185201.git.sbehrens@giantdisaster.de> <f7e60650b3463d028f86b38ef3e6aaf77efa665b.1337185201.git.sbehrens@giantdisaster.de> <20120518115719.GH24394@twin.jikos.cz>
In-Reply-To: <20120518115719.GH24394@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 18 May 2012 13:57:19 +0200, David Sterba wrote:
> On Wed, May 16, 2012 at 06:50:47PM +0200, Stefan Behrens wrote:
>> --- a/fs/btrfs/ctree.h
>> +++ b/fs/btrfs/ctree.h
>> @@ -823,6 +823,26 @@ struct btrfs_csum_item {
>>  	u8 csum;
>>  } __attribute__ ((__packed__));
>>  
>> +struct btrfs_device_stats_item {
>> +	/*
>> +	 * grow this item struct at the end for future enhancements and keep
>> +	 * the existing values unchanged
>> +	 */
>> +	__le64 cnt_write_io_errs; /* EIO or EREMOTEIO from lower layers */
>> +	__le64 cnt_read_io_errs; /* EIO or EREMOTEIO from lower layers */
>> +	__le64 cnt_flush_io_errs; /* EIO or EREMOTEIO from lower layers */
>> +
>> +	/* stats for indirect indications for I/O failures */
>> +	__le64 cnt_corruption_errs; /* checksum error, bytenr error or
>> +				     * contents is illegal: this is an
>> +				     * indication that the block was damaged
>> +				     * during read or write, or written to
>> +				     * wrong location or read from wrong
>> +				     * location */
>> +	__le64 cnt_generation_errs; /* an indication that blocks have not
>> +				     * been written */
> 
> A few spare u64 would come handy in the future. Currently there are 5,
> so add like 7 or 11. We might be interested in collecting more types of
> stats, ore more fine-grained.
> 
> I see the comment above about enhancing the structure, but then you need
> to version this stucture. Let's say this kernel at version 3.5 add this
> structre as you propose it now, and kernel 3.6 adds another item
> 'cnt_exploded'.

The size of the item is part of the information that is stored on disk.
This is used to downgrade and upgrade the item, and to support
downgrading and upgrading the kernel.

In btrfs_init_device_stats(), where the items are read from disk while
mounting, if the read item is too small, the missing statistic members
at the end are filled with zero. If the item is larger than expected,
the additional values are ignored.
And in update_device_stat_item(), where the items are written to disk
with each commit (only if they have been modified), if the disk item is
too small, it is removed and replaced by a larger one. If the disk item
is larger than expected, the additional values are ignored and not modified.

The ioctl() works similar. In the user mode, the max number of statistic
members is set before the ioctl(). The kernel code uses this parameter
to determine, how much values to write and at the end replaces it with
the number of values written. Then the btrfs tool prints all the values
that it knows by name, but at most the number of values that the kernel
has set.

If I compare this solution to the one that just pads the item size to a
well known size, the disadvantage are the extra lines of code. The
advantage is that no limit at all is set.

Rereading the code, I recognized that I will need to send a v4. The
ioctl structure needs to be padded, or copy_to_user(..., sizeof(struct
...)) would overwrite memory when the kernel struct is grown and the
btrfs tool is old.


> Accessing the 3.6-created image with a 3.5 will be ok (older kernel will
> not touch the new items).
> 
> Accessing the 3.5-created image with a 3.6 will be problematic, as the
> kernel would try to access ->cnt_exploded .
> 
> So, either the 3.6 kernel needs to know not to touch the missing item
> (ie. via reading the struct version from somewhere, stored on disk).
> 
> Or, there are spare items, which are zeroed in versions that do not use
> them and naturally used otherwise, but when new kernel uses old image,
> it finds zeros (and will be safe).
> 
>> +} __attribute__ ((__packed__));
>> +
