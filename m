Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-08v.sys.comcast.net ([96.114.154.167]:56565 "EHLO
	resqmta-po-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750793AbaK0AA1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 19:00:27 -0500
Message-ID: <54766997.1040101@pobox.com>
Date: Wed, 26 Nov 2014 16:00:23 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Can't cp --reflink files on a Ext4-converted FS w/o checksums
References: <20141127005527.42a7fe59@natsu>	<54765FC2.2050309@pobox.com> <20141127043337.198d6084@natsu>
In-Reply-To: <20141127043337.198d6084@natsu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/26/2014 03:33 PM, Roman Mamedov wrote:
> On Wed, 26 Nov 2014 15:18:26 -0800
> Robert White <rwhite@pobox.com> wrote:
>
>> So you _could_ reflink the file but you'd have to do it to another file
>> with no data checksums -- which basically means a NOCOW file, or
>> mounting with nodatasum while you do the reflink, but now you have more
>> problem files.
>
> Bingo!!! A cp --reflink to a destination that's been made chattr +C prior to
> that, works perfectly.
>
> My goal was to convert regular top-level directories into subvolumes (for
> further snapshotting). With that trick, I've been able to do that now w/o
> issues.
>
> $ mv Music Music.orig
> $ sudo btrfs sub create Music
> Create subvolume './Music'
> $ sudo chattr +C Music
> $ sudo cp -a --reflink Music.orig/* Music/
> $
>
> Finished with no rewriting necessary. After that I recursively-removed the +C
> attribute from all newly reflinked files, and cp --reflink as well as
> snapshotting of those works fine.
>
> Thanks for the idea. :)
>

Uh... you may _still_ have no checksums on any of those data extents. 
They are not going to come back until you write them to a normal file 
with a normal copy. So you may be lacking most of the data validation 
features of this filesystem. For instance you can, and always could, 
snapshot a NODATACOW/NODATASUM file just fine (I call it 1COW mode).

Setting NODATACOW sets NODATASUM...

Clearing NODATACOW does _not_ clear NODATASUM (at least not on a 
non-empty file) as near as I can tell, so that directory hierarchy and 
its subsequent snapshots is likely "less safe" than you think.

You might want to go experiment. Make another new subvol (or at least a 
directory in a directory/root/subvol that never had the +C attribute 
set) and see if you can cp --reflink any of these files into that 
subdirectory without repeating the +C trick.

Basically scrubbing and mirroring and "sending" your Music folder is an 
unprotected and unverified operation the way you've done this (if my 
reading of the code is correct).

You _really_ might be better off spending the time and doing the copy to 
a normal directory.

For instance without checksums if you "btrfs scrub" your volume it will 
read the file but it can't know if the file got corrupted, it can only 
tell you if you if the disk read completed without error. (there's a 
whole degenerate/simplified path in the code for scrubbing un-summed files).

So seriously, you might be "Saving yourself time" right into a future 
data loss.

Take this as a "you've been warned".
