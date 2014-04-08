Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:25110 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753162AbaDHBTe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 21:19:34 -0400
Message-ID: <53434EE0.6030400@cn.fujitsu.com>
Date: Tue, 8 Apr 2014 09:20:32 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 14/27] btrfs-progs: Convert man page for btrfs-replace.
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com> <1396427378-10487-15-git-send-email-quwenruo@cn.fujitsu.com> <20140404202929.GB12124@merlins.org>
In-Reply-To: <20140404202929.GB12124@merlins.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


于 2014年04月05日 04:29, Marc MERLIN 写道:
> On Wed, Apr 02, 2014 at 04:29:25PM +0800, Qu Wenruo wrote:
>> +If the source device is not available anymore, or if the -r option is set,
>> +the data is built only using the RAID redundancy mechanisms.
>> +After completion of the operation, the source device is removed from the
>> +filesystem.
> Woudl it make sense to add a paragraph explaining that for raid5/6,
> someone should either:
> 1) use balance to rebuild on a new drive if one of the drives is missing
> 2) use btrfs device add of a new drive, then btrfs device delete of the
> drive to replace, and effectively btrfs will do the same thing that
> replace would
>
> ?

Nice try, I think it's good to add a note paragraph for the use cases.

I'm also wondering should the same things added to btrfs-balance(8) and 
btrfs-device(8) man pages,
if added, three same paragraph will be added and the duplication 
paragraph may increase the difficulty to maintain
the documentation.

So I prefer to add the explaination about RAID5/6 to btrfs-device(8) and 
adds note on
btrfs-replace(8)/btrfs-balance(8) to refer to btrfs-device(8), since all 
of these things are about btrfs device management.

Would you prefer the modification?

Thanks,
Qu.
>
> Thanks,
> Marc

