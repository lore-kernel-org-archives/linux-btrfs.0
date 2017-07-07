Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49972 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750892AbdGGFjy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Jul 2017 01:39:54 -0400
Date: Thu, 6 Jul 2017 22:39:53 -0700
From: Marc MERLIN <marc@merlins.org>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Josef Bacik <jbacik@fb.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, David Sterba <dsterba@suse.cz>
Subject: Re: ctree.c:197: update_ref_for_cow: BUG_ON `ret` triggered, value -5
Message-ID: <20170707053953.GB9735@merlins.org>
References: <20170627231146.GA16192@merlins.org> <20170628071026.GA21006@lufq.5F> <20170628144348.abvqowzmeveyzssn@merlins.org> <20170501170641.GG3516@merlins.org> <20170501180856.GH3516@merlins.org> <CAJCQCtR4Hr5ekASiqWn2RNju5pHz8itS91N=M29Cz8Nqx8=kqA@mail.gmail.com> <20170502032346.ayhh3n3uh5d5ekbb@merlins.org> <CAJCQCtRaeejj4b+J6M7VTsDAe7Sn4PUtBwcvHXgfLNAFe=8Jqg@mail.gmail.com> <20170502051155.igmbqcqgzi4ukefg@merlins.org> <20170707053718.GA9735@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170707053718.GA9735@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 06, 2017 at 10:37:18PM -0700, Marc MERLIN wrote:
> I'm still trying to fix my filesystem.
> It seems to work well enough since the damage is apparently localized, but
> I'd really want check --repair to actually bring it back to a working
> state, but now it's crashing
> 
> This is btrfs tools from git from a few days ago
> 
> Failed to find [4068943577088, 168, 16384]
> btrfs unable to find ref byte nr 4068943577088 parent 0 root 4  owner 1 offset 0
> Failed to find [5905106075648, 168, 16384]
> btrfs unable to find ref byte nr 5906282119168 parent 0 root 4  owner 0 offset 1
> Failed to find [21037056, 168, 16384]
> btrfs unable to find ref byte nr 21037056 parent 0 root 3  owner 1 offset 0
> Failed to find [21053440, 168, 16384]
> btrfs unable to find ref byte nr 21053440 parent 0 root 3  owner 0 offset 1
> Failed to find [21299200, 168, 16384]
> btrfs unable to find ref byte nr 21299200 parent 0 root 3  owner 0 offset 1
> Failed to find [5523931971584, 168, 16384]
> btrfs unable to find ref byte nr 5524037566464 parent 0 root 3861  owner 3 offset 0
> ctree.c:197: update_ref_for_cow: BUG_ON `ret` triggered, value -5
> btrfs(+0x113cf)[0x5651e60443cf]
> btrfs(__btrfs_cow_block+0x576)[0x5651e6045848]
> btrfs(btrfs_cow_block+0xea)[0x5651e6045dc6]
> btrfs(btrfs_search_slot+0x11df)[0x5651e604969d]
> btrfs(+0x59184)[0x5651e608c184]
> btrfs(cmd_check+0x2bd4)[0x5651e60987b3]
> btrfs(main+0x85)[0x5651e60442c3]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f34f523d2b1]
> btrfs(_start+0x2a)[0x5651e6043e3a]

Mmmh, never mind, it seems that the software raid suffered yet another
double disk failure due to some undermined flakiness in the underlying block
device cabling :-/
That would likely explain the failures here.

 
> Full log:
> enabling repair mode
> Checking filesystem on /dev/mapper/dshelf2
> UUID: 85441c59-ad11-4b25-b1fe-974f9e4acede
> checking extents
> Fixed 0 roots.
> checking free space cache
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> checksum verify failed on 3037243965440 found 179689AF wanted 82B97043
> checksum verify failed on 3037243965440 found 179689AF wanted 82B97043
> checksum verify failed on 3037243998208 found 60EA5C5B wanted 0CF5948F
> checksum verify failed on 3037243998208 found 60EA5C5B wanted 0CF5948F
> checksum verify failed on 3037244293120 found 38382803 wanted 39E4F85E
> checksum verify failed on 3037244293120 found 38382803 wanted 39E4F85E
> checksum verify failed on 3037244342272 found E84F1D8F wanted 472DA98C
> checksum verify failed on 3037244342272 found E84F1D8F wanted 472DA98C
> checksum verify failed on 3037244669952 found 2F6E4C0E wanted E00BBF09
> checksum verify failed on 3037244669952 found 2F6E4C0E wanted E00BBF09
> checksum verify failed on 3037248913408 found CE2E4AEE wanted EF22F9CA
> checksum verify failed on 3037248913408 found CE2E4AEE wanted EF22F9CA
> checksum verify failed on 3037248929792 found C989CB0E wanted E27527BC
> checksum verify failed on 3037248929792 found C989CB0E wanted E27527BC
> checksum verify failed on 3037247569920 found 05848C79 wanted EF3D5598
> checksum verify failed on 3037247569920 found 05848C79 wanted EF3D5598
> checksum verify failed on 3037247586304 found 9D1E4E39 wanted F1EC8135
> checksum verify failed on 3037247586304 found 9D1E4E39 wanted F1EC8135
> checksum verify failed on 3037247619072 found BFE40520 wanted 627DB20D
> checksum verify failed on 3037247619072 found BFE40520 wanted 627DB20D
> checksum verify failed on 3037249208320 found A6B5775F wanted B1E6C0FC
> checksum verify failed on 3037249208320 found A6B5775F wanted B1E6C0FC
> checksum verify failed on 3037252534272 found 207AD7DF wanted DE72BDF7
> checksum verify failed on 3037252534272 found 207AD7DF wanted DE72BDF7
> checksum verify failed on 3111569391616 found 3C623707 wanted D955D668
> checksum verify failed on 3111569391616 found 3C623707 wanted D955D668
> checksum verify failed on 3111569768448 found 0C129F3C wanted C509003A
> checksum verify failed on 3111569768448 found 0C129F3C wanted C509003A
> checksum verify failed on 3111569735680 found E94C9D41 wanted 55836DD2
> checksum verify failed on 3111569735680 found E94C9D41 wanted 55836DD2
> checksum verify failed on 3037253435392 found 8E124EB5 wanted A3291C35
> checksum verify failed on 3037253435392 found 8E124EB5 wanted A3291C35
> checksum verify failed on 3037253746688 found 2B6A4DCD wanted 4323B339
> checksum verify failed on 3037253746688 found 2B6A4DCD wanted 4323B339
> checksum verify failed on 3111569702912 found 1048610C wanted 9856BB43
> checksum verify failed on 3111569702912 found 1048610C wanted 9856BB43
> checksum verify failed on 3111569801216 found CD7AAF82 wanted C1DA44DF
> checksum verify failed on 3111569801216 found CD7AAF82 wanted C1DA44DF
> checksum verify failed on 3037251878912 found 86FB02F3 wanted 728772CE
> checksum verify failed on 3037251878912 found 86FB02F3 wanted 728772CE
> checksum verify failed on 3037252861952 found CFD54426 wanted E91774C0
> checksum verify failed on 3037252861952 found CFD54426 wanted E91774C0
> checksum verify failed on 3037255974912 found E3655B7C wanted 8163FDDE
> checksum verify failed on 3037255974912 found E3655B7C wanted 8163FDDE
> checksum verify failed on 3037252927488 found E7AD88A3 wanted F6BA5B10
> checksum verify failed on 3037252927488 found E7AD88A3 wanted F6BA5B10
> checksum verify failed on 3037253500928 found 514A55B2 wanted 3611CD81
> checksum verify failed on 3037253500928 found 514A55B2 wanted 3611CD81
> checksum verify failed on 3037256105984 found 41ADA274 wanted 8F7F0A0B
> checksum verify failed on 3037256105984 found 41ADA274 wanted 8F7F0A0B
> Csum didn't match
> The following tree block(s) is corrupted in tree 3861:
> 	tree block bytenr: 1710573748224, level: 1, node key: (1073956, 12, 959325)
> Try to repair the btree for root 3861
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Csum didn't match
> Failed to find [4068943577088, 168, 16384]
> btrfs unable to find ref byte nr 4068943577088 parent 0 root 4  owner 1 offset 0
> Failed to find [5905106075648, 168, 16384]
> btrfs unable to find ref byte nr 5906282119168 parent 0 root 4  owner 0 offset 1
> Failed to find [21037056, 168, 16384]
> btrfs unable to find ref byte nr 21037056 parent 0 root 3  owner 1 offset 0
> Failed to find [21053440, 168, 16384]
> btrfs unable to find ref byte nr 21053440 parent 0 root 3  owner 0 offset 1
> Failed to find [21299200, 168, 16384]
> btrfs unable to find ref byte nr 21299200 parent 0 root 3  owner 0 offset 1
> Failed to find [5523931971584, 168, 16384]
> btrfs unable to find ref byte nr 5524037566464 parent 0 root 3861  owner 3 offset 0
> ctree.c:197: update_ref_for_cow: BUG_ON `ret` triggered, value -5
> btrfs(+0x113cf)[0x5651e60443cf]
> btrfs(__btrfs_cow_block+0x576)[0x5651e6045848]
> btrfs(btrfs_cow_block+0xea)[0x5651e6045dc6]
> btrfs(btrfs_search_slot+0x11df)[0x5651e604969d]
> btrfs(+0x59184)[0x5651e608c184]
> btrfs(cmd_check+0x2bd4)[0x5651e60987b3]
> btrfs(main+0x85)[0x5651e60442c3]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f34f523d2b1]
> btrfs(_start+0x2a)[0x5651e6043e3a]
> Aborted
> gargamel:~# 
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/  

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
