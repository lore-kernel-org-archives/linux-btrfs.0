From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [Btrfs-devel] cloning file data
Date: Fri, 25 Apr 2008 09:41:35 -0400
Message-ID: <200804250941.35343.chris.mason@oracle.com>
References: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Cc: Sage Weil <sage@newdream.net>, linux-btrfs@vger.kernel.org
To: btrfs-devel@oss.oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0804241352130.23551@cobra.newdream.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 24 April 2008, Sage Weil wrote:
> Hi-
>
> I'm working on a clone ioctl that will quickly and efficiently duplicate
> the contents of a file, e.g.

Very cool.  I'd actually loved to see this wrapped into a program that will 
cow a directory tree.  Basically the same as cp -al, but with cow instead of 
linking.

>
> int main(int argc, const char **argv)
> {
>   int in = open(argv[1], O_RDONLY);
>   int out = open(argv[2], O_CREAT|O_TRUNC|O_WRONLY, 0644);
>   ioctl(out, BTRFS_IOC_CLONE, in);
>   close(in);
>   close(out);
>   return 0;
> }
>
> I've probably got the locking order a bit wrong, lots of error handling is
> missing, and I suspect there's a cleaner way to do the target inode size
> update, but it behaves well enough in my (limited :) testing.
>
> Oh, and I wasn't certain the 'offset' in file_extent_item could be safely
> ignored when duplicating the extent reference.  My assumption was that it
> is orthogonal to extent allocation and isn't related to the backref.
> However, btrfs_insert_file_extent() always set offset=0.  I'm guessing I
> need to add an argument there and fix up the other callers?
>
Yes, you need to preserve the offset.  There's only one place right now that 
sets a non-zero offset and it inserts the extent by hand for other reasons 
(if you're brave, file.c:btrfs_drop_extents)

The reason file extents have an offset field is to allow COW without 
read/modify/write.  Picture something like this:

# create a single 100MB extent in file foo
dd if=/dev/zero of=foo bs=1M count=100
sync

# write into the middle
dd if=/dev/zero of=foo bs=4k count=1 seek=100 conv=notrunc
sync

We've written into the middle of that 100MB extent, and we need to do COW.  
One option is to read the whole thing, change 4k and write it all back.  
Instead, btrfs does something like this (+/- off by need more coffee errors):

file pos = 0 -> [ old extent, offset = 0, num_bytes = 400k ]
file pos = 409600 -> [ new 4k extent, offset = 0, num_bytes = 4k ]
file pos = 413696 -> [ old extent, offset = 413696, num_bytes = 100MB - 404k]

An extra reference is taken on the old extent to reflect that we're pointing 
to it twice.

> Anyway, any comments or suggestions (on the interface or implemantation)
> are welcome.. :)
>
By taking the inode mutex, you protect against file_write and truncates 
changing the file.  But, we also need to prevent mmaps from changing the file 
pages as well.  What you want to do lock all the file bytes in the extent 
tree:

lock_extent(&BTRFS_I(src_inode)->io_tree, 0, (u64)-1, GFP_NOFS);

But unfortunately, the code to fill delayed allocation takes that same lock.  
So you need to loop a bit:

while(1) {
    filemap_write_and_wait(src_inode);
    lock_extent()
    if (BTRFS_I(src_inode)->delalloc_bytes == 0)
        break;
    unlock_extent()
}

That should keep you from racing with btrfs_page_mkwrite()

-chris
