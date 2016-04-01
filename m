Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33509 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752422AbcDAA0z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Mar 2016 20:26:55 -0400
Subject: Re: [PATCH v9 00/19] Btrfs dedupe framework
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <clm@fb.com>
References: <1459324574-28063-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160331161201.GD6230@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56FDC043.50902@cn.fujitsu.com>
Date: Fri, 1 Apr 2016 08:26:43 +0800
MIME-Version: 1.0
In-Reply-To: <20160331161201.GD6230@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/03/31 18:12 +0200:
> On Wed, Mar 30, 2016 at 03:55:55PM +0800, Qu Wenruo wrote:
>> This March 30th patchset update mostly addresses the patchset structure
>> comment from David:
>> 1) Change the patchset sequence
>>     Not If only apply the first 14 patches, it can provide the full
>>     backward compatible in-memory only dedupe backend.
>>
>>     Only starts from patch 15, on-disk format will be changed.
>>
>>     So patch 1~14 is going to be pushed for next merge window, while I'll
>>     still submit them all for review purpose.
>
> I'll buy 1-10 with the ioctl hidden under the BTRFS_DEBUG config option
> until the interface is settled.
>
>
Nice to hear that.

I'll add BTRFS_DEBUG config then.

BTW, any comment on btrfs-convert rewrite?

Thanks,
Qu


