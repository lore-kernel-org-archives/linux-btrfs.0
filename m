Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:51655 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754935AbbEFAtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 20:49:32 -0400
Message-ID: <5549651D.6020005@cn.fujitsu.com>
Date: Wed, 6 May 2015 08:49:33 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/8] Introduce offline fsid/chunk tree uuid change for
 btrfstune.
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com> <20150505152055.GH5099@twin.jikos.cz>
In-Reply-To: <20150505152055.GH5099@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH 0/8] Introduce offline fsid/chunk tree uuid change 
for btrfstune.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年05月05日 23:20

> On Tue, May 05, 2015 at 02:16:38PM +0800, Qu Wenruo wrote:
>> This patchset will introduce offline fsid/chunk tree uuid change
>> function to btrfstune command, with "-u" and "-U" options respectively.
>>
>> The implement is in-place btrfs_header modification, without transaction
>> protection. So the uuid change can be done on any valid image even it is
>> already full.
>>
>> Since we don't use transaction to protect the convert, it's possible one
>> can stop the running convert progress, causing the fs in a inconsistent
>> status and unable to be mounted.
>> To avoid such problem, we introduce new open ctree flags
>> OPEN_CTREE_IGNORE_FSID, allowing btrfstune to finish the convert.
>
> Code looks good to me. I'm not sure whether it should land in btrfstune
> or in 'btrfs' proper.
>
> * btrfstune should go away at some point, so I'd rather not add new
>    features there
>
> * 'btrfs property set -t filesystem uuid' seems best to me at this moment
Good idea.

I'll change it to property in next version.
>
> A minor suggestion: set BTRFS_SUPER_FLAG_ERROR on the filesystem during
> the conversion and drop it after it finishes successfully. It's merely a
> hint that there's something wrong with the filesytem, the mount will
> fail because filesystem uuid would not match the device id.
>
Nice idea too.
But I'd like to use more specific flags like
BTRFS_SUPER_FLAG_UUID_CHANGING to give better info if kernel can't mount it.

Thanks for all these advice!
Qu
