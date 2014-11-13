Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 2.mo69.mail-out.ovh.net ([178.33.251.80]:59653 "EHLO
	mo69.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932338AbaKMKty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Nov 2014 05:49:54 -0500
Received: from mail433.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo69.mail-out.ovh.net (Postfix) with SMTP id 6E4FBFFC563
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Nov 2014 11:49:51 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: Quota question
From: Cyril Scetbon <cyril.scetbon@free.fr>
In-Reply-To: <54647C9C.3030000@cn.fujitsu.com>
Date: Thu, 13 Nov 2014 11:49:47 +0100
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Message-Id: <460A55DA-37B0-4636-A1E7-1B89E33EE61F@free.fr>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr> <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr> <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net> <CCA13B0E-D1EE-44D8-A634-FD17C2B22C72@free.fr> <pan$648cb$e6ca8d21$192128f6$95e500d3@cox.net> <967D58C4-46E1-4508-A5A9-A0835C18E87D@free.fr> <EE8501C5-2A50-4E93-89F5-C08E28CE71DB@free.fr> <928A4C3A-2CE4-48E5-8831-BE6C1685ED8B@free.fr> <5464200D.1010600@cn.fujitsu.com> <54647C9C.3030000@cn.fujitsu.com>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

I'm using ubuntu kernels provided at http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.17.1-utopic/. I asked them how to rebuild one with a patch and will try it when I got the answer.

Thanks

PS : good news and I hope it'll fix the issue
-- 
Cyril SCETBON

> On 13 Nov 2014, at 10:40, Dongsheng Yang <yangds.fnst@cn.fujitsu.com> wrote:
> 
> On 11/13/2014 11:05 AM, Dongsheng Yang wrote:
>> On 11/12/2014 10:04 PM, Cyril Scetbon wrote:
>>> Anyone on this ? There is an issue with quotas depending on the write rate. The more we can write before a sync, the more we can exceed quotas limits
>> 
>> Hi Cyril, I attempted to reproduce the problem you reported in Linux.3.17, but failed.
>> It seems that the issue in this thread was fixed already. Could you test on Linux.3.17 or later version?
> 
> Hi Cyril, after some more investigation, there actually is a problem you described here.
> 
> *reason*
> The logic in fallocate to update qgroup->excl here is:
> 1). btrfs_qgroup_reserve(). It reserves N_bytes.
> 2). btrfs_prealloc_file_range(). It record a qgroup ref into trans->qgroup_ref_list.
> 3). btrfs_qgroup_free(). It clear the N_bytes from reservation.
> ... ...
> commit_transaction().
> 
> Similar logic in writing data.
> 
> Currently qgroup->excl is updated in qgroup_excl_accounting and it is called in commit_transation().
> It means there probably is a *window* between btrfs_qgroup_free() and commit_transaction() where
> the N_bytes is not accounted into qgroup. In this *window*, more data request will be accepted
> even the total size of these requests exceeds the limit, and qgroup can't realize it.
> 
> There is a quick fix attached on this mail, it delays the reserve_free operation after updating qgroup->excl.
> 
> *NOTE*
> It is just a quick fix for your problem here, could you help to test is on your box? Patch is based on
> Linux 3.17 (bfe01a5ba2490f299e1d2d5508cbbbadd897bbe9).
> 
> More work about btrfs quota is on the TODO list.
> 
> Thanx
>> 
>> Below is my log:
>> [root@atest-guest linux_btrfs]# uname -a
>> Linux atest-guest 3.17.0+ #60 SMP Thu Nov 13 06:51:55 EST 2014 x86_64 x86_64 x86_64 GNU/Linux
>> [root@atest-guest linux_btrfs]# btrfs qgroup show -e /mnt
>> qgroupid rfer  excl  max_excl
>> -------- ----  ----  --------
>> 0/5      16384 16384 0
>> [root@atest-guest linux_btrfs]# btrfs sub create /mnt/sub
>> Create subvolume '/mnt/sub'
>> [root@atest-guest linux_btrfs]# sync
>> [root@atest-guest linux_btrfs]# btrfs qgroup show -e /mnt
>> qgroupid rfer  excl  max_excl
>> -------- ----  ----  --------
>> 0/5      16384 16384 0
>> 0/257    16384 16384 0
>> [root@atest-guest linux_btrfs]# btrfs qgroup limit -e 300M /mnt/sub
>> [root@atest-guest linux_btrfs]# btrfs qgroup show -e /mnt
>> qgroupid rfer  excl  max_excl
>> -------- ----  ----  --------
>> 0/5      16384 16384 0
>> 0/257    16384 16384 314572800
>> [root@atest-guest linux_btrfs]# for((i=0;i<10;i++));do dd if=/dev/zero of=/mnt/sub/data$i bs=6M count=10; done
>> 10+0 records in
>> 10+0 records out
>> 62914560 bytes (63 MB) copied, 0.0401096 s, 1.6 GB/s
>> 10+0 records in
>> 10+0 records out
>> 62914560 bytes (63 MB) copied, 0.0431105 s, 1.5 GB/s
>> 10+0 records in
>> 10+0 records out
>> 62914560 bytes (63 MB) copied, 0.0407304 s, 1.5 GB/s
>> 10+0 records in
>> 10+0 records out
>> 62914560 bytes (63 MB) copied, 0.041441 s, 1.5 GB/s
>> dd: error writing \u2018/mnt/sub/data4\u2019: Disk quota exceeded
>> 10+0 records in
>> 9+0 records out
>> 60817408 bytes (61 MB) copied, 0.0398122 s, 1.5 GB/s
>> dd: error writing \u2018/mnt/sub/data5\u2019: Disk quota exceeded
>> 1+0 records in
>> 0+0 records out
>> 1703936 bytes (1.7 MB) copied, 0.00318793 s, 534 MB/s
>> dd: error writing \u2018/mnt/sub/data6\u2019: Disk quota exceeded
>> 1+0 records in
>> 0+0 records out
>> 0 bytes (0 B) copied, 0.00239674 s, 0.0 kB/s
>> dd: error writing \u2018/mnt/sub/data7\u2019: Disk quota exceeded
>> 1+0 records in
>> 0+0 records out
>> 0 bytes (0 B) copied, 0.002271 s, 0.0 kB/s
>> dd: error writing \u2018/mnt/sub/data8\u2019: Disk quota exceeded
>> 1+0 records in
>> 0+0 records out
>> 0 bytes (0 B) copied, 0.00232063 s, 0.0 kB/s
>> dd: error writing \u2018/mnt/sub/data9\u2019: Disk quota exceeded
>> 1+0 records in
>> 0+0 records out
>> 0 bytes (0 B) copied, 0.00185336 s, 0.0 kB/s
>> [root@atest-guest linux_btrfs]# sync
>> [root@atest-guest linux_btrfs]# btrfs qgroup show -e /mnt
>> qgroupid rfer      excl      max_excl
>> -------- ----      ----      --------
>> 0/5      16384     16384     0
>> 0/257    314195968 314195968 314572800
>> 
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> .
>> 
> 
> <0001-btrfs-free-quota-reserved-in-delay_ref-handler.patch>

