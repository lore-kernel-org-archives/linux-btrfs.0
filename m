Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:13991 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751442AbdDJITJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Apr 2017 04:19:09 -0400
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Subject: Re: BTRFS not mountable, recover won't work
To: Malte Eggers <m.eggers@campus.tu-berlin.de>, <linux-btrfs@vger.kernel.org>
References: <1491758260.15056.2.camel@campus.tu-berlin.de>
Message-ID: <60ea5a28-cdd3-84d6-1dc6-0cbcbc28755c@cn.fujitsu.com>
Date: Mon, 10 Apr 2017 16:18:59 +0800
MIME-Version: 1.0
In-Reply-To: <1491758260.15056.2.camel@campus.tu-berlin.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/10/2017 01:17 AM, Malte Eggers wrote:
> Hi,
> 
> After suspending and waking up my laptop with the external hard drive
> connected, I could no longer access the files on it. So I unmounted and
> remounted it, only to discover that I could no longer mount it.
> 
> 
> This is the error (mounting with usebackuproot, same error without):
> 
> [891667.002861] BTRFS info (device dm-0): trying to use backup root at
> mount time
> [891667.002870] BTRFS info (device dm-0): disk space caching is enabled
> [891667.002876] BTRFS info (device dm-0): has skinny extents
> [891667.016395] BTRFS error (device dm-0): parent transid verify failed
> on 108855296 wanted 32139 found 32104
> [891667.017181] BTRFS error (device dm-0): parent transid verify failed
> on 108855296 wanted 32139 found 32104
> [891667.017194] BTRFS error (device dm-0): failed to recover balance:
> -5

What about trying skip_balance mount option to skip balance?

> [891667.078829] BTRFS error (device dm-0): open_ctree failed
> 
> 
> btrfs restore and btrfs-find-root fail like this (on both debian sid
> and fedora 25):
> 
> parent transid verify failed on 108806144 wanted 32139 found 32104
> parent transid verify failed on 108806144 wanted 32139 found 32104
> parent transid verify failed on 108806144 wanted 32139 found 32104
> parent transid verify failed on 108806144 wanted 32139 found 32104
> Ignoring transid failure

Would you please paste the output of "btrfs-debug-tree -b 108806144 
/dev/dm-0" ?

> volumes.c:1645: btrfs_chunk_readonly: BUG_ON `!ce` triggered, value 1

This BUG_ON() means we can't find a corresponding chunk for given offset.

"btrfs-debug-tree -t chunk" would help, if it executes without problem.

If "btrfs-debug-tree" can't even open the fs, then "btrfs 
inspect-internal dump-super -f /dev/dm-0" would help them.

Thanks,
Qu

> btrfs(+0x530d5)[0x5634cfb180d5]
> btrfs(btrfs_chunk_readonly+0x5a)[0x5634cfb1a3b3]
> btrfs(btrfs_read_block_groups+0x1dc)[0x5634cfb0fb0c]
> btrfs(btrfs_setup_all_roots+0x336)[0x5634cfb0b158]
> btrfs(+0x4654c)[0x5634cfb0b54c]
> btrfs(open_ctree_fs_info+0xd7)[0x5634cfb0b673]
> btrfs(cmd_restore+0x339)[0x5634cfaf93dc]
> btrfs(main+0x12f)[0x5634cfadca6b]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf1)[0x7f3f7161f2b1]
> btrfs(_start+0x2a)[0x5634cfadcaaa]
> Aborted
> 
> 
> How would I go about recovering my Data?
> 
> Thanks,
> Malte
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


