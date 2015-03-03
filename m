Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 162-144-52-249.unifiedlayer.com ([162.144.52.249]:57112 "EHLO
	cl65.servermonkeys.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbbCCPPL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Mar 2015 10:15:11 -0500
Message-ID: <54F5CFF7.1090604@richgannon.net>
Date: Tue, 03 Mar 2015 10:15:03 -0500
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

Hi,

I have applied the patch but once I start making the kernel, the kernel 
oopses and the process freezes.  I have removed all of the btrfs mounts 
from /etc/fstab and tried with no btrfs filesystems mounted.  I still 
get the error upon trying to build the kernel!  I don't understand how 
or why that's happening.  I tried booting up an old, previously 
known-working kernel and the server has not come back up yet.  I don't 
have physical access to it until tomorrow so this may wait until then.

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

