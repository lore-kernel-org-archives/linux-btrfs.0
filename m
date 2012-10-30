Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55531 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2J3PqJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 11:46:09 -0400
Received: from merlin by mail1.merlins.org with local (Exim 4.77 #2)
	id 1TTE12-0006U5-Iv
	for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2012 08:46:08 -0700
Date: Tue, 30 Oct 2012 08:46:08 -0700
From: Marc MERLIN <marc@merlins.org>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Need help mounting laptop corrupted root btrfs. Kernel BUG at fs/btrfs/volumes.c:3707 - FIXED
Message-ID: <20121030154608.GA19231@merlins.org>
References: <E1TTCzR-0001nz-1p@gandalfthegreat.merlins.org> <20121030144914.GA18659@merlins.org> <20121029154713.GF8019@merlins.org> <B19885DE-6AED-4B8B-B1CA-891878B43C8C@colorremedies.com> <20121029174802.GB7796@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121030144914.GA18659@merlins.org> <20121029174802.GB7796@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 29, 2012 at 10:48:02AM -0700, Marc MERLIN wrote:
> Then, I figured, I'd try mounting all the active snapshots one per one,
> and they worked:
>
> After that, I was able to mount the root (volid 0) without a crash and
> my filesystem looks fine again.
 
Ok, I was wrong.
What happened is that my SSD is craping out and failing to write after a
certain number of uptime hours.
I just had the same problem happen again yesterday.

Turns out btrfs-zero-log does fix the problem, but because it output
the errors I saw, I thought it did nothing and forgot that I had run it.

So
1) btrfs-zero-log does fix the problem
2) my drive causes btrfs to reliably enter a state where the filesystem
becomes unmountable and crashes the kernel on the next mount.
It would be nice if the kernel wouldn't crash and refuse to mount instead
or even automatically run the equivalent of btrfs-zero-log if necessary.


Details below if that helps.

gandalfthegreat:~# btrfs-calc-size /dev/mapper/bootdsk        
Check tree block failed, want=259264512, have=12301165138967429629
Check tree block failed, want=259264512, have=12301165138967429629
Check tree block failed, want=259264512, have=7949122546735189447
Check tree block failed, want=259264512, have=12301165138967429629
Check tree block failed, want=259264512, have=12301165138967429629
read block failed check_tree_block
Calculating size of root tree
	216.00KB total size, 0.00 inline data, 1 nodes, 53 leaves, 2 levels
Calculating size of extent tree
	390.99MB total size, 0.00 inline data, 1443 nodes, 98651 leaves, 4 levels
Calculating size of csum tree
	458.78MB total size, 0.00 inline data, 1472 nodes, 115976 leaves, 4 levels
Calculatin' size of fs tree
	20.00KB total size, 0.00 inline data, 1 nodes, 4 leaves, 2 levels

gandalfthegreat:~# btrfs-find-root /dev/mapper/bootdsk
Super think's the tree root is at 147779584, chunk root 20979712
Found tree root at 147779584

gandalfthegreat:~# btrfs filesystem show 
Label: 'btrfs_pool1'  uuid: 92584fa9-85cd-4df6-b182-d32198b76a0b
	Total devices 1 FS bytes used 344.85GB
	devid    1 size 441.70GB used 441.70GB path /dev/dm-1

Label: 'btrfs_pool2'  uuid: 04071703-df6b-4022-9632-6c3aeabff206
	Total devices 1 FS bytes used 654.12GB
	devid    1 size 872.51GB used 872.51GB path /dev/dm-0

Btrfs Btrfs v0.19

gandalfthegreat:~# btrfs-zero-log /dev/mapper/bootdsk 
Check tree block failed, want=259264512, have=12301165138967429629
Check tree block failed, want=259264512, have=12301165138967429629
Check tree block failed, want=259264512, have=7949122546735189447
Check tree block failed, want=259264512, have=12301165138967429629
Check tree block failed, want=259264512, have=12301165138967429629
read block failed check_tree_block
gandalfthegreat:~#  btrfs-calc-size /dev/mapper/bootdsk      
Calculating size of root tree
	216.00KB total size, 0.00 inline data, 1 nodes, 53 leaves, 2 levels
Calculating size of extent tree
	390.99MB total size, 0.00 inline data, 1443 nodes, 98651 leaves, 4 levels
Calculating size of csum tree
	458.78MB total size, 0.00 inline data, 1472 nodes, 115976 leaves, 4 levels
Calculatin' size of fs tree
	20.00KB total size, 0.00 inline data, 1 nodes, 4 leaves, 2 levels
gandalfthegreat:~# btrfs-zero-log /dev/mapper/bootdsk 
gandalfthegreat:~#

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
