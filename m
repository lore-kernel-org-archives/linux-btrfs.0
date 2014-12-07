Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i2.italiaonline.it ([212.48.25.202]:57932 "EHLO
	smtp-32.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753227AbaLGTSN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 14:18:13 -0500
Message-ID: <5484A83A.5090109@inwind.it>
Date: Sun, 07 Dec 2014 20:19:22 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>
CC: Martin Steigerwald <Martin@lichtvoll.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com> <44320137.fRRuR6EFMP@merkaba>
In-Reply-To: <44320137.fRRuR6EFMP@merkaba>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/07/2014 04:33 PM, Martin Steigerwald wrote:
> Hi Shriramana!
> 
> Am Sonntag, 7. Dezember 2014, 20:45:59 schrieb Shriramana Sharma:
>>> IIUC:
>>> 
>>> 1) btrfs fi df already shows the alloc-ed space and the space 
>>> used out of that.
>>> 
>>> 2) Despite snapshots, CoW and compression, the tree knows how 
>>> many extents of data and metadata there are, and how many bytes 
>>> on disk these occcupy, no matter what is the total (uncompressed,
>>> "unsnapshotted") size of all the directories and files on the
>>> disk.
>>> 
>>> So this means that btrfs fi df actually shows the real on-disk 
>>> usage. In this case, why do we hear people saying it's not 
>>> possible to know the actual on-disk usage and when a 
>>> btrfs-formatted disk (or partition) will go out of space?
> I never read that the actual disk usage is unknown. But I read that 
> the actual what is free is unknown. And there are several reasons
> for that:
> 
> 1) On a compressed filesystem you cannot know, but only estimate the 
> compression ratio for future data.
> 
> 2) On a compressed filesystem you can choose to have parts of it 
> uncompressed by file / directory attributes, I think. BTRFS can´t 
> know how much of the future data you are going to store compressed
> or uncompressed.
> 
> 3) From what I gathered it is planned to allow different raid / 
> redundancy levels for different subvolumes. BTRFS can´t know 
> beforehand where applications request to save future data, i.e. in 
> which subvolume.


3.1) even in the case of a single disk filesystem, data and metadata 
have different profiles: the data chunk doesn't have any redundancy, 
so 64kb of data consume 64kb of disk space. The metadata chunks 
usually are stored as DUP, so 64kb of metadata consume 128kb on disk.
Moreover you have to consider that small files are stored in metadata
chunk. This means that for big file the disk space consumed is equal
to the data size, but for small file this is doubled.

Going back to your request, to be more clear I used the following terms:
1- disk space used: the space used on the disk
2- size of data: the size of the data stored on the disks
3- disk free space: the unused space of the disk
4- free space: the size of data that the system is able to contain

The value 1,2,3 are known. Which is unknown is the point 4. In
the past I posted some patch which try to estimate the point 4 as:

                                 size_of_data 
free_space = disk_free_space * -----------------
                                disk_space_used

This estimation assumes that the ratio size_of_data/disk_space_used
is constant. But for the point above this assumption may be wrong.

In conclusion, the disk usage is well known; which is unknown is
the space that is available to the user (who is uninterested to
all the details inside a filesystem). The best that is doable
is an estimation like the above one.
BR
Goffredo

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
