Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:60435 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753631Ab3KZBjI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Nov 2013 20:39:08 -0500
Message-ID: <5293FBEF.6050309@cn.fujitsu.com>
Date: Tue, 26 Nov 2013 09:39:59 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 00/17] Replace btrfs_workers with kernel workqueue
 based btrfs_workqueue_struct
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com> <20131107175456.3802.35292@localhost.localdomain>
In-Reply-To: <20131107175456.3802.35292@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 7 Nov 2013 12:54:56 -0500, Chris Mason wrote:
> Quoting Qu Wenruo (2013-11-07 00:51:50)
>> Add a new btrfs_workqueue_struct which use kernel workqueue to implement
>> most of the original btrfs_workers, to replace btrfs_workers.
>>
>> With this patchset, redundant workqueue codes are replaced with kernel
>> workqueue infrastructure, which not only reduces the code size but also the
>> effort to maintain it.
>>
>> More performace tests are ongoing, the result from sysbench shows minor
>> improvement on the following server:
>> CPU: two-way Xeon X5660
>> RAM: 4G
>> HDD: SAS HDD, 150G total, 40G partition for btrfs test
>>
>> Test result:
>> Mode|Num_threads|block size|extra flags|performance change vs 3.11 kernel
>> rndrd   1       4K      none            +1.22%
>> rndrd   1       32K     none            +1.00%
>> rndrd   8       32K     sync            +1.35%
>> seqrd   8       4K      direct          +5.56%
>> seqwr   8       4K      none            -1.26%
>> seqwr   8       32K     sync            +1.20%
>>
>> Changes below 1% are not mentioned.
>> Overall the patchset doesn't change the performance on HDD.
>>
>> Since more tests are needed, more test result are welcomed.
> Thanks for working on this, it's really good to move toward a single set
> of workqueues in the kernel.
>
> Have you benchmarked with compression on?  Especially on modern
> hardware, the crcs don't exercise the workqueues very much.
>
> -chris
>
The result with compression on is quite interesting.
Overall minor improvement in random read,
mixed but still minor changes in sequence write.
Some impressive improvement and small regression in random write,
as well as some improvement in sequence write.

But overall, test result with compression is not as stable as the ones 
without compression,(some result data can change up to 15% using the 
same kernel)
and the result seems good overall, even with some regression in some tests.

I think the test machine should be modern enough as the following.
CPU: Two way Xeon X5660  @ 2.80GHz(24 cores when full load)
RAM: 4G(with mem=4G in kernel cmdline, physical RAM is 8G)
HDD: SAS 150G HDD, test btrfs partition is 40G

The detail test result is like the following:(Only changes over 1% is 
mentioned)

Mode|Num_threads|block size|extra flags|performance change vs 3.11 kernel
rndrd	1	32K	async		+1.98%
rndrd	1	32K	none		+2.77%
rndrd	8	4K	async		+5.16%
rndrd	8	4K	none		+5.57%
rndrd	8	32K	async		+5.11%
seqrd	1	4K	none		+3.84%
seqrd	1	32K	async		-2.84%
seqrd	1	32K	none		+1.87%
seqrd	8	4K	none		+4.75%
seqrd	8	32K	async		+1.02%
seqrd	8	32K	none		-1.38%
rndwr	1	4K	direct		-7.84%
rndwr	1	4K	none		+30.21% (*1)
rndwr	1	32K	async		-7.84%
rndwr	1	32K	none		-1.59%
rndwr	8	4K	async		+32.60% (*2)
rndwr	8	4K	none		+20.34% (*3)
rndwr	8	32K	async		+1.06%
rndwr	8	32K	none		-14.64% (*4)
seqwr	1	4K	async		-1.87%
seqwr	1	4K	none		+4.65%
seqwr	1	32K	async		+1.72%
seqwr	1	32K	none		+9.65%
seqwr	8	4K	async		+6.47%
seqwr	8	4K	none		-6.38%
seqwr	8	32K	async		+15.14%
seqwr	8	32K	none		+9.38%

*1: The data on original kernel changes between 35~45MBytes/s,
But on the patched kernel, the result tends to get a result of 70MBytes/s(about 50% chance),
but sometimes, the result can also drops to the 35~45MBytes/s.(50% chance)

*2: Much like *1, with patched kernel, result is more unstable and has a high chance to
get a better result. Even the worst result with patched kernel, the data is still on par
with the original kernel.

*3: Much like *1 or *2, this time, the original kernel also have a chance to get a better result,
but the possibility is much smaller than the patched kernel.

*4: Sadly, this time the patched kernel is more unstable and has a high chance to get a worse result.

*1~*4 only differ in the chance of unstable good/bad data, and the stable data seems on par.

Qu

-- 
-----------------------------------------------------
Qu Wenruo
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No. 6 Wenzhu Road, Nanjing, 210012, China
TEL: +86+25-86630566-8526
COINS: 7998-8526
FAX: +86+25-83317685
MAIL: quwenruo@cn.fujitsu.com
-----------------------------------------------------

