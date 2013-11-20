Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from infao0809.mpi-klsb.mpg.de ([139.19.1.49]:48268 "EHLO
	hera.mpi-klsb.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3KTPWX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 10:22:23 -0500
Message-ID: <528CD3AA.9040205@mpi-sws.org>
Date: Wed, 20 Nov 2013 16:22:18 +0100
From: Pedro Fonseca <pfonseca@mpi-sws.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Btrfsck complains about "fs tree 264 refs 1 not found"
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I've been getting the error message "fs tree 264 refs 1 not found" when 
running btrfsck (v0.19) after a test case. The test case creates and 
then deletes a subvolume while concurrently creating a snapshot of the 
parent directory. This situation occurred with kernel version 3.11.1.

Here's one of the interleavings that triggers the "not found" message:
> CPU: 0 Op: write
>    CPU: 1 Op: btrfs_subvol_delete ("d16", fail)
>    CPU: 1 Op: write
>    CPU: 1 Op: btrfs_subvol_create ("d16/d13b", success)
> CPU: 0 Op: btrfs_subvol_snapshot ("d16" to 
> "d16/d21/d6d/d74/d101/d13d", success)
>    CPU: 1 Op: link
>    CPU: 1 Op: creat
>    CPU: 1 Op: btrfs_subvol_delete ("d16/d13b", success)
>    CPU: 1 Op: read
> CPU: 0 Op: dread
> CPU: 0 Op: creat

Another example that also triggered the message:
> CPU: 0 Op: dread
> CPU: 0 Op: write
> CPU: 0 Op: btrfs_subvol_snapshot ("d16" to 
> "d16/d21/d6d/d74/d101/d13d", success)
>    CPU: 1 Op: btrfs_subvol_delete ("d16", fail)
>    CPU: 1 Op: write
>    CPU: 1 Op: btrfs_subvol_create ("d16/d13b", success)
> CPU: 0 Op: dread
> CPU: 0 Op: creat
>    CPU: 1 Op: link
>    CPU: 1 Op: creat
>    CPU: 1 Op: btrfs_subvol_delete ("d16/d13b", success)
>    CPU: 1 Op: read
In this case, "btrfs_subvol_snapshot" overlapped with the 
"btrfs_subvol_create" operation but it did not overlap with the second 
"btrfs_subvol_delete".


Btrfsck output (after unmounting the FS):
> fs tree 257 refs 5
>         unresolved ref root 258 dir 256 index 10 namelen 3 name d21 
> error 600
>         unresolved ref root 262 dir 256 index 10 namelen 3 name d21 
> error 600
>         unresolved ref root 263 dir 256 index 10 namelen 3 name d21 
> error 600
>         unresolved ref root 265 dir 256 index 10 namelen 3 name d21 
> error 600
> fs tree 262 refs 3
>         unresolved ref root 263 dir 256 index 39 namelen 3 name da6 
> error 600
>         unresolved ref root 265 dir 256 index 39 namelen 3 name da6 
> error 600
> fs tree 263 refs 2
>         unresolved ref root 265 dir 256 index 43 namelen 3 name dce 
> error 600
> fs tree 264 refs 1 not found
>         unresolved ref root 265 dir 256 index 56 namelen 4 name d13b 
> error 600
> found 9924608 bytes used err is 1
> total csum bytes: 9208
> total tree bytes: 495616
> total fs tree bytes: 417792
> btree space waste bytes: 153475
> file data blocks allocated: 12365824
>  referenced 11440128
> btrfsck: Btrfs Btrfs v0.19

Let me know if you need more information.

Pedro

