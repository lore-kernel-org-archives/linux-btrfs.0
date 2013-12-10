Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from hera.mpi-klsb.mpg.de ([139.19.1.49]:59977 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab3LJPqW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Dec 2013 10:46:22 -0500
Message-ID: <52A738E4.5070706@mpi-sws.org>
Date: Tue, 10 Dec 2013 16:53:08 +0100
From: Pedro Fonseca <pfonseca@mpi-sws.org>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: Warning in inode_tree_add() -- !(entry->vfs_inode.i_state & (I_WILL_FREE
 | I_FREEING)
References: <52A63302.4020301@mpi-sws.org> <20131210132529.16869.59608@ret>
In-Reply-To: <20131210132529.16869.59608@ret>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/10/13 14:25 , Chris Mason wrote:
> Quoting Pedro Fonseca (2013-12-09 16:15:46)
>> Hi,
>>
>> I've got multiple instances of warnings caused by the statement
>> "WARN_ON(!(entry->vfs_inode.i_state & (I_WILL_FREE | I_FREEING)));" in
>> inode_tree_add(). The tests were executed on the official 3.12.2 kernel.
>> Do you think it's something serious?
>
> Definitely.  You're in the autodefrag code here and an iget is replacing
> an existing inode that wasn't ready to be replaced.  What test are you
> running?
>
> -chris
>

I'm running a custom test based on fsstress and on a QEMU based VMM. Btrfs was statically compiled and the btrfs filesystem was mounted on one or two loop devices.

Bellow I've tried to annotate the last file system operations with their parameters (e.g., "filename", "[start, len]",...). Note that the log only specifies the starting 
order of the operations and note that operations on different CPUs may overlap (i.e. execute concurrently).

Let me know if you need additional information.

Pedro


* Test 1:
      CPU: 1 Op: dread (d16/f22 [233472,90112])
      CPU: 1 Op: chown  (d16/da6/c111)
      CPU: 1 Op: dwrite (d16/d21/d38/fad [299008,65536])
  CPU: 0 Op: chown (d16/da6/fe2)
  CPU: 0 Op: rmdir (d16/d21/d6d/d74 39)
  CPU: 0 Op: chown (fb)
  CPU: 0 Op: chown (d16/d21/f96)
  CPU: 0 Op: chown (d16/d21/d38/f66)
  CPU: 0 Op: btrfs_subvol_list (d16)
  CPU: 0 Op: btrfs_ioctl_filesystem_resize (+8m /mnt/dir)
      CPU: 1 Op: write (d16/d21/d6d/feb [1581147,53815])
      CPU: 1 Op: read (d16/d21/fc2 [159384,10768])
      CPU: 1 Op: dwrite (f12 [1990656,90112])
      CPU: 1 Op: dread (d16/d21/d6d/fa4 zero size)
      CPU: 1 Op: btrfs_ioctl_filesystem_defragment (d16/f22)


* Test 2:
      CPU: 1 Op: dread (d16/f22 [233472,90112])
      CPU: 1 Op: chown (d16/da6/c111)
      CPU: 1 Op: dwrite (d16/d21/d38/fad [299008,65536])
      CPU: 1 Op: write (d16/d21/d6d/feb [1581147,53815])
      CPU: 1 Op: read (d16/d21/fc2 [159384,10768])
      CPU: 1 Op: dwrite (f12 [1990656,90112])
  CPU: 0 Op: dread (d16/f22 [233472,90112])
  CPU: 0 Op: chown (d16/da6/c111)
  CPU: 0 Op: dwrite (d16/d21/d38/fad [299008,65536])
      CPU: 1 Op: dread (d16/d21/d6d/fa4 zero size)
      CPU: 1 Op: btrfs_ioctl_filesystem_defragment (d16/f22)
  CPU: 0 Op: write (d16/d21/d6d/feb [2193555,53815])
  CPU: 0 Op: read (d16/d21/fc2 [159384,10768])
  CPU: 0 Op: dwrite (f12 [688128,90112])
  CPU: 0 Op: dread (d16/d21/d6d/fa4 zero size)
  CPU: 0 Op: btrfs_ioctl_filesystem_defragment (d16/f22)


* Test 3:
      CPU: 1 Op: dread (d16/dce/fe1 zero size)
      CPU: 1 Op: stat (stat d16/da6/f117)
      CPU: 1 Op: btrfs_ioctl_filesystem_resize (-5m /mnt/dir)
      CPU: 1 Op: write (ff [956340,50300])
      CPU: 1 Op: mkdir (d16/d13b)
      CPU: 1 Op: creat (d16/d21/d6d/d74/f13c x:0 0 0)
      CPU: 1 Op: chown (d16/f116)
      CPU: 1 Op: rename ( d16/d21/d38/l7c to d16/d21/d38/l13d)
  CPU: 0 Op: dread (d16/f22 [233472,90112])
  CPU: 0 Op: chown (d16/da6/c111)
  CPU: 0 Op: dwrite (d16/d21/d38/fad [299008,65536])
  CPU: 0 Op: write (d16/d21/d6d/feb [1581147,53815])
  CPU: 0 Op: read (d16/d21/fc2 [159384,10768])
  CPU: 0 Op: dwrite (f12 [1990656,90112])
  CPU: 0 Op: dread (d16/d21/d6d/fa4 zero size)
  CPU: 0 Op: btrfs_ioctl_filesystem_defragment (d16/f22)

