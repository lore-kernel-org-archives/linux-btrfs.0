Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:27469 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750856AbbFYFET convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Jun 2015 01:04:19 -0400
Message-ID: <558B8BBD.2010004@cn.fujitsu.com>
Date: Thu, 25 Jun 2015 13:03:57 +0800
From: wangyf <wangyf-fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Ed Tomlinson <edt@aei.ca>, Omar Sandoval <osandov@fb.com>
CC: <linux-btrfs@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>,
        Zhao Lei <zhaolei@cn.fujitsu.com>, Philip <bugzilla@philip-seeger.de>
Subject: Re: [PATCH v2 0/5] Btrfs: RAID 5/6 missing device scrub+replace
References: <cover.1434739053.git.osandov@fb.com> <5588CD54.9050405@cn.fujitsu.com> <20150624041310.GA26148@huxley.DHCP.TheFacebook.com> <5cfdd3e8-e9ba-4b3a-a858-49f6a36f18de@aei.ca>
In-Reply-To: <5cfdd3e8-e9ba-4b3a-a858-49f6a36f18de@aei.ca>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

  I confirmed this bug report, and found the reason is that
  I compiled the patched module with a dirty kernel.
  This morning I tested this patch again, and didn't see above error, 
this patch is OK.
  Sorry for this bug report. : (


在 2015年06月24日 20:00, Ed Tomlinson 写道:
> On Wednesday, June 24, 2015 12:15:29 AM EDT, Omar Sandoval wrote:
>> On Tue, Jun 23, 2015 at 11:07:00AM +0800, wangyf wrote:
>>> Hi,
>>> I have tested your PATCH v2 , but something wrong happened.
>>>
>>> kernel: 4.1.0-rc7+ with your five patches
>>> vitrualBox ubuntu14.10-server + LVM
>>>
>>> I make a new btrfs.ko with your patches,
>>> rmmod original module and insmod the new.
>>>
>>> When I use the profile RAID1/10, mkfs successfully
>>> But when mount the fs, dmesg dumped:
>>>     trans: 18446612133975020584 running 5
>>>     btrfs transid mismatch buffer 29507584, found 18446612133975020584
>>> running 5
>>>     btrfs transid mismatch buffer 29507584, found 18446612133975020584
>>> running 5
>>>     btrfs transid mismatch buffer 29507584, found 18446612133975020584
>>> running 5
>>> ... ...
>>>
>>> When use the RAID5/6, mkfs and mount
>>> system stoped at the 'mount -t btrfs /dev/mapper/server-dev1 /mnt' cmd.
>>>
>>> That's all.
>>
>> Hm, that's really weird, I can't reproduce that here at all. I don't see
>> what would cause that in this series, and the changes from v1 are
>> minimal. For my sake, could you make sure that there's nothing else
>> going on?
>
> Omar,
>
> I've been running v1 of this patch and now with v2 and have done 
> numberious reboots without issues...  Just another data point.
>
> Ed

