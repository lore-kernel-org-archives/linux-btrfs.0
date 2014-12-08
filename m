Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lb1.pop2.wanet.net ([65.244.248.2]:54985 "EHLO
	serv004.pop2.wanet.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754395AbaLHIMl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Dec 2014 03:12:41 -0500
Message-ID: <61505dcf71045b878e3a7c21d797ec30.squirrel@webmail.wanet.net>
In-Reply-To: <54851033.7010601@cn.fujitsu.com>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
    <44320137.fRRuR6EFMP@merkaba> <5484A83A.5090109@inwind.it>
    <6554b2b132dd3f9803bcf8c10f11a156.squirrel@webmail.wanet.net>
    <5484DC3C.7040409@inwind.it>
    <73b1fa42cc61f5a843206a8164952f74.squirrel@webmail.wanet.net>
    <54851033.7010601@cn.fujitsu.com>
Date: Mon, 8 Dec 2014 00:12:38 -0800
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
From: ashford@whisperpc.com
To: "Qu Wenruo" <quwenruo@cn.fujitsu.com>
Cc: ashford@whisperpc.com, kreijack@inwind.it,
        "Shriramana Sharma" <samjnaa@gmail.com>,
        "Martin Steigerwald" <martin@lichtvoll.de>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> -------- Original Message --------
> Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
> From: <ashford@whisperpc.com>
> To: <kreijack@inwind.it>
> Date: 2014年12月08日 08:12
>> Goffredo,
>>
>>> So in case you have a raid1 filesystem on two disks; each disk has
>>> 300GB
>>> free; which is the free space that you expected: 300GB or 600GB and why
>>> ?
>> You should see 300GB free.  That's what you'll see with RAID-1 with a
>> hardware RAID controller, and with MD RAID.  Why would you expect to see
>> anything else with BTRFS RAID?
>>
>> Peter Ashford
> Yeah, you pointed out the real problem here:
>
> [DIFFERENT RESULT FROM DIFFERENT VIEW]
> See from *PURE ON-DISK* usage, it is still 600G, no matter what level of
> RAID.
> See from *BLOCK LEVEL RAID1* usage, it is 300G. If fs(not btrfs) is
> build on BLOCK LEVEL RAID1,
> then the *FILESYSTEM* usage will also be 300G
>
> [BTRFS DOES NOT BELONG TO ANY TYPE]
> But, btrfs is neither pure block level management(that should be MD or
> HW RAID or LVM), nor a
> traditional filesystem!!

For the purposes of reporting free space, it is reasonable to assume that
the default structure will be used.  If the default for the volume or
subvolume is RAID-1, then that should be used for 'df' output.  Obviously,
the same should be done for other RAID levels.

> So the root of the problem is, btrfs mixs the position of block level
> management and filesystem level
> management, which makes everything hard to understand.
> You can't treat btrfs raid1 as a complete block level raid1, due to its
> flexibility on metadata/data profile different.

It will have the same discrepancies as other file-systems with
compression, plus a few more of its own, due to chunking.  If the
file-system can't give a completely accurate answer, it should give one
that makes sense.

> If vanilla df command shows filesystem level freespace, then btrfs won't
> give a accurate on.
>
> [ONLY PREDICABLE CASE]
> For the 300Gx2 case for btrfs, you can only consider it 300G free space
> only if you can ensure that
> there was/is and will be only RAID1 data/metadata storing on it.(also
> need to ignore small space usage on CoW)

I disagree.  You can consider the RAID structure to be whatever the
default structure is.  If the default is RAID-1, then that structure
should be used to compute the free space for 'df'.  The user should
understand that by explicitly requesting a different RAID structure,
different amounts of space will be used.

> [RELIABLE DATA IS ON-DISK USAGE]
> Only pure on-disk level usage is *a little* reliable. There is still
> problem for unbalanced metadata/data chunk
> allocation problem(e.g, all space is allocated for data, no space for
> metadata CoW write).

I agree.  Unused disk space isn't always available to be used by data. 
Sometimes it's reserved for metadata of one sort or another, and sometimes
it's too small to be of use.  In addition, BTRFS sometimes (with small
files) uses the Metadata chunks for data.  Yes, it's a complex problem. 
There is no simple solution that will make everyone happy.

---------------------------------

As for the 'df' output, I believe that the default should be the sum of
free space in data chunks, free space in metadata chunks and unallocated
space, ignoring any amounts that are small enough that BTRFS won't use
them, and adjusted for the RAID level of the volume/subvolume.

While it's possible to generate other values that will make sense for
specific cases, it's not possible to create one value that is correct in
all cases.

If it's not possible to be absolutely correct, considering every usage (or
even the most common usages), a 'reasonable' value should be returned. 
That reasonable value should be based on the default volume/subvolume
settings, including RAID levels and any space limits that may exist on the
volume or subvolume.  It should neither be the most optimistic nor the
most pessimistic.

Peter Ashford

