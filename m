Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31930 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097Ab2KLPKh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Nov 2012 10:10:37 -0500
Date: Mon, 12 Nov 2012 23:10:36 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Sem <smith_it2000@yahoo.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfsck repair, strange df numbers and cannot write
Message-ID: <20121112151034.GE6347@gmail.com>
References: <loom.20121112T142903-705@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <loom.20121112T142903-705@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 12, 2012 at 01:34:09PM +0000, Sem wrote:
> Hi,
> 
> After doing a btrfsck --repair on my file system, it now has very strange
> numbers in df:
> 
> [root ~]# df -h | grep sdc
> /dev/sdc         15T  -64Z   16E 101% /usr/data
> 
> Prior to this it was 81% used.
> 
> I can read the files, but i cannot write a file.
> 
> Does anyone have a clue as to what is going on?
> 

Can you show here what 'btrfs fi df /usr/data' prints?

And also 'btrfs-debug-tree sdc'.

thanks,
liubo

> Any idea how to fix?
> 
> Thanks.
> 
> ---
> 
> Details:
> 
> [root ~]# uname -a
> Linux t1.localdomain 3.6.6-1.fc16.x86_64 #1 SMP Mon Nov 5 16:56:43 UTC 2012
> x86_64 x86_64 x86_64 GNU/Linux
> 
> [root ~]# btrfs --version
> Btrfs v0.20-rc1-37-g91d9eec
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
