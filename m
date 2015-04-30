Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46879 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751794AbbD3Ad2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Apr 2015 20:33:28 -0400
Message-ID: <55417856.5060207@cn.fujitsu.com>
Date: Thu, 30 Apr 2015 08:33:26 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: Fix superblock csum type check.
References: <1430183163-10870-1-git-send-email-quwenruo@cn.fujitsu.com> <20150429172307.GD4996@twin.jikos.cz>
In-Reply-To: <20150429172307.GD4996@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH] btrfs: Fix superblock csum type check.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年04月30日 01:23

> On Tue, Apr 28, 2015 at 09:06:03AM +0800, Qu Wenruo wrote:
>> Old csum type check is wrong and can't catch csum_type 1(not supported).
>>
>> Fix it to avoid hostile 0 division.
>>
>> Reported-by: Lukas Lueg <lukas.lueg@gmail.com>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> Reviewed-by: David Sterba <dsterba@suse.cz>
>
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -428,7 +428,7 @@ static int btrfs_check_super_csum(char *raw_disk_sb)
>>
>>   	if (csum_type >= ARRAY_SIZE(btrfs_csum_sizes)) {
>>   		printk(KERN_ERR "BTRFS: unsupported checksum algorithm %u\n",
>> -				csum_type);
>> +		       csum_type);
>
> Please avoid unrelated changes.
Thanks for reviewing.

Do I need to send a newer version to discard this format change?

Thanks,
Qu
>
>>   		ret = 1;
>>   	}
