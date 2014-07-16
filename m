Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21753 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbaGPHyh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 03:54:37 -0400
Date: Wed, 16 Jul 2014 15:53:48 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Why does btrfs defrag work worse than making a copy of a file?
Message-ID: <20140716075345.GB29931@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <53C59A66.7010107@informatik.uni-bonn.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53C59A66.7010107@informatik.uni-bonn.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 15, 2014 at 11:17:26PM +0200, Sebastian Ochmann wrote:
> Hello,
> 
> I have a VirtualBox hard drive image which is quite fragmented even
> after very light use; it is 1.6 GB in size and has around 5000
> fragments (I'm using "filefrag" to determine the number of
> fragments). Doing a "btrfs fi defrag -f image.vdi" reduced the
> number of fragments to 3749. Even doing a "btrfs fi defrag -f -t 1
> image.vdi" which should make sure every extent is rewritten
> (according to the btrfs-progs 3.14.2 manpage) does not yield any
> better result and seems to return immediately. Copying the file,
> however, yields a copy which has only 5 fragments (simply doing a cp
> image.vdi image2.vdi; sync; filefrag image2.vdi).
> 
> What do I have to do to defrag the file to the minimal number of
> fragments possible? Am I missing something?

So usually btrfs thinks of an extent whose size is bigger than 256K as a big
enough extent.

Another possible reason is that there is something wrong with btrfs_fiemap which
gives filefrag' a wrong output.

Would you please show us the 'filefrag -v' output?

thanks,
-liubo

> 
> Kernel version 3.15.5, btrfs progs 3.14.2, Arch Linux.
> 
> Best regards,
> Sebastian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
