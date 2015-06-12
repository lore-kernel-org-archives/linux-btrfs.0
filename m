Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:63363 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932135AbbFLJnW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 05:43:22 -0400
Message-ID: <557AA9A1.3080706@cn.fujitsu.com>
Date: Fri, 12 Jun 2015 17:42:57 +0800
From: wangyf <wangyf-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Omar Sandoval <osandov@osandov.com>, Zhao Lei <zhaolei@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>, "'Miao Xie'" <miaoxie@huawei.com>,
        "'Philip'" <bugzilla@philip-seeger.de>
Subject: Re: [PATCH 0/4] Btrfs: RAID 5/6 missing device replace
References: <cover.1431330020.git.osandov@osandov.com> <20150526170547.GA21342@mew.lv.cox.net> <031201d0a3fa$0af404a0$20dc0de0$@cn.fujitsu.com> <20150611060813.GA16231@mew>
In-Reply-To: <20150611060813.GA16231@mew>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi. I have tested this patchset in Virtual Machine.

Environment:
         Oracle VirtualBox 4.3.10 + Ubuntu 14.10 server + LVM 2.02.98
Kernel:
         4.1.0-rc7 (12 June, 2015 / Today) with your 4 patches.

Btrfs-progs: 4.0

Generic Test Procedure:
         mkfs.btrfs -f -m $RAID -d $RAID && mount
         cp some data
         lvremove a logical volume
         mount -o degraded
         btrfs replace with a new device
         btrfs scrub  /mnt

without patches, raid 1, raid 10 are both OK, raid 5/6 cause NULL 
pointer dereference
                                and when shudown -h , get BTRFS info： 
suspending dev_replace for umount
with the patches, raid 1/10/5/6 are all okey.


在 2015年06月11日 14:08, Omar Sandoval 写道:
> On Thu, Jun 11, 2015 at 11:52:30AM +0800, Zhao Lei wrote:
>> Hi, Omar Sandoval
>>
>> I tested this patchset with my script, but see general protection fault
>> again.
>> NODE: kvm with virtio disk
>> ROOTFS: RHEL6 with btrfs-progs v4.0
>> KERNEL: v4.1-rc6 with 4 patchs in this patchset
>>
>> Maybe my test have small different with yours,
>> but it seems is similar bug, could you check it?
>>
> Hi, Zhao Lei,
>
> Thanks for taking a look! I was able to reproduce this and it looks like
> a similar bug, this time coming from the parity scrubbing code instead
> of the data scrubbing code. I didn't test scrubbing a degraded
> filesystem, only replacing a missing device, so that's probably why I
> didn't run into it. I'll take a closer look.
>
> Thanks,

