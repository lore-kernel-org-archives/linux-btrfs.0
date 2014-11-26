Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-03v.sys.comcast.net ([96.114.154.162]:58290 "EHLO
	resqmta-po-03v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753794AbaKZXSa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 18:18:30 -0500
Message-ID: <54765FC2.2050309@pobox.com>
Date: Wed, 26 Nov 2014 15:18:26 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Subject: Re: Can't cp --reflink files on a Ext4-converted FS w/o checksums
References: <20141127005527.42a7fe59@natsu>
In-Reply-To: <20141127005527.42a7fe59@natsu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/26/2014 11:55 AM, Roman Mamedov wrote:
> Is there really a good reason to stop these files without checksums from being
> cloneable? It's not like they have the noCoW attribute, so I'd assume any new
> write to these files would cause a CoW and proper checksums for all new blocks
> anyways.

The problem seems to be that you are trying to clone a NODATASUM file to 
a file that would have data checsums. The resulting file _might_ then 
end up with some extents with, and others without, checksums if that 
target file were modified.

So you _could_ reflink the file but you'd have to do it to another file 
with no data checksums -- which basically means a NOCOW file, or 
mounting with nodatasum while you do the reflink, but now you have more 
problem files.

linux/fs/btrfs/ioctl.c @ ~ line 2930
         /* don't make the dst file partly checksummed */
         if ((BTRFS_I(src)->flags & BTRFS_INODE_NODATASUM) !=
             (BTRFS_I(dst)->flags & BTRFS_INODE_NODATASUM)) {
                 ret = -EINVAL;
                 goto out_unlock;
         }

Basically if the system allowed you to reflink from a no-data-sum to a 
data-sum file the results would be instantly unreadable for failing 
every single data checksum test. That or the entire checksum system 
would have to be advisory instead of functional.

So yes, there is a good reason.


David Foster Wallace famously said "act in haste, repent in leasure". 
You kind-of shot yourself in the foot while attempting to save time. You 
promised yourself that you didn't need the checksums.

Now at this point I'm going to make a few guesses...

I don't see _anywhere_ in the kernel source or btrfs-progs where 
BTRFS_INODE_NODATASUM is explicitly cleared from any inode ever. It 
might be implicitly cleared somewhere but I couldn't find it. So all 
those unsummed files are probably unsummed for life.

I also don't see anything in the code that says "this ioctl will create 
the checksums for the selected file" so you may have to do the copy you 
tried to avoid.

Sorry man...

If you haven't done much with the file system yet, you might want to 
reverse the conversion and do it again.

Otherwise, you will want to copy the files long-hand, possibly in 
batches if you are more than 50% full on disk space.

On the bright side...

This would be the perfect moment to think about your backup/snapshot 
scheme. I always have a /whatever (e.g. /__System for a root partition) 
as my default subvolume that I normally mount. When I do my backups I 
mount -o subvol=/ /dev/whathaveyou /mnt/maintenance and then do my 
snapshots in /mnt/maintenance. That way every file in my N snapshots 
doesn't show up in the output of locate N+1 times. (e.g. this lets me 
"hide" my local snapshots/backups from normal operations)

Also, now would be the perfect time to add compression to your default 
regime. Compressing the files only happens on write and so using 
compression involves a copy anyway.

-- Rob.
