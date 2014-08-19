Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48452 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752025AbaHSDPo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Aug 2014 23:15:44 -0400
Message-ID: <53F2C1CA.3040609@cn.fujitsu.com>
Date: Tue, 19 Aug 2014 11:17:30 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: <miaox@cn.fujitsu.com>
MIME-Version: 1.0
To: Ming Lei <Ming.Lei@riverbed.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: fs_mark test on btrfs on 3.16.0-rc6+ #1 SMP
References: <2CE44BD3DBCF9541909CCB42F11CA3923A0B896B@sfo1exc-mbxp08.nbttech.com>
In-Reply-To: <2CE44BD3DBCF9541909CCB42F11CA3923A0B896B@sfo1exc-mbxp08.nbttech.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 18 Aug 2014 17:38:17 +0000, Ming Lei wrote:
> 
> Hi,
> 
> I ran the fs_mark test on a single empty hard drive. After the test, the df -h results are:
> 
> /dev/sdk1             917G   39G  832G   5% /ext4
> /dev/sdj1             932G   53G  850G   6% /btrfs
> 
> The test result for btrfs shows it ran 15 hours. Note there is no file/dir remove operation which I knew very slow compared with ext4.
> 
> [root@sh679 ~]# date;/root/fs_mark -v -n 1000000 -s 4096 -k -S 1 -D 1000 -N 1000 -d /btrfs/ -t 10;date
> Mon Aug 11 11:32:54 PDT 2014
> 
> #  /root/fs_mark  -v  -n  1000000  -s  4096  -k  -S  1  -D  1000  -N  1000  -d  /btrfs/  -t  10 
> #             Version 3.3, 10 thread(s) starting at Mon Aug 11 11:32:54 2014
> #             Sync method: INBAND FSYNC: fsync() per file in write loop.
> #             Directories:  Round Robin between directories across 1000 subdirectories with 1000 files per subdirectory.
> #             File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
> #             Files info: size 4096 bytes, written with an IO size of 16384 bytes per write
> #             App overhead is time in microseconds spent in the test not doing file writing related system calls.
> #             All system call times are reported in microseconds
> FSUse%        Count         Size    Files/sec     App Overhead        CREAT (Min/Avg/Max)        WRITE (Min/Avg/Max)        FSYNC (Min/Avg/Max)         SYNC (Min/Avg/Max)        CLOSE (Min/Avg/Max)       UNLINK (Min/Avg/Max)
>      8     10000000         4096        184.0        155517800       33      372    93743        7       16     3094    16450    54015  5420340        0        0        0        1        4     7777        0        0        0
> Tue Aug 12 02:40:01 PDT 2014
> 
> For hours, the disk utilization was around 95% and cpu utilization for all 12 cores was very low and only one core showed around 26%wa.
> 
> 
> To compare with Ext4:
> The test for ext4 on a same model of hard drive ran 2.5 hours.  
> 
> [root@sh679 ~]# date;/root/fs_mark -v -n 1000000 -s 4096 -k -S 1 -D 1000 -N 1000 -d /ext4/ -t 10;date
> Fri Aug  8 17:13:56 PDT 2014
> #  /root/fs_mark  -v  -n  1000000  -s  4096  -k  -S  1  -D  1000  -N  1000  -d  /ext4/  -t  10 
> #             Version 3.3, 10 thread(s) starting at Fri Aug  8 17:13:56 2014
> #             Sync method: INBAND FSYNC: fsync() per file in write loop.
> #             Directories:  Round Robin between directories across 1000 subdirectories with 1000 files per subdirectory.
> #             File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
> #             Files info: size 4096 bytes, written with an IO size of 16384 bytes per write
> #             App overhead is time in microseconds spent in the test not doing file writing related system calls.
> #             All system call times are reported in microseconds.
> 
> FSUse%        Count         Size    Files/sec     App Overhead        CREAT (Min/Avg/Max)        WRITE (Min/Avg/Max)        FSYNC (Min/Avg/Max)         SYNC (Min/Avg/Max)        CLOSE (Min/Avg/Max)       UNLINK (Min/Avg/Max)
>      9     10000000         4096        105.0        156950153       19      449  1741759        6       15  2069984    32368    94751  2044364        0        0        0        1        4     4149        0        0        0
> Sat Aug  9 19:41:14 PDT 2014

From

> Fri Aug  8 17:13:56 PDT 2014

to
 
> Sat Aug  9 19:41:14 PDT 2014

It is not 2.5 hours, it's 26.5 hours.

Thanks
Miao

> 
> Is it a known issue with btrfs or do I need to adjust the default parameters for btrfs (I remember use the default to make btrfs)? 
> 
> Mount command shows:
> /dev/sdk1 on /ext4 type ext4 (rw,relatime,seclabel,data=ordered)
> /dev/sdj1 on /btrfs type btrfs (rw,relatime,seclabel,nospace_cache)
> 
> Thanks
> Ming
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

