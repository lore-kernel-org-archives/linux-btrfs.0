From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Saving and restoring btrfs snapshots
Date: Fri, 12 Mar 2010 19:30:01 +0100
Message-ID: <201003121930.01701.kreijack@libero.it>
References: <18f8b4a81003112300h3be917adgd183bb78719019e2@mail.gmail.com>
Reply-To: kreijack@libero.it
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <18f8b4a81003112300h3be917adgd183bb78719019e2@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Friday 12 March 2010, Pat Patterson wrote:
> Are there any plans to implement something akin to ZFS send/recv, to
> be able to create a stream representation of a snapshot and restore it
> later/somewhere else? I've spent some time trawling the mailing list
> and wiki, but I don't see anything there.

I spent a bit of time on this argument, in order to find how implement an 
efficient method to backup incrementally the data.

AFAICT "zfs send" and "zfs recv" do the same thing that tar does. They 
transform a tree (or the difference between a tree and its snapshot) to a 
stream, and vice-versa.

To transform a tree to a stream is not very interesting. 
The interesting part is how compare a tree and its snapshot. In fact a 
snapshot of a tree should a be pointer to the original tree, and when a file 
is modified, a branch of the modified part (the extens of the file, the 
directories of the path) is performed (yes I know that this a big 
simplification of the process).
The key is that the file-system knows which part of a snapshot is still equal 
to the source and which not.

If this kind of data is available to the user space, comparing a tree and it 
snapshot should be very fast. 

Reading the documentation of btrfs, it seems that associated the transaction 
there is a "version number". With this "version  number" of a directory, we 
would be able to verify the equality of two trees comparing only the root of 
the trees. This would increase the seed of two trees.

But I was never able to get this "version number". There is the ioctl command 
FS_IOC_GETVERSION, which seems to return this number. But when a directory or 
an its children is update, this number doesn't change.

I tried to hack the kernel code in order to test different "version" number: I 
tried inode->i_generation, or btrfs_inode->generation or btrfs_inode->sequence 
or btrfs_inode->{last|last_sub|logged}_trans...
But none of the above was useful for my purpose.

Even tough there is no a clear conclusion, I hope that this note may be useful 
to start to discuss on this matter. 

Regards
Goffredo
> 
> Cheers,
> 
> Pat
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
