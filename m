From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v2 0/6] btrfs: scrub
Date: Sat, 12 Mar 2011 14:20:36 +0100
Message-ID: <4D7B7324.2000802@gmx.net>
References: <cover.1299854593.git.sensille@gmx.net> <4D7A4B10.7050904@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
	jansen@webgods.de
To: Ric Wheeler <ricwheeler@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D7A4B10.7050904@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Ric Wheeler wrote:
> On 03/11/2011 09:49 AM, Arne Jansen wrote:
> 
> Great work!
> 
> I do wonder if we should also worry about the unallocated part of the 
> storage device. Often, with local disks specifically, your unused space 
> might accumulate errors over time.
> 
> What you add to your scrub phase is a simple read operation for the 
> unallocated ranges (optionally a READ_VERIFY which validates the data on 
> platter without transferring data over the bus to the host).
> 
> The recovery operation here would be to write (zeros) to the block if an 
> error is detected, so we might be pessimistic and simply use write to 
> "zero" those unallocated ranges as well.  Note that there are 
> "WRITE_SAME" commands that RAID people use for initializing unused 
> drives for example.
> 
> I would not run the overwrite or read check on SSD or arrays so this 
> would be an optional type of scrub I suppose.

Thanks for your suggestion. I'll definitely add scrubbing unused space in
a later revision and make it optional.
The read/verify part is quite easy (as long as I can manage to get a
READ_VERIFY through the stack). Rewriting detected errors is harder as I
have to make sure that it doesn't get allocated in the meantime. Currently
scrub is working only on the latest commit and has no knowledge of the
running transaction except that it is synchronized with it to switch to
the next commit.

Arne

> 
> Regards,
> 
> Ric
> 
>> Arne Jansen (5):
>>    btrfs: add parameter to btrfs_lookup_csum_range
>>    btrfs: make struct map_lookup public
>>    btrfs: add scrub code and prototypes
>>    btrfs: sync scrub with commit&  device removal
>>    btrfs: add state information for scrub
>>
>> Jan Schmidt (1):
>>    btrfs: new ioctls for scrub
>>
>>   fs/btrfs/Makefile      |    2 +-
>>   fs/btrfs/ctree.h       |   46 ++-
>>   fs/btrfs/disk-io.c     |   16 +
>>   fs/btrfs/file-item.c   |    8 +-
>>   fs/btrfs/inode.c       |    2 +-
>>   fs/btrfs/ioctl.c       |  131 +++++
>>   fs/btrfs/ioctl.h       |   55 ++
>>   fs/btrfs/relocation.c  |    2 +-
>>   fs/btrfs/scrub.c       | 1463 
>> ++++++++++++++++++++++++++++++++++++++++++++++++
>>   fs/btrfs/transaction.c |    3 +
>>   fs/btrfs/tree-log.c    |    6 +-
>>   fs/btrfs/volumes.c     |   16 +-
>>   fs/btrfs/volumes.h     |   17 +
>>   13 files changed, 1743 insertions(+), 24 deletions(-)
>>   create mode 100644 fs/btrfs/scrub.c
>>
> 

