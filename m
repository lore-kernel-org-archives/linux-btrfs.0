Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36136 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936218Ab3DQCSG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Apr 2013 22:18:06 -0400
Message-ID: <516E069D.4070103@oracle.com>
Date: Wed, 17 Apr 2013 10:19:09 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: a copy of superblock is zero may not mean
 btrfs is not there
References: <1365753306-19412-1-git-send-email-anand.jain@oracle.com> <20130416115756.GJ18193@twin.jikos.cz>
In-Reply-To: <20130416115756.GJ18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/16/2013 07:57 PM, David Sterba wrote:
> On Fri, Apr 12, 2013 at 03:55:06PM +0800, Anand Jain wrote:
>> If one of the copy of the superblock is zero it does not
>> confirm to us that btrfs isn't there on that disk. When
>> we are having more than one copy of superblock we should
>> rather let the for loop to continue to check other copies.
>>
>> the following test case and results would justify the
>> fix
>>
>> mkfs.btrfs /dev/sdb /dev/sdc -f
>> mount /dev/sdb /btrfs
>> dd if=/dev/zero bs=1 count=8 of=/dev/sdc seek=$((64*1024+64))
>> ~/before/btrfs-select-super -s 1 /dev/sdc
>> using SB copy 1, bytenr 67108864
>>
>> here btrfs-select-super just wrote superblock to a mounted btrfs
>
> Why does not check_mounted() catch this in the first place? Ie. based on
> the status in /proc/mounts not on random bytes in the superblock.

  the reason is, as of now /proc/mounts just knows about the devid 1.

Thanks, Anand
