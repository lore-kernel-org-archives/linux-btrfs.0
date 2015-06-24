Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail001.aei.ca ([206.123.6.130]:55783 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbbFXMHg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 08:07:36 -0400
From: Ed Tomlinson <edt@aei.ca>
To: Omar Sandoval <osandov@fb.com>
Cc: wangyf <wangyf-fnst@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>,
        Miao Xie <miaoxie@huawei.com>, Zhao Lei <zhaolei@cn.fujitsu.com>,
        Philip <bugzilla@philip-seeger.de>
Subject: Re: [PATCH v2 0/5] Btrfs: RAID 5/6 missing device scrub+replace
Date: Wed, 24 Jun 2015 08:00:52 -0400
MIME-Version: 1.0
Message-ID: <5cfdd3e8-e9ba-4b3a-a858-49f6a36f18de@aei.ca>
In-Reply-To: <20150624041310.GA26148@huxley.DHCP.TheFacebook.com>
References: <cover.1434739053.git.osandov@fb.com>
 <5588CD54.9050405@cn.fujitsu.com>
 <20150624041310.GA26148@huxley.DHCP.TheFacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wednesday, June 24, 2015 12:15:29 AM EDT, Omar Sandoval wrote:
> On Tue, Jun 23, 2015 at 11:07:00AM +0800, wangyf wrote:
>> Hi,
>> I have tested your PATCH v2 , but something wrong happened.
>> 
>> kernel: 4.1.0-rc7+ with your five patches
>> vitrualBox ubuntu14.10-server + LVM
>> 
>> I make a new btrfs.ko with your patches,
>> rmmod original module and insmod the new.
>> 
>> When I use the profile RAID1/10, mkfs successfully
>> But when mount the fs, dmesg dumped:
>>     trans: 18446612133975020584 running 5
>>     btrfs transid mismatch buffer 29507584, found 18446612133975020584
>> running 5
>>     btrfs transid mismatch buffer 29507584, found 18446612133975020584
>> running 5
>>     btrfs transid mismatch buffer 29507584, found 18446612133975020584
>> running 5
>> ... ...
>> 
>> When use the RAID5/6, mkfs and mount
>> system stoped at the 'mount -t btrfs /dev/mapper/server-dev1 /mnt' cmd.
>> 
>> That's all.
>
> Hm, that's really weird, I can't reproduce that here at all. I don't see
> what would cause that in this series, and the changes from v1 are
> minimal. For my sake, could you make sure that there's nothing else
> going on?

Omar,

I've been running v1 of this patch and now with v2 and have done numberious 
reboots without issues...  Just another data point.

Ed
