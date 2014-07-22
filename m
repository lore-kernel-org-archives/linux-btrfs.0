Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58305 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751619AbaGVBPR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Jul 2014 21:15:17 -0400
Message-ID: <53CDB9EA.4020705@cn.fujitsu.com>
Date: Tue, 22 Jul 2014 09:10:02 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: TM <tmjuju@yahoo.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
References: <loom.20140720T102642-239@post.gmane.org> <53CC6B39.1060705@cn.fujitsu.com> <loom.20140721T155907-291@post.gmane.org>
In-Reply-To: <loom.20140721T155907-291@post.gmane.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/21/2014 10:00 PM, TM wrote:
> Wang Shilong <wangsl.fnst <at> cn.fujitsu.com> writes:
>
>> Just my two cents:
>>
>> Since 'btrfs replace' support RADI10, I suppose using replace
>> operation is better than 'device removal and add'.
>>
>> Another Question is related to btrfs snapshot-aware balance.
>> How many snapshots did you have in your system?
>>
>> Of course, During balance/resize/device removal operations,
>> you could still snapshot, but fewer snapshots should speed things up!
>>
>> Anyway 'btrfs replace' is implemented more effective than
>> 'device remova and add'.
>>
>
> Hi Wang,
> just one subvolume, no snaphots or anything else.
>
> device replace: to tell you the truth I have not used it in the past. Most
> of my testing was done 2 years ago. So in this 'kind of production' system I
> did not try it. But if I knew that it was faster, perhaps I could have used
> it. Anyone has statistics for such a replace and the time it takes?
I don't have specific statistics about this. The conclusion come from
implementation differences between replace and 'device removal'.


>
> Also, can replace be used when one device is missing? Cant find
> documentation. eg.
> btrfs replace start missing /dev/sdXX
>
>
> TM
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

