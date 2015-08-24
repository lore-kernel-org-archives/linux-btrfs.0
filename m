Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:12323 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750968AbbHXFLc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Aug 2015 01:11:32 -0400
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
To: Marc MERLIN <marc@merlins.org>
References: <55CA177D.1050004@fb.com> <20150812144749.GY24824@merlins.org>
 <55CB631B.2080404@fb.com> <20150812160936.GK29259@merlins.org>
 <55CB71E5.1070302@fb.com> <20150812171912.GL29259@merlins.org>
 <55D1406C.9040607@cn.fujitsu.com> <20150817144904.GT29259@merlins.org>
 <20150822143746.GG5602@merlins.org> <55DA6F06.7030605@cn.fujitsu.com>
 <20150824042800.GJ5602@merlins.org>
CC: Josef Bacik <jbacik@fb.com>, <dsterba@suse.com>, <clm@fb.com>,
        <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55DAA77E.10105@cn.fujitsu.com>
Date: Mon, 24 Aug 2015 13:11:26 +0800
MIME-Version: 1.0
In-Reply-To: <20150824042800.GJ5602@merlins.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Marc MERLIN wrote on 2015/08/23 21:28 -0700:
> On Mon, Aug 24, 2015 at 09:10:30AM +0800, Qu Wenruo wrote:
>> Would you please take the following output?
>>
>> 1) btrfs check output
>> With error message if it happens.
>
> myth:~# btrfs check /dev/mapper/crypt_sdd1
> Checking filesystem on /dev/mapper/crypt_sdd1
> UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
> checking extents
> cmds-check.c:4486: add_data_backref: Assertion `back->bytes != max_size` failed.
> btrfs[0x8066a73]
> btrfs[0x8066aa4]
> btrfs[0x8067991]
> btrfs[0x806b4ab]
> btrfs[0x806b9a3]
> btrfs[0x806c5b2]
> btrfs(cmd_check+0x1088)[0x806eddf]
> btrfs(main+0x153)[0x80557c6]
> /lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb753a4d3]
> btrfs[0x80557ec]
>
>> 2) btrfs check --repair output
>> Full output until segfault.
>
> myth:~# btrfs check --repair /dev/mapper/crypt_sdd1
> enabling repair mode
> Checking filesystem on /dev/mapper/crypt_sdd1
> UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
> checking extents
> cmds-check.c:4486: add_data_backref: Assertion `back->bytes != max_size` failed.
> btrfs[0x8066a73]
> btrfs[0x8066aa4]
> btrfs[0x8067991]
> btrfs[0x806b4ab]
> btrfs[0x806b9a3]
> btrfs[0x806c5b2]
> btrfs(cmd_check+0x1088)[0x806eddf]
> btrfs(main+0x153)[0x80557c6]
> /lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb75114d3]
> btrfs[0x80557ec]
>
> Strangely I'm not getting a segfault anymore.

It seems that the tree block's backref has something wrong.

>
>> 3) btrfs-debug-tree output
>> With assert output.
>
> The full output is multi gigabyte. Do you need this and if so, do I need to
> upload it somewhere and will you download the multi gigabyte file?
>
> The errors and assert, I already posted here:
>
>>>> Sure thing:
>>>> btrfs-debug-tree /dev/mapper/crypt_sdd1 > /tmp/tree.out
>>>> parent transid verify failed on 2968115101696 wanted 34855 found 39533
>>>> parent transid verify failed on 2968115101696 wanted 34855 found 39533
>>>> parent transid verify failed on 2968115101696 wanted 34855 found 39533
>>>> parent transid verify failed on 2968115101696 wanted 34855 found 39533
>>>> Ignoring transid failure
>>>> parent transid verify failed on 2968115134464 wanted 34855 found 39533
>>>> parent transid verify failed on 2968115134464 wanted 34855 found 39533
>>>> parent transid verify failed on 2968115134464 wanted 34855 found 39533
>>>> parent transid verify failed on 2968115134464 wanted 34855 found 39533
>>>> Ignoring transid failure
>>>> parent transid verify failed on 2968115150848 wanted 34855 found 39533
>>>> parent transid verify failed on 2968115150848 wanted 34855 found 39533
>>>> parent transid verify failed on 2968115150848 wanted 34855 found 39533
>>>> parent transid verify failed on 2968115150848 wanted 34855 found 39533
>>>> Ignoring transid failure
>>>> parent transid verify failed on 2968115691520 wanted 34855 found 39533
>>>> parent transid verify failed on 2968115691520 wanted 34855 found 39533
>>>> parent transid verify failed on 2968115691520 wanted 34855 found 39533
>>>> parent transid verify failed on 2968115691520 wanted 34855 found 39533
>>>> Ignoring transid failure
>>>> parent transid verify failed on 1291597152256 wanted 35830 found 39530
>>>> parent transid verify failed on 1291597152256 wanted 35830 found 39530
>>>> parent transid verify failed on 1291597152256 wanted 35830 found 39530
>>>> parent transid verify failed on 1291597152256 wanted 35830 found 39530
>>>> Ignoring transid failure
>>>> parent transid verify failed on 2968116592640 wanted 34855 found 39533
>>>> parent transid verify failed on 2968116592640 wanted 34855 found 39533
>>>> parent transid verify failed on 2968116592640 wanted 34855 found 39533
>>>> parent transid verify failed on 2968116592640 wanted 34855 found 39533
>>>> Ignoring transid failure
>>>> parent transid verify failed on 2968116609024 wanted 34855 found 39533
>>>> parent transid verify failed on 2968116609024 wanted 34855 found 39533
>>>> parent transid verify failed on 2968116609024 wanted 34855 found 39533
>>>> parent transid verify failed on 2968116609024 wanted 34855 found 39533
>>>> Ignoring transid failure
>>>> print-tree.c:1094: btrfs_print_tree: Assertion failed.
>>>> btrfs-debug-tree[0x805ce93]
>>>> btrfs-debug-tree(btrfs_print_tree+0x26d)[0x805eb51]
>>>> btrfs-debug-tree(btrfs_print_tree+0x279)[0x805eb5d]
>>>> btrfs-debug-tree(main+0x8b5)[0x804dfb7]
>>>> /lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb757c4d3]
>>>> btrfs-debug-tree[0x804e221]
Oh, sorry for ignoring the existing output.

And the last assert info should be enough. No need to upload it.

The b-tree seems to be hugely damaged, or at least one leaf tree block 
is referred by higher level node.
It maybe something wrong happened when level of a btree is reduced.

Normally, I have no idea on how to fix such huge problem in btrfsck.
But there is still some clue.

In your debug-tree output, the transid difference between wanted and 
found is quite huge. I suppose there would be a much much newer root 
tree, but not recorded in superblock.

So, my last bet will be, using "btrfs-find-root -a" to find the root 
with highest generation, and use the new root to exec "btrfsck -b 
<bytenr of highest gen root>".

The latest btrfs-find-root would output possible tree root by descending 
order of its generation. You'll find proper bytenr quite easy.
But be prepared as "btrfs-find-root -a" will iterate all metadata space, 
so it will takes a long long time to finish.
And until it scanned all the space, it won't output anything.

Thanks,
Qu
>
> Thanks,
> Marc
>
