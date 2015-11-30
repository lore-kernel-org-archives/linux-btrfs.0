Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:59904 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbbK3KnF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 05:43:05 -0500
Subject: Re: [PATCH] btrfs-progs: mkfs-tests: Check sectorsize and nodesize
 combination
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1448847570-9549-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151130100004.GX31035@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <565C2829.6040001@gmx.com>
Date: Mon, 30 Nov 2015 18:42:49 +0800
MIME-Version: 1.0
In-Reply-To: <20151130100004.GX31035@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 11/30/2015 06:00 PM, David Sterba wrote:
> On Mon, Nov 30, 2015 at 09:39:30AM +0800, Qu Wenruo wrote:
>> Add mkfs selftest for invalid and valid sectorsize/nodesize
>> combination.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> Applied with some changes, thanks.
>
>> +image_size=1g
>> +image=image
>
> If you need a single image, just use prepare_test_dev and $TEST_DEV

Nice advice, just forgot that.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
