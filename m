From: David Brown <david@westcontrol.com>
Subject: Re: Confused about resizing
Date: Wed, 26 May 2010 12:38:54 +0200
Message-ID: <htitoe$jj7$1@dough.gmane.org>
References: <41855.192.168.1.2.1274841968.squirrel@bruneworld.com> <6b665e6dc44d1a42ff0b9cb220f13db7.squirrel@www.chrestomanci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <6b665e6dc44d1a42ff0b9cb220f13db7.squirrel@www.chrestomanci.org>
List-ID: <linux-btrfs.vger.kernel.org>

On 26/05/2010 10:41, David Pottage wrote:
>
> On Wed, May 26, 2010 3:46 am, Charlie Brune wrote:
>> I think I'm not understanding something fundamental about btrfs: what am I
>> able to resize?  Resizing would be nice, given that it's so hard to do
>> with ext3 (or even LVM).
>>
>> I created a btrfs filesystem on my 32G thumbdrive (/dev/sdb):
> [snip]
>
>> BUT, what's the point of resizing the filesystem with something like:
>>
>>       btrfsctl -r 15g /mnt/btrfs
>>
>> ???
>>
>> After I do it, I'm assuming that there's roughly 17G in /dev/sdb1 that I'm
>> not using, but I don't know how to get to it.  Can I make *another*
>> filesystem on /dev/sdb1 and then mount it to somewhere like /mnt/btrfs2.
>
> After shrinking the filesystem on /dev/sdb1 to 15G, you could then run a
> disk partiton tool on your thumbdrive so that the /dev/sdb1 partition is
> also 15G. After that you could create other partition(s) in the remaining
> space, and put other filing systems there.
>
> Thumb drives are a fairly poor example, because most people use them as
> single volumes, and if they find that their thumb drive is the wrong size,
> they just buy another.
>
> A better example would be a file server. Suppose you are administering a
> linux file server for an engineering company. There is a 300G disc split
> between the design and the marketing departments. Currently the designers
> have 200G for their CAD designs, and the marketing people have 100G for
> sales brochures.
>
> The designers complete a product design, and archive most of their old CAD
> data to backup tapes, and now the marketing people need more disc space to
> put together more brochures to sell it, so you need to shrink the Design
> volume to 100G, and increase the marketing volume up to 200G.
>
> With other Linux file-systems it was possible to resize volumes, but only
> if the volume is offline, so for the resize described above, you would
> need to go to the office at the weekend. With btrfs the resizing can be
> done while the system is online, so there would be no need for you to give
> up your weekend.
>

Some other file systems, including reiserfs3 and ext3/4, can be 
increased in size while online.  But they must be taken offline for a 
shrink, which is a very slow operation.  If btrfs can shrink online, 
that's a very nice feature.

> A slight fly in the ointment is that currently btrfs only supports
> extending or shrinking a filing system from the end so in order to do the
> resize above the logical partitions hosting the volumes would have to be
> under an LVM, so that the physical blocks could be stored on the disc out
> of order.
>

If you are expecting to change file system sizes, LVM makes things very 
much easier - it is far easier to create, delete or resize logical disks 
than to edit your partitions.

If you are shrinking a file system (regardless of the method), it is 
best to first shrink it to a bit less than your target size.  Then 
resize the partition, then grow the file system to fit the partition. 
That way you avoid accidentally chopping off the end of your file system 
due to rounding errors (things like block size, rounding to the nearest 
cylinder, mix-ups between GB as 2^30 bytes or 10^9 bytes, etc.).

