From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Is compression mode activated?
Date: Wed, 08 Apr 2009 12:46:53 -0400
Message-ID: <1239209213.28688.2.camel@think.oraclecorp.com>
References: <d853ebb60904080304o11101887kdbbcd4626ebb9c96@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Siddhartha Swaroop <siddhartha.swaroop@greenturtles.in>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <d853ebb60904080304o11101887kdbbcd4626ebb9c96@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2009-04-08 at 15:34 +0530, Siddhartha Swaroop wrote:
> Hello,
> 
> I'm Siddhartha Swaroop from Green Turtle Technologies.
> As you mentioned in mailing list, am  trying to write ioctl that
> reports on the actual size of the
> compressed file. So before starting to write I have to enable compress
> mode and check manually how much size is compressed.
> 
> For that this is the test case what I did 
> 
> Test case:
> 
> $ du -h file
> 116K    file
> 
> $ mount -t btrfs /dev/sda4 /mnt/
> 
> $ cp file /mnt/
> 
> $ du -h /mnt/file 
> 108K    /mnt/file
> 
> $ du -h install.log
> 48K     install.log
>  
> $ cp install.log /mnt/
> 
> $ du -h /mnt/install.log 
> 44K     /mnt/install.log
> 
> $ rm /mnt/file
> 
> $ rm /mnt/install.log
> 
> $ umount /mnt
> 
> $ mount -t btrfs -o compress /dev/sda4 /mnt
> 
> $ cp file /mnt/
> 
> $ du -h /mnt/file 
> 108K    /mnt/file
> 
> $ cp install.log /mnt/
> 
> $ du -h /mnt/install.log 
> 44K     /mnt/install.log
> 
> So now my question is 
> 1>whether compress mode is activated in my system or not?

If you mounted -o compress, it is activated.
> 
> 2>If yes then what is the use of this compress mode because the size
> of the file is same as before compress mode is activated in btrfs.
> 
The idea behind transparent compression is that it is transparent ;)
The inode fields from stat need to reflect the uncompressed size,
because userland applications expect them to work a certain way.

In order to find the actual space used, you need to walk the btrfs btree
and count the extents.

df is another good way to check, since df shows the actual blocks
allocated.

-chris


