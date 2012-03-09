From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: btrfs_search_slot BUG...
Date: Fri, 09 Mar 2012 12:34:01 +0800
Message-ID: <4F598839.5060806@cn.fujitsu.com>
References: <CAMVG2suFfpjC_n8SpaDRLAZpWGFAPdoT+ESOkrNuoH0WoH8juQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Josef Bacik <josef@redhat.com>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMVG2suFfpjC_n8SpaDRLAZpWGFAPdoT+ESOkrNuoH0WoH8juQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 03/09/2012 12:25 PM, Daniel J Blueman wrote:
> When testing out 16KB blocks with direct I/O [1] on 3.3-rc6, we
> quickly see btrfs_search_slot returning positive numbers, popping an
> assertion [2].
> 
> Are >4KB block sizes known broken for now?
> 

Yes, exactly, the kernel side is not ready for >4K block size, but AFAIK it _is_ on going.

thanks,
liubo

> Thanks,
>   Daniel
> 
> --- [1]
> 
> mkfs.btrfs -m raid1 -d raid1 -l 16k -n 16k /dev/sda /dev/sdb
> mount /dev/sda /store && cd /store
> fio /usr/share/doc/fio/examples/iometer-file-access-server
> 
> --- [2]
> 
> kernel BUG at /home/apw/COD/linux/fs/btrfs/extent-tree.c:1481!

