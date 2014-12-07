Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:38686 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751255AbaLGUcc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 15:32:32 -0500
Message-ID: <6554b2b132dd3f9803bcf8c10f11a156.squirrel@webmail.wanet.net>
In-Reply-To: <5484A83A.5090109@inwind.it>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
    <44320137.fRRuR6EFMP@merkaba> <5484A83A.5090109@inwind.it>
Date: Sun, 7 Dec 2014 12:32:31 -0800
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
From: ashford@whisperpc.com
To: kreijack@inwind.it
Cc: "Shriramana Sharma" <samjnaa@gmail.com>,
        "Martin Steigerwald" <martin@lichtvoll.de>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> 3.1) even in the case of a single disk filesystem, data and metadata
> have different profiles: the data chunk doesn't have any redundancy,
> so 64kb of data consume 64kb of disk space. The metadata chunks
> usually are stored as DUP, so 64kb of metadata consume 128kb on disk.
> Moreover you have to consider that small files are stored in metadata
> chunk. This means that for big file the disk space consumed is equal
> to the data size, but for small file this is doubled.

As there's no way to predict what the user will be doing, I see no reason
to do anything except return the actual amount of free space.

> Going back to your request, to be more clear I used the following terms:
> 1- disk space used: the space used on the disk
> 2- size of data: the size of the data stored on the disks
> 3- disk free space: the unused space of the disk
> 4- free space: the size of data that the system is able to contain
>
> The value 1,2,3 are known. Which is unknown is the point 4. In
> the past I posted some patch which try to estimate the point 4 as:
>
>                                  size_of_data
> free_space = disk_free_space * -----------------
>                                 disk_space_used
>
> This estimation assumes that the ratio size_of_data/disk_space_used
> is constant. But for the point above this assumption may be wrong.

While I expect that this is the best simple prediction, it's still a
prediction, with all the possible problems that a prediction entails.  My
contention is that predictions should be avoided whenever possible.

> In conclusion, the disk usage is well known; which is unknown is
> the space that is available to the user (who is uninterested to
> all the details inside a filesystem). The best that is doable
> is an estimation like the above one.

I disagree.  My experiences with other file-systems, including ZFS, show
that the most common solution is to just deliver to the user the actual
amount of unused disk space.  Anything else changes this known value into
a guess or prediction.

Peter Ashford

