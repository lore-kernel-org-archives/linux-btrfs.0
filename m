Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:41488 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751444AbcAMAfn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jan 2016 19:35:43 -0500
Subject: Re: [PATCH] btrfs-progs: Format change for btrfs fi df
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1450070396-20744-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160112142806.GL4227@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56959BC7.7060201@cn.fujitsu.com>
Date: Wed, 13 Jan 2016 08:35:19 +0800
MIME-Version: 1.0
In-Reply-To: <20160112142806.GL4227@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/01/12 15:28 +0100:
> On Mon, Dec 14, 2015 at 01:19:56PM +0800, Qu Wenruo wrote:
>> The GlobalReserve space in 'btrfs fi df' is always confusing for a lot
>> of users.
>> As it is not a special chunk type like DATA or METADATA, it's in fact a
>> sub-type of METADATA.
>>
>> So change the output to skip GlobalReserve by default, and adding its
>> total to metadata used.
>> And add a new option '-r|--reserve' to show the GlobalReserve, but skip
>> the profile of GlobalReserve.
>
> How about this:
>
> - keep the global reserve in the output, separate from metadata and not
>    accounted
> - add new option to account the global reserve into metadata and then
>    drop it from the output

I'm OK about it, although that would just make '-r' option default.

But anyway, the profile of GlobalReserve should not be output.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


