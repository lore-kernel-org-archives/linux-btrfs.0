Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:41876 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbbEEGcP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 02:32:15 -0400
Date: Mon, 4 May 2015 23:32:15 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe David Manana <fdmanana@gmail.com>, christian@vivaldi.com
Subject: Re: 3.19.3: check tree block failed + WARNING: device 0 not present on scrub
Message-ID: <20150505063215.GA28387@merlins.org>
References: <20150502141102.GB1809@merlins.org> <20150501210013.GH13624@merlins.org> <20150429232130.GA23814@merlins.org> <20150502163010.GK13624@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150502163010.GK13624@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, May 02, 2015 at 09:30:10AM -0700, Marc MERLIN wrote:
> btrfs-debug-tree -t 2 /dev/mapper/cryptroot 2>&1 | tee /tmp/debug_2.txt
> 
> leaf 372551614464 items 125 free space 7363 generation 1911640 owner 2
> fs uuid 79a9a6c7-0955-4820-b81e-0c0681a657c1
> chunk uuid a45c7819-9aee-4999-8a39-566181679f9c
> 	item 0 key (291412238336 EXTENT_ITEM 16384) itemoff 16178 itemsize 105
> 		extent refs 5 gen 688250 flags DATA
> 		extent data backref root 23942 objectid 2028 offset 27253407744 count 1
> 		shared data backref parent 919382933504 count 1
> 		shared data backref parent 510112530432 count 1
> 		shared data backref parent 510100160512 count 1
> 		shared data backref parent 230103220224 count 1
> (...)
> 	item 123 key (291431116800 EXTENT_ITEM 4096) itemoff 10554 itemsize 37
> 		extent refs 1 gen 172150 flags DATA
> 		shared data backref parent 510226677760 count 1
> 	item 124 key (291431120896 EXTENT_ITEM 32768) itemoff 10488 itemsize 66
> 		extent refs 2 gen 334924 flags DATA
> 		extent data backref root 23942 objectid 2028 offset 85580054528 count 1
> 		shared data backref parent 504622628864 count 1
> Check tree block failed, want=612294639616, have=687330107929042309
> Check tree block failed, want=612294639616, have=687330107929042309
> Check tree block failed, want=612294639616, have=10656972372562425046
> Check tree block failed, want=612294639616, have=10656972372562425046
> Check tree block failed, want=612294639616, have=10656972372562425046
> read block failed check_tree_block
> failed to read 612294639616 in tree 2
> parent transid verify failed on 935174963200 wanted 1912353 found 1912435
> parent transid verify failed on 935174963200 wanted 1912353 found 1912435
> parent transid verify failed on 935174963200 wanted 1912353 found 1912435
> parent transid verify failed on 935174963200 wanted 1912353 found 1912435
> Ignoring transid failure
> print-tree.c:1071: btrfs_print_tree: Assertion failed.
> btrfs-debug-tree[0x410489]
> btrfs-debug-tree[0x411dbf]
> btrfs-debug-tree[0x402adb]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7fc2bc6b9b45]
> btrfs-debug-tree[0x402d85]

Ok, so I ran btrfs check --repair on it with btrfs 4.0 and got this:
http://marc.merlins.org/tmp/repair.txt

Many lines of 
root 62006 inode 454222 errors 400, nbytes wrong
root 62006 inode 454223 errors 400, nbytes wrong
root 62006 inode 9680874 errors 400, nbytes wrong
and
reset isize for dir 28434 root 394
reset isize for dir 37282 root 394
reset isize for dir 37712 root 394

Not sure when/how I picked those up, but I guess repair was able to handle
them.

But what do they mean? Does size wrong mean that I have files that got reset
with less data that they had before?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
