Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:7656 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab3KHAzs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 19:55:48 -0500
Message-ID: <527C36C5.6070306@cn.fujitsu.com>
Date: Fri, 08 Nov 2013 08:56:37 +0800
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
Iwill benchmarked on SSD and coompression both before next version of patch.

Thanks.

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

