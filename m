Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:33530 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933869Ab3CZNOd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 09:14:33 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5BE1A9A067F
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 07:14:33 -0600 (MDT)
Date: Tue, 26 Mar 2013 09:14:30 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: "lonat_front@163.com" <lonat_front@163.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: compression btrfs
Message-ID: <20130326131430.GJ1955@localhost.localdomain>
References: <15c1f0b7.19e37.13da4dd5320.Coremail.lonat_front@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <15c1f0b7.19e37.13da4dd5320.Coremail.lonat_front@163.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 25, 2013 at 10:03:20PM -0600, lonat_front@163.com wrote:
> Hi everyone,
> 
>   I have used btrfs as a work partition with compression=zlib. The compression ratio is not satisfied to me. 
> 

So you probably want compress-force=zlib.  With just compress we will bail out
of the compression if the compressed pages are larger than the original size,
which means if you wrote a particular file and then copmressed it with gzip
you'd possibly see different results, but if you do compress-force=zlib then
you'll see behavior more like gzip.

>    I tracked my workloads in btrfs. The zlib module (zlib.c) seems work well: write size of each write operation in writepage function can be compressed into about 20%. 
> 
>   I suspent the workloads may impact the btrfs behavior. My workloads include really a large number of overwrite operations. 
> 
>    I briefly reviewed the code about the space reclaim in btrfs, and found the btrfs kicks the defrag off when the overwritten range is smaller than 16KB, And this is the only method of reclaiming freed extents with compression. Am I right?

It's 64k, and what do you mean reclaiming freed extents?  The freed extents will
be reclaimed once they are completely overwritten.

>    
>    So my question is if btrfs can successfully reclaim the overwritten space when the cleaner thread can not be started, such as in the case that each overwrite operation is larger than 16KB? 

Not sure what you mean by reclaim.  They won't be defragged if the overwrite is
above 64k, but if any write is less than 64k then it will defrag the whole file.
Thanks,

Josef
