Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.180]:49957 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3AXKcO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 05:32:14 -0500
Message-ID: <51010DAB.4060900@gmx.net>
Date: Thu, 24 Jan 2013 11:32:11 +0100
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Lev Vainblat <lev@zadarastorage.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Warnings on file removal after Quota exceeded error (EDQUOT)
References: <C53E5EC1712746DBA90EFED6D9BAEF52@LevPC>
In-Reply-To: <C53E5EC1712746DBA90EFED6D9BAEF52@LevPC>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24.01.2013 10:39, Lev Vainblat wrote:
> Hi all,
> 
> I executed the following simple sequence of commands:
> 
> # mount /dev/sda /mnt/btrfs
> # btrfs quota enable /mnt/btrfs/
> # btrfs subvolume create /mnt/btrfs/SV
> Create subvolume '/mnt/btrfs/SV'
> # btrfs qgroup limit 1m /mnt/btrfs/SV
> # dd if=/dev/zero of=/mnt/btrfs/SV/file bs=64x1024
> dd: writing `/mnt/btrfs/SV/file': Disk quota exceeded
> 16+0 records in
> 15+0 records out
> 983040 bytes (983 kB) copied, 0.00192474 s, 511 MB/s
> # rm /mnt/btrfs/SV/file
> 
> The file was removed, but in the kern.log I see:
> 

[snip]

> 
> Is this an expected behavior? Am I doing anything wrong here?

I can reproduce it here, will look into it. Thanks for reporting!

-Arne

> 
> Thanks,
>     -Lev. 
> 
