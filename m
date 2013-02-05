Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:61482 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3BEJJJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Feb 2013 04:09:09 -0500
Received: by mail-we0-f181.google.com with SMTP id t44so5519418wey.12
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Feb 2013 01:09:07 -0800 (PST)
Message-ID: <B9CF5B4F4CCB49DDADED37C666FEB05A@moshePC>
From: "Moshe" <moshe@zadarastorage.com>
To: "Josef Bacik" <jbacik@fusionio.com>
Cc: <linux-btrfs@vger.kernel.org>
References: <997C7B3B2B234B0ABBD6CFA921215298@moshePC> <20130204155652.GB2275@localhost.localdomain>
In-Reply-To: <20130204155652.GB2275@localhost.localdomain>
Subject: Re: btrfs wastes disk space after snapshot deletetion.
Date: Tue, 5 Feb 2013 11:09:02 +0200
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=original
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for your reply Josef.
I want to experiment with extents size, to see how it influence size of 
extent tree. Can you point me to code that I can change to limit size of 
data extents?

Thanks,
Moshe Melnikov


-----Original Message----- 
From: Josef Bacik
Sent: Monday, February 04, 2013 5:56 PM
To: Moshe
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs wastes disk space after snapshot deletetion.

On Mon, Feb 04, 2013 at 02:08:01AM -0700, Moshe wrote:
> Hello,
>
> If I write large sequential file on snapshot, then create another 
> snapshot,
> overwrite file with small amount of data and delete first snapshot, second
> snapshot has very large data extent and only small part of it is used.
> For example if I use following sequence:
> mkfs.btrfs /dev/sdn
> mount -o noatime,nodatacow,nospace_cache /dev/sdn /mnt/b
> btrfs sub snap /mnt/b /mnt/b/snap1
> dd if=/dev/zero of=/mnt/b/snap1/t count=15000 bs=65535
> sync
> btrfs sub snap /mnt/b/snap1 /mnt/b/snap2
> dd if=/dev/zero of=/mnt/b/snap2/t seek=3 count=1 bs=2048
> sync
> btrfs sub delete /mnt/b/snap1
> btrfs-debug-tree /dev/sdn
> I see following data extents
> item 6 key (257 EXTENT_DATA 0) itemoff 3537 itemsize 53
>     extent data disk byte 1103101952 nr 194641920
>     extent data offset 0 nr 4096 ram 194641920
>     extent compression 0
> item 7 key (257 EXTENT_DATA 4096) itemoff 3484 itemsize 53
>     extent data disk byte 2086129664 nr 4096
>     extent data offset 0 nr 4096 ram 4096
>     extent compression 0
>
> In item 6: only 4096 from 194641920 are in use. Rest of space is wasted.
>
> If I defragment like: btrfs filesystem defragment /mnt/b/snap2/t it 
> release
> wasted space. But I can't use defragment because if I have few snapshots I
> need to run defragment on each snapshot and it disconnect relation between
> snapshot and create multiple copies of same data.
>
> In our test that create and delete snapshots while writing data, we end up
> with few GBs of disk space wasted.
>
> Is it possible to limit size of allocated data extents?
> Is it possible to defragment subvolume without breaking snapshots 
> relations?
> Any other idea how to recover wasted space?

This is all by design to try and limit the size of the extent tree.  Instead 
of
splitting references in the extent tree to account for the split extent we 
do it
in the file tree.  In your case it results in a lot of wasted space.  This 
is on
the list of things to fix, we will just split the references in the extent 
tree
and deal with the larger extent tree, but it's on the back burner while we 
get
things a bit more stable.  Thanks,

Josef 

