Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f177.google.com ([209.85.210.177]:48901 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab3BURc6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Feb 2013 12:32:58 -0500
Received: by mail-ia0-f177.google.com with SMTP id o25so3646704iad.36
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Feb 2013 09:32:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20130220175410.GB2062@localhost.localdomain>
References: <CAEx9m45BO=McK-NrL3fX7QiJMtf-T+bKoc1D1G=6vHxYT8b36g@mail.gmail.com>
 <20130220175410.GB2062@localhost.localdomain>
From: Aastha Mehta <aasthakm@gmail.com>
Date: Thu, 21 Feb 2013 18:32:37 +0100
Message-ID: <CAEx9m46b9rW4xDiQi8QiTmyC5Wa9hNcasL_nXF4Y2qdyPE+D6g@mail.gmail.com>
Subject: Re: basic questions regarding COW in Btrfs
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks a lot for the prompt response. I had seen that, but I am still
not sure of where it really
happens within fill_delalloc. Could you help me a little further in that path?

Secondly, now I am confused between the btree_writepages and
btrfs_writepages/btrfs_writepage
methods. I thought btrfs_writepages was for writing the pages holding
inodes and btree_writepages
for writing the other indirect and leaf extents of the btree. Then, it
seems that the write operations
lead to update of the file system data structures in a top-down
manner, i.e. first changing the inode
and then the data extents. Is that correct?

Thirdly, it seems that the old extents maybe dropped before the new
extents are flushed to the disk.
What would happen if the write fails before the disk commit? What am I
missing here?

Thanks,
Aastha.

On 20 February 2013 18:54, Josef Bacik <jbacik@fusionio.com> wrote:
> On Wed, Feb 20, 2013 at 10:28:10AM -0700, Aastha Mehta wrote:
>> Hello,
>>
>> I am trying to understand the COW mechanism in Btrfs. Is it correct to
>> say that unless nodatacow option is specified, Btrfs always performs
>> COW for all the data+metadata extents used in the system?
>>
>
> So we always cow the metadata, but yes nodatacow means we don't cow the actual
> data in the data extents.
>
>> I saw that COWing is implemented in btrfs_cow_block() function, which
>> is called at the time of searching a slot for a particular item, while
>> inserting into a new slot, committing transactions, while creating
>> pending snapshots and few other places.
>>
>> However, while tracing through the complete write path, I could not
>> quite figure out when extents actually get COWed. Could you please
>> point me to the place where COWing takes place? Is there any time
>> when, for performance or any other reasons, the extents are not COWed
>> but overwritten in place (apart from the explicit nodatacow flag being
>> set during mount)?
>
> You'll want to look at the tree operation ->fill_delalloc().  Thats where we do
> cow_file_range().  We allocate new space and write.  When we finish the ordered
> io we do btrfs_drop_extents() on the range we just wrote which will free up any
> existing extents that exist, and then insert our new file extent.  Thanks,
>
> Josef
