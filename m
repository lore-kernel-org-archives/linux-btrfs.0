Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42535 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbHXE2J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 00:28:09 -0400
Date: Sun, 23 Aug 2015 21:28:00 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, dsterba@suse.com, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
Message-ID: <20150824042800.GJ5602@merlins.org>
References: <55CA177D.1050004@fb.com>
 <20150812144749.GY24824@merlins.org>
 <55CB631B.2080404@fb.com>
 <20150812160936.GK29259@merlins.org>
 <55CB71E5.1070302@fb.com>
 <20150812171912.GL29259@merlins.org>
 <55D1406C.9040607@cn.fujitsu.com>
 <20150817144904.GT29259@merlins.org>
 <20150822143746.GG5602@merlins.org>
 <55DA6F06.7030605@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55DA6F06.7030605@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 24, 2015 at 09:10:30AM +0800, Qu Wenruo wrote:
> Would you please take the following output?
> 
> 1) btrfs check output
> With error message if it happens.
 
myth:~# btrfs check /dev/mapper/crypt_sdd1
Checking filesystem on /dev/mapper/crypt_sdd1
UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
checking extents
cmds-check.c:4486: add_data_backref: Assertion `back->bytes != max_size` failed.
btrfs[0x8066a73]
btrfs[0x8066aa4]
btrfs[0x8067991]
btrfs[0x806b4ab]
btrfs[0x806b9a3]
btrfs[0x806c5b2]
btrfs(cmd_check+0x1088)[0x806eddf]
btrfs(main+0x153)[0x80557c6]
/lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb753a4d3]
btrfs[0x80557ec]

> 2) btrfs check --repair output
> Full output until segfault.
 
myth:~# btrfs check --repair /dev/mapper/crypt_sdd1
enabling repair mode
Checking filesystem on /dev/mapper/crypt_sdd1
UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
checking extents
cmds-check.c:4486: add_data_backref: Assertion `back->bytes != max_size` failed.
btrfs[0x8066a73]
btrfs[0x8066aa4]
btrfs[0x8067991]
btrfs[0x806b4ab]
btrfs[0x806b9a3]
btrfs[0x806c5b2]
btrfs(cmd_check+0x1088)[0x806eddf]
btrfs(main+0x153)[0x80557c6]
/lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb75114d3]
btrfs[0x80557ec]

Strangely I'm not getting a segfault anymore.

> 3) btrfs-debug-tree output
> With assert output.
 
The full output is multi gigabyte. Do you need this and if so, do I need to
upload it somewhere and will you download the multi gigabyte file?

The errors and assert, I already posted here:

> >>Sure thing:
> >>btrfs-debug-tree /dev/mapper/crypt_sdd1 > /tmp/tree.out
> >>parent transid verify failed on 2968115101696 wanted 34855 found 39533
> >>parent transid verify failed on 2968115101696 wanted 34855 found 39533
> >>parent transid verify failed on 2968115101696 wanted 34855 found 39533
> >>parent transid verify failed on 2968115101696 wanted 34855 found 39533
> >>Ignoring transid failure
> >>parent transid verify failed on 2968115134464 wanted 34855 found 39533
> >>parent transid verify failed on 2968115134464 wanted 34855 found 39533
> >>parent transid verify failed on 2968115134464 wanted 34855 found 39533
> >>parent transid verify failed on 2968115134464 wanted 34855 found 39533
> >>Ignoring transid failure
> >>parent transid verify failed on 2968115150848 wanted 34855 found 39533
> >>parent transid verify failed on 2968115150848 wanted 34855 found 39533
> >>parent transid verify failed on 2968115150848 wanted 34855 found 39533
> >>parent transid verify failed on 2968115150848 wanted 34855 found 39533
> >>Ignoring transid failure
> >>parent transid verify failed on 2968115691520 wanted 34855 found 39533
> >>parent transid verify failed on 2968115691520 wanted 34855 found 39533
> >>parent transid verify failed on 2968115691520 wanted 34855 found 39533
> >>parent transid verify failed on 2968115691520 wanted 34855 found 39533
> >>Ignoring transid failure
> >>parent transid verify failed on 1291597152256 wanted 35830 found 39530
> >>parent transid verify failed on 1291597152256 wanted 35830 found 39530
> >>parent transid verify failed on 1291597152256 wanted 35830 found 39530
> >>parent transid verify failed on 1291597152256 wanted 35830 found 39530
> >>Ignoring transid failure
> >>parent transid verify failed on 2968116592640 wanted 34855 found 39533
> >>parent transid verify failed on 2968116592640 wanted 34855 found 39533
> >>parent transid verify failed on 2968116592640 wanted 34855 found 39533
> >>parent transid verify failed on 2968116592640 wanted 34855 found 39533
> >>Ignoring transid failure
> >>parent transid verify failed on 2968116609024 wanted 34855 found 39533
> >>parent transid verify failed on 2968116609024 wanted 34855 found 39533
> >>parent transid verify failed on 2968116609024 wanted 34855 found 39533
> >>parent transid verify failed on 2968116609024 wanted 34855 found 39533
> >>Ignoring transid failure
> >>print-tree.c:1094: btrfs_print_tree: Assertion failed.
> >>btrfs-debug-tree[0x805ce93]
> >>btrfs-debug-tree(btrfs_print_tree+0x26d)[0x805eb51]
> >>btrfs-debug-tree(btrfs_print_tree+0x279)[0x805eb5d]
> >>btrfs-debug-tree(main+0x8b5)[0x804dfb7]
> >>/lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb757c4d3]
> >>btrfs-debug-tree[0x804e221]

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
