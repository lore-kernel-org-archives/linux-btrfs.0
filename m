From: buff@cs.boisestate.edu
Subject: exposing checksums to user-space programs
Date: Mon, 27 Jun 2011 10:47:57 -0600
Message-ID: <4404.1309193277@wave.linux.bogus>
Cc: buff@cs.boisestate.edu
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Folks (please cc: any replies to me),

I have modified GNU Make to use checksums rather than
timestamps. I would like the operating system and/or
filesystem to compute and provide the checksums, because it
can safely cache them.

Since btrfs checksums its files, I am trying to transfer its
checksums to user space. I believe I saw a thread where
Chris Mason said he didn't want to expose checksums, but
then I found a patch that sounds like it does what I want:

    http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg01182.html

In the thread, Chris said he would take the patch, but it
evidently never made it to distribution.  I applied the
patch to kernel 2.6.30.8, which is old but available on one
of my expendable laptops. I created a btrfs filesystem on a
USB thumb drive and copied a file to it. Then, I cobbled
together this example user-space program:

    http://cs.boisestate.edu/~buff/files/trycsum.c

which produces this output:

    spruce$ sudo mount /mnt/sdb1
    spruce$ trycsum /mnt/sdb1/yum.list 
    File /mnt/sdb1/yum.list has 1 extents:
    #	Logical          Physical         Length           Flags
    0:	0000000000000000 0000000000c00000 000000000015b000 0001
    sizeof(args)=420
    size=0
    csum[0]=0000007b
    spruce$ 

The "size=0" tells me the file's one extent has no
checksum. However:

    spruce$ sudo btrfs-debug-tree  /dev/sdb1 | grep -i csum
	    item 0 key (18446744073709551606 EXTENT_CSUM 12582912) itemoff 2607 itemsize 1388
		    extent csum item
    spruce$ 

suggests it has a checksum.

I traced the function defined in the patch, with printk()
calls. It seemed be accepting and processing its arguments
correctly.

I'm not a kernel-hacking expert, but I was hoping someone
could tell me what I'm doing wrong or give me some
direction. Thanks!

-- Jim

PS: I think I also noticed that a small file has no
checksum, and a big file has no checksum until after a
umount/mount. Is this true?
