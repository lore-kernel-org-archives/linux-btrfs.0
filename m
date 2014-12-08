Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-ch2-07v.sys.comcast.net ([69.252.207.39]:48668 "EHLO
	resqmta-ch2-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbaLHE7f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 7 Dec 2014 23:59:35 -0500
Message-ID: <54853032.2080107@pobox.com>
Date: Sun, 07 Dec 2014 20:59:30 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
In-Reply-To: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/07/2014 07:15 AM, Shriramana Sharma wrote:
> IIUC:
>
> 1) btrfs fi df already shows the alloc-ed space and the space used out of that.
>
> 2) Despite snapshots, CoW and compression, the tree knows how many
> extents of data and metadata there are, and how many bytes on disk
> these occcupy, no matter what is the total (uncompressed,
> "unsnapshotted") size of all the directories and files on the disk.
>

I tried to answer this last time. So lets do a thought experiment...

You have an essentially full filesystem. Then the last two extents are 
allocated. One a 1Gb extent for data and the other is a 256Mb extent for 
metadata.

How much space on the disk is "free"? Is 1Gb for data, is it 256Mb for 
free space or is it 1280Mb for the combination of data and metadata or 
is it _zero_ for the complete absence of blocks that can be allocated 
into extents?

How about if I allocate 1Gb of data space and there is 512Mb of 
unallocated space, which is enough room for two more metadata extents 
but not enough room for another data extent. Is the drive "full" when 
you fill that last 1Gb? After all, you cannot write more data to the 
disk, but you can write more metadata.

If I start deleting files, and thereby create gaps in the previously 
allocated extents, are those gaps "free"? They are purposed but 
available for their respective uses.

Subtracting blocks allocated from blocks on media doesn't give you the 
"real" answer to what is or isnt "free".

If there is a leftover two-dozen sectors that won't fit in _any_ kind of 
extent are those sectors "Free" or are they just leftovers?

In real property terms, If I hold an easment on your driveway and you 
want to expand your house, how much of your property is can be used for 
the expansion of your house? My rights to your driveway don't count 
against you for meeting the "undeveloped land" caluclation of your local 
zoning board, but you can't build any house-bits on that driveway since 
I hold a right to use it, so it does count against your available square 
feet that you can design over.

"Free space" isn't the simple proposition you imagine because "free for 
what purpose" and "free in what sense" both have to be answered.

So the system estimates, and it does so in different ways for different 
purposes.

If you have a means in mind to resolve these conflicts we'd love to see 
the rationale and even the code...
