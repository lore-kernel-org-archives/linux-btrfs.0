From: Liu Bo <liubo2009@cn.fujitsu.com>
Subject: Re: [3.4-rc1] attempt to access beyond end of device and livelock
Date: Sun, 08 Apr 2012 16:49:15 +0800
Message-ID: <4F81510B.60406@cn.fujitsu.com>
References: <CAMVG2ss5WzwhgPunD5greRii1HFuEYt1TMQwxgUNitrpHtguVA@mail.gmail.com> <CAMVG2st4VPbujSY1hH+VjbR1gxCR0ZEGznrObYMWnpgo++Ynug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Daniel J Blueman <daniel@quora.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAMVG2st4VPbujSY1hH+VjbR1gxCR0ZEGznrObYMWnpgo++Ynug@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/06/2012 07:36 PM, Daniel J Blueman wrote:
> Hi Josef, Chris,
> 
> When testing BTRFS with RAID 0 metadata on linux-3.4-rc1, we see
> discard ranges exceeding the end of the block device [1], potentially
> causing dataloss; when this occurs, filesystem writeback becomes
> catatonic due to continual resubmission.
> 
> Simply mounting with discard a raid0 metadata filesystem and copying
> some data in [2] provokes the issue.
> 
> Thanks,
>  Daniel
> 
> --- [1]
> 
> attempt to access beyond end of device
> ram0: rw=129, want=8452072, limit=4096000
> ...
> 
> --- [2]
> 
> modprobe brd rd_size=2048000 (or boot with ramdisk_size=2048000)
> mkfs.btrfs -m raid0 /dev/ram0 /dev/ram1
> mount /dev/ram0 /mnt -o discard
> cd /mnt && tar -xvzf linux.tar.gz
> <access beyond end of device and livelock>

Thanks for the report, this bug shows we've miscalculated the length of discard extents.

I'll send a patch for this soon.

thanks,
-- 
liubo 
