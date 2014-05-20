Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:45005 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaETGjV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 May 2014 02:39:21 -0400
Message-ID: <537AF949.5090803@oracle.com>
Date: Tue, 20 May 2014 14:42:17 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Roman Mamedov <rm@romanrm.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: label should not contain return char
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com> <20140519231926.34e8942c@natsu>
In-Reply-To: <20140519231926.34e8942c@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 20/05/14 01:19, Roman Mamedov wrote:
> On Tue, 20 May 2014 01:04:30 +0800
> Anand Jain <anand.jain@oracle.com> wrote:
>
>> From: Anand Jain <Anand.Jain@oracle.com>
>>
>> generally if you use
>>    echo "test" > /sys/fs/btrfs/<fsid>/label
>> it would introduce return char at the end and it can not
>> be part of the label. The correct command is
>>    echo -n "test" > /sys/fs/btrfs/<fsid>/label
>>
>> This patch will check for this user error
>
> Maybe instead consider checking for one trailing "\n", and silently remove it
> if passed, so that both of the mentioned variants of 'echo' can be used?
>
> All other sysfs files do not care if you pass an extra "\n" at the end, e.g.
>
>    echo cfq > /sys/block/sda/queue/scheduler
>
> works fine, doesn't require you to use "echo -n cfq".
>

Thanks Roman.
