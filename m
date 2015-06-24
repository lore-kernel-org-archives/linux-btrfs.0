Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31535 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750775AbbFXEQP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 00:16:15 -0400
Date: Tue, 23 Jun 2015 21:15:29 -0700
From: Omar Sandoval <osandov@fb.com>
To: wangyf <wangyf-fnst@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>, Miao Xie <miaoxie@huawei.com>,
        Zhao Lei <zhaolei@cn.fujitsu.com>, Philip <bugzilla@philip-seeger.de>
Subject: Re: [PATCH v2 0/5] Btrfs: RAID 5/6 missing device scrub+replace
Message-ID: <20150624041310.GA26148@huxley.DHCP.TheFacebook.com>
References: <cover.1434739053.git.osandov@fb.com>
 <5588CD54.9050405@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5588CD54.9050405@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 23, 2015 at 11:07:00AM +0800, wangyf wrote:
> Hi,
> I have tested your PATCH v2 , but something wrong happened.
> 
> kernel: 4.1.0-rc7+ with your five patches
> vitrualBox ubuntu14.10-server + LVM
> 
> I make a new btrfs.ko with your patches,
> rmmod original module and insmod the new.
> 
> When I use the profile RAID1/10, mkfs successfully
> But when mount the fs, dmesg dumped:
>     trans: 18446612133975020584 running 5
>     btrfs transid mismatch buffer 29507584, found 18446612133975020584
> running 5
>     btrfs transid mismatch buffer 29507584, found 18446612133975020584
> running 5
>     btrfs transid mismatch buffer 29507584, found 18446612133975020584
> running 5
> ... ...
> 
> When use the RAID5/6, mkfs and mount
> system stoped at the 'mount -t btrfs /dev/mapper/server-dev1 /mnt' cmd.
> 
> That's all.

Hm, that's really weird, I can't reproduce that here at all. I don't see
what would cause that in this series, and the changes from v1 are
minimal. For my sake, could you make sure that there's nothing else
going on?

Thanks!
-- 
Omar
