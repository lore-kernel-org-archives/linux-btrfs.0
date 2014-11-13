Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:55652 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753789AbaKMDIK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 22:08:10 -0500
Message-ID: <5464200D.1010600@cn.fujitsu.com>
Date: Thu, 13 Nov 2014 11:05:49 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Cyril Scetbon <cyril.scetbon@free.fr>, Duncan <1i5t5.duncan@cox.net>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Quota question
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr> <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr> <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net> <CCA13B0E-D1EE-44D8-A634-FD17C2B22C72@free.fr> <pan$648cb$e6ca8d21$192128f6$95e500d3@cox.net> <967D58C4-46E1-4508-A5A9-A0835C18E87D@free.fr> <EE8501C5-2A50-4E93-89F5-C08E28CE71DB@free.fr> <928A4C3A-2CE4-48E5-8831-BE6C1685ED8B@free.fr>
In-Reply-To: <928A4C3A-2CE4-48E5-8831-BE6C1685ED8B@free.fr>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/12/2014 10:04 PM, Cyril Scetbon wrote:
> Anyone on this ? There is an issue with quotas depending on the write rate. The more we can write before a sync, the more we can exceed quotas limits

Hi Cyril, I attempted to reproduce the problem you reported in 
Linux.3.17, but failed.
It seems that the issue in this thread was fixed already. Could you test 
on Linux.3.17 or later version?

Below is my log:
[root@atest-guest linux_btrfs]# uname -a
Linux atest-guest 3.17.0+ #60 SMP Thu Nov 13 06:51:55 EST 2014 x86_64 
x86_64 x86_64 GNU/Linux
[root@atest-guest linux_btrfs]# btrfs qgroup show -e /mnt
qgroupid rfer  excl  max_excl
-------- ----  ----  --------
0/5      16384 16384 0
[root@atest-guest linux_btrfs]# btrfs sub create /mnt/sub
Create subvolume '/mnt/sub'
[root@atest-guest linux_btrfs]# sync
[root@atest-guest linux_btrfs]# btrfs qgroup show -e /mnt
qgroupid rfer  excl  max_excl
-------- ----  ----  --------
0/5      16384 16384 0
0/257    16384 16384 0
[root@atest-guest linux_btrfs]# btrfs qgroup limit -e 300M /mnt/sub
[root@atest-guest linux_btrfs]# btrfs qgroup show -e /mnt
qgroupid rfer  excl  max_excl
-------- ----  ----  --------
0/5      16384 16384 0
0/257    16384 16384 314572800
[root@atest-guest linux_btrfs]# for((i=0;i<10;i++));do dd if=/dev/zero 
of=/mnt/sub/data$i bs=6M count=10; done
10+0 records in
10+0 records out
62914560 bytes (63 MB) copied, 0.0401096 s, 1.6 GB/s
10+0 records in
10+0 records out
62914560 bytes (63 MB) copied, 0.0431105 s, 1.5 GB/s
10+0 records in
10+0 records out
62914560 bytes (63 MB) copied, 0.0407304 s, 1.5 GB/s
10+0 records in
10+0 records out
62914560 bytes (63 MB) copied, 0.041441 s, 1.5 GB/s
dd: error writing \u2018/mnt/sub/data4\u2019: Disk quota exceeded
10+0 records in
9+0 records out
60817408 bytes (61 MB) copied, 0.0398122 s, 1.5 GB/s
dd: error writing \u2018/mnt/sub/data5\u2019: Disk quota exceeded
1+0 records in
0+0 records out
1703936 bytes (1.7 MB) copied, 0.00318793 s, 534 MB/s
dd: error writing \u2018/mnt/sub/data6\u2019: Disk quota exceeded
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.00239674 s, 0.0 kB/s
dd: error writing \u2018/mnt/sub/data7\u2019: Disk quota exceeded
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.002271 s, 0.0 kB/s
dd: error writing \u2018/mnt/sub/data8\u2019: Disk quota exceeded
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.00232063 s, 0.0 kB/s
dd: error writing \u2018/mnt/sub/data9\u2019: Disk quota exceeded
1+0 records in
0+0 records out
0 bytes (0 B) copied, 0.00185336 s, 0.0 kB/s
[root@atest-guest linux_btrfs]# sync
[root@atest-guest linux_btrfs]# btrfs qgroup show -e /mnt
qgroupid rfer      excl      max_excl
-------- ----      ----      --------
0/5      16384     16384     0
0/257    314195968 314195968 314572800

