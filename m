Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 162-144-52-249.unifiedlayer.com ([162.144.52.249]:37292 "EHLO
	cl65.servermonkeys.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbbCDUyP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Mar 2015 15:54:15 -0500
Message-ID: <54F770F3.30909@richgannon.net>
Date: Wed, 04 Mar 2015 15:54:11 -0500
From: Rich Gannon <rich@richgannon.net>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: rsync causes kernel oops
References: <4rlpa6pkab6a7pjvpdi76xrl.1425364136955@email.android.com> <20150303064437.GD30093@localhost.localdomain>
In-Reply-To: <20150303064437.GD30093@localhost.localdomain>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu,

I was able to use 3.18.1 to compile the revised 3.18.8 kernel with 
GRSecurity and your patch.

I ran "emerge --sync" and it immediately returned "Killed".

Here's a link to the full dmesg output:

http://richgannon.net/btrfs.dmesg.txt

Again, this may be unrelated completely to the RAID-10 filesystem as the 
filesystem that emerge should be using (/usr/portage) is on a seperate 
Btrfs filesystem on a separate partition.

Rich

On 03/03/2015 01:44 AM, Liu Bo wrote:
> On Tue, Mar 03, 2015 at 01:28:56AM -0500, Rich Gannon wrote:
>>      
>>
>> I should also mention that this is repeatable 100% of the time on this server (only 32-bit box I have) and once the trace pops up in dmesg, the filesystem will not unmount. It just hangs any process trying to unmount it. I can not even reboot/shutdown gracefully.
> Could you please try this and post the dmesg log if you can compile your own kernel?
>
> diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
> index 29850d4..148def3 100644
> --- a/fs/btrfs/extent_io.c
> +++ b/fs/btrfs/extent_io.c
> @@ -2964,6 +2964,9 @@ static int __do_readpage(struct extent_io_tree
> *tree,
>   			memset(userpage + pg_offset, 0, iosize);
>   			flush_dcache_page(page);
>   			kunmap_atomic(userpage);
> +
> +			printk(KERN_ERR "FINDING MEEEEEEEE! cur=%llu iosize=%d sum=%llu end=%llu last_byte=%llu\n", cur, (int)iosize, (cur+iosize-1), end, last_byte);
> +
>   			set_extent_uptodate(tree, cur, cur + iosize - 1,
>   					    &cached, GFP_NOFS);
>   			if (!parent_locked)
>
> Thanks,
>
> -liubo

