From: redneb@gmx.com
Subject: bug: cannot delete an empty directory (the directory is NOT a
 subvolume)
Date: Fri, 5 Nov 2010 20:27:14 -0400
Message-ID: <20101106002714.GA7762@epicurus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I think this can be best explained by an example. Suppose that you have 
the following setup:

         mkfs.btrfs /dev/somedisk
         mount /dev/somedisk /mnt/btrfs
         mkdir /mnt/btrfs/aaa
         btrfs subvolume snapshot /mnt/btrfs /mnt/btrfs/aaa/bbb

So /mnt/btrfs/aaa is a ordinary directory containaing /mnt/btrfs/aaa/bbb 
which is a subvolume. The latter contains /mnt/btrfs/aaa/bbb/aaa which 
is a directory. This directory is empty (ls -a does not find anything) 
but it cannot be deleted:

# rmdir /mnt/btrfs/aaa/bbb/aaa
rmdir: failed to remove `/mnt/btrfs/aaa/bbb/aaa': Directory not empty

As it turns out, it contains a "ghost" directory named bbb that is not 
reported by ls -a but can be deleted by rmdir:

# rmdir /mnt/btrfs/aaa/bbb/aaa/bbb
(no errors, status code 0)

Now we can also delete /mnt/btrfs/aaa/bbb/aaa:

# rmdir /mnt/btrfs/aaa/bbb/aaa
(no errors, status code 0)
