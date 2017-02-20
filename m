Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-03.prod.phx3.secureserver.net ([184.168.200.142]:48508
        "EHLO p3nlsmtpcp01-03.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752888AbdBTOIw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 09:08:52 -0500
Date: Mon, 20 Feb 2017 19:37:37 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Large no.of extents for a single small file with a fresh RAID5
 setup
Message-ID: <20170220140737.GA27535@giis.co.in>
References: <20170218020711.GA23608@giis.co.in>
 <678a9608-8f42-119c-7fd3-69fbae31bfab@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <678a9608-8f42-119c-7fd3-69fbae31bfab@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 20, 2017 at 03:53:15PM +0800, Qu Wenruo wrote:
> 
> 
> At 02/18/2017 10:07 AM, Lakshmipathi.G wrote:
> >Hi,
> >
> >With RAID5, using 3 loop-back devices each has 4GB. On a fresh setup, created a 2mb file.
> >While checking no.of extents,it shows like:
> >
> ># ./btrfs-debugfs -f /mnt/file2m.txt
> >(257 0): ram 110592 disk 145227776 disk_size 114688
> >(257 110592): ram 4096 disk 145461248 disk_size 4096
> >(257 114688): ram 114688 disk 145342464 disk_size 118784
> >(257 229376): ram 712704 disk 145620992 disk_size 716800
> >(257 942080): ram 4096 disk 145096704 disk_size 4096
> >(257 946176): ram 737280 disk 146407424 disk_size 741376
> >(257 1683456): ram 413696 disk 147193856 disk_size 413696
> >file: /mnt/file2m.txt extents 7 disk size 2113536 logical size 2097152 ratio 0.99
> >
> >Is this expected behaviour? Is there any mount option to minimize no.of extents for
> >a smaller file?
> 
> What mount option did you use?
> Are you using compression?

Used the default mount options (mount /dev/loop0 /mnt) and compression not enabled.

> How did you create the 2m file?

Yes,this is the problem. script invokes 'dd' with 'notrunc' for each
byte. If the file is 1kb, 'dd' invoked 1024 times with notrunc.
This seems to be creating the issue.

Tried using open-fd (exec FD<>/path/f, write finally close FD) method
even this runs into possible sync and creates multiple extents.

so finally found a simple trick, created the file outside btrfs then copy it
into btrfs-mnt-pt :) this workaround helps to solve the script file-creation
issue.

> 
> This seems quite strange, if you go through normal buffered write without
> compression, 2m can easily be embedded into one file extent.
> 
> And according to extent at offset 0, 112K, 224K, its data extent is larger
> than its file extent, which means it goes through CoW.
> 
> Either you did fsync/sync between writes or you goes through Direct IO.
> 
> Anyway, the way you create the 2M file is quite important here now.
> 
> Thanks,
> Qu
> >

thanks for the help.

Cheers.
Lakshmipathi.G
