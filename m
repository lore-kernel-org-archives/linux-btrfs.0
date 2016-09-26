Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:60401 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S932234AbcIZDGK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 25 Sep 2016 23:06:10 -0400
Subject: Re: [PATCH 2/2] btrfs-progs: super-recover: Reuse
 btrfs_read_dev_super function
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <hawken@thehawken.org>
References: <20160920021902.818-1-quwenruo@cn.fujitsu.com>
 <20160920021902.818-2-quwenruo@cn.fujitsu.com>
 <20160923132603.GZ16983@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <451661f2-4273-8877-d3de-2ea364613286@cn.fujitsu.com>
Date: Mon, 26 Sep 2016 11:05:50 +0800
MIME-Version: 1.0
In-Reply-To: <20160923132603.GZ16983@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 09/23/2016 09:26 PM, David Sterba wrote:
> On Tue, Sep 20, 2016 at 10:19:02AM +0800, Qu Wenruo wrote:
>> We have enhanced super block validation check in disk_io.c, while
>> super-recover doesn't use that function and use a custom one.
>>
>> That is duplicated, so reuse btrfs_read_dev_super to handle it, which
>> not only enhanced super check, but also reduce the code length.
>
> Yeah, the existing check_super does way more checks compared to this
> one. Applied, thanks.
>
>
Sorry David, this patch can't be applied without previous patch.

As this patch relies on previous patch to get meaningful return value, 
to check if it's a real error or that superblock just doesn't exist.

I'll update previous patch soon.

Thanks,
Qu


