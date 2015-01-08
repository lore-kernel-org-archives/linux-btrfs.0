Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7164 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752849AbbAHD4N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Jan 2015 22:56:13 -0500
Message-ID: <54ADFF29.3050206@cn.fujitsu.com>
Date: Thu, 8 Jan 2015 11:53:13 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>, <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3 0/3] Btrfs: Enhancment for qgroup.
References: <549CF56A.2050400@jp.fujitsu.com> <1420438604-4846-1-git-send-email-yangds.fnst@cn.fujitsu.com> <54AC82AC.5060100@jp.fujitsu.com>
In-Reply-To: <54AC82AC.5060100@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/07/2015 08:49 AM, Satoru Takeuchi wrote:
> Hi Yang,
>
> On 2015/01/05 15:16, Dongsheng Yang wrote:
>> Hi Josef and others,
>>
>> This patch set is about enhancing qgroup.
>>
>> [1/3]: fix a bug about qgroup leak when we exceed quota limit,
>> 	It is reviewd by Josef.
>> [2/3]: introduce a new accounter in qgroup to close a window where
>> 	user will exceed the limit by qgroup. It "looks good" to Josef.
>> [3/3]: a new patch to fix a bug reported by Satoru.
> I tested your the patchset v3. Although it's far better
> than the patchset v2, there is still one problem in this patchset.
> When I wrote 1.5GiB to a subvolume with 1.0 GiB limit,
> 1.0GiB - 139 block (in this case, 1KiB/block) was written.
>
> I consider user should be able to write just 1.0GiB in this case.

Hi Satoru,

Yes, Currently, user can not write 1.0GiB in this case. Because qgroup
is accounting data and metadata togather. And I have posted an idea
in this thread that split it into three modes, data, metadata and both.

TODO issues:
c). limit and account size in 3 modes, data, metadata and both.
	qgroup is accounting the size both of data and metadata
togather, but to users, the data size is the most useful to them.


But, you mentioned that the result is different in each time.
Hmmm.... there must be something wrong in it. I need some more
investigation to answer this question.

Thanx a lot for your test!
Yang
>
> * Test result
>
> ===============================================================================
> + mkfs.btrfs -f /dev/vdb
> Btrfs v3.17
> See http://btrfs.wiki.kernel.org for more information.
>
> Turning ON incompat feature 'extref': increased hardlink limit per file to 65536
> fs created label (null) on /dev/vdb
>         nodesize 16384 leafsize 16384 sectorsize 4096 size 30.00GiB
> + mount /dev/vdb /root/btrfs-auto-test/
> + ret=0
> + btrfs quota enable /root/btrfs-auto-test/
> + btrfs subvolume create /root/btrfs-auto-test//sub
> Create subvolume '/root/btrfs-auto-test/sub'
> + btrfs qgroup limit 1G /root/btrfs-auto-test//sub
> + dd if=/dev/zero of=/root/btrfs-auto-test//sub/file bs=1024 count=1500000
> dd: error writing '/root/btrfs-auto-test//sub/file': Disk quota exceeded
> 1048438+0 records in                    # Tried to write 1GiB - 138 KiB
> 1048437+0 records out                   # Succeeded to write 1GiB - 139 KiB
> 1073599488 bytes (1.1 GB) copied, 19.0247 s, 56.4 MB/s
> ===============================================================================
>
> * note
>
> I tried to run the reproducer five times and the result is
> a bit different for each time.
>
> =========================
> #	Written
> -------------------------
> 1	1GiB - 139 KiB
> 2	1GiB - 139 KiB
> 3	1GiB - 145 KiB
> 4	1GiB - 135 KiB
> 5	1GiB - 135 KiB
> ==========================
>
> So I consider it's a problem comes from timing.
>
> If I changed the block size from 1KiB to 1 MiB,
> the difference in bytes got larger.
>
> ============================
> #	Written
> ----------------------------
> 1	1GiB - 1 MiB
> 2	1GiB - 1 MiB
> 3	1GiB - 1 MiB
> 4	1GiB - 1 MiB
> 5	1GiB - 1 MiB
> ============================
>
> Thanks,
> Satoru
>
>> BTW, I have some other plan about qgroup in my TODO list:
>>
>> Kernel:
>> a). adjust the accounters in parent qgroup when we move
>> the child qgroup.
>> 	Currently, when we move a qgroup, the parent qgroup
>> will not updated at the same time. This will cause some wrong
>> numbers in qgroup.
>>
>> b). add a ioctl to show the qgroup info.
>> 	Command "btrfs qgroup show" is showing the qgroup info
>> read from qgroup tree. But there is some information in memory
>> which is not synced into device. Then it will show some outdate
>> number.
>>
>> c). limit and account size in 3 modes, data, metadata and both.
>> 	qgroup is accounting the size both of data and metadata
>> togather, but to a user, the data size is the most useful to them.
>>
>> d). remove a subvolume related qgroup when subvolume is deleted and
>> there is no other reference to it.
>>
>> user-tool:
>> a). Add the unit of B/K/M/G to btrfs qgroup show.
>> b). get the information via ioctl rather than reading it from
>> btree. Will keep the old way as a fallback for compatiblity.
>>
>> Any comment and sugguestion is welcome. :)
>>
>> Yang
>>
>> Dongsheng Yang (3):
>>    Btrfs: qgroup: free reserved in exceeding quota.
>>    Btrfs: qgroup: Introduce a may_use to account
>>      space_info->bytes_may_use.
>>    Btrfs: qgroup, Account data space in more proper timings.
>>
>>   fs/btrfs/extent-tree.c | 41 +++++++++++++++++++++++-------
>>   fs/btrfs/file.c        |  9 -------
>>   fs/btrfs/inode.c       | 18 ++++++++++++-
>>   fs/btrfs/qgroup.c      | 68 +++++++++++++++++++++++++++++++++++++++++++++++---
>>   fs/btrfs/qgroup.h      |  4 +++
>>   5 files changed, 117 insertions(+), 23 deletions(-)
>>
> .
>

