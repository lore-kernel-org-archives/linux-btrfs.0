Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:37226 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbbGRLfv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Jul 2015 07:35:51 -0400
Date: Sat, 18 Jul 2015 19:35:31 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Strange data backref offset?
Message-ID: <20150718113412.GA11450@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <55A86AA8.6010404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55A86AA8.6010404@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 17, 2015 at 10:38:32AM +0800, Qu Wenruo wrote:
> Hi all,
> 
> While I'm developing a new btrfs inband dedup mechanism, I found btrfsck and
> kernel doing strange behavior for clone.
> 
> [Reproducer]
> # mount /dev/sdc -t btrfs /mnt/test
> # dd if=/dev/zero of=/mnt/test/file1 bs=4K count=4
> # sync
> # ~/xfstests/src/cloner -s 4096 -l 4096 /mnt/test/file1 /mnt/test/file2
> # sync
> 
> Then btrfs-debug-tree gives quite strange result on the data backref:
> ------
> <EXTENT TREE>
>         item 4 key (12845056 EXTENT_ITEM 16384) itemoff 16047 itemsize 111
>                 extent refs 3 gen 6 flags DATA
>                 extent data backref root 5 objectid 257 offset 0 count 1
>                 extent data backref root 5 objectid 258 offset
> 18446744073709547520 count 1
> 
> <FS TREE>
>         item 8 key (257 EXTENT_DATA 0) itemoff 15743 itemsize 53
>                 extent data disk byte 12845056 nr 16384
>                 extent data offset 0 nr 16384 ram 16384
>                 extent compression 0
>         item 9 key (257 EXTENT_DATA 16384) itemoff 15690 itemsize 53
>                 extent data disk byte 12845056 nr 16384
>                 extent data offset 4096 nr 4096 ram 16384
>                 extent compression 0
> ------
> 
> The offset is file extent's key.offset - file exntent's offset,
> Which is 0 - 4096, causing the overflow result.
> 
> Kernel and fsck all uses that behavior, so fsck can pass the strange thing.
> 
> But shouldn't the offset in data backref matches with the key.offset of the
> file extent?
> 
> And I'm quite sure the change of behavior can hugely break the fsck and
> kernel, but I'm wondering is this a known BUG or feature, and will it be
> handled?

Also found this before, one of the benefits is to save metadata in extent
tree, that is, if we overwrite inside an extent, the extent ref count
increases to 2 since both use (key.offset - extent_offset).

0k                  12k
|-------------------|
     |--------|
     4k       8k

one EXTENT_DATA item is 0k and the other one is 8k, the corresponding
refs will be (0k - 0) and (8k - 8k).

It's a format change so it won't be easy to make a change.  I'd prefer a
workaround on clone side.

Thanks,

-liubo
