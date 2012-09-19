Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:43872 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab2ISOMq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Sep 2012 10:12:46 -0400
Message-ID: <5059D2D3.3050303@oracle.com>
Date: Wed, 19 Sep 2012 22:12:35 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: ching <lsching17@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: enquiry about autodefrag option
References: <50570652.4060200@gmail.com> <5059AC5E.1030003@gmail.com>
In-Reply-To: <5059AC5E.1030003@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/19/2012 07:28 PM, ching wrote:
> can anybody helps?
> 
> On 09/17/2012 07:15 PM, ching wrote:
>> I am testing btrfs for long-term storage and backup, and i would like
>> to know more about "autodefrag" option:
>>
>> 1. Will "autodefrag" option benefit ssd?
>>
>>     My understanding is:
>>
>>        autodrag -> number of extent decrease -> metadata decrease -> a
>> "healthier" filesystem in the long run
>>
>>    (P.S. I am aware that autodefrag will introduce extra write I/O)
>>

Yes, your understanding is right, random write workloads will benefit from it.

>> 2. AFAIK, "autodefrag" detects small random writes into files and
>> queues them up for an automatic defrag process, so the filesystem will
>> defragment itself while it's used.
>>
>>     If the system reboot/crash/remount-ro, will the autodefrag process
>> continue after resume?
>>

For reboot, autodefrag will be waited to finish during umounting btrfs.

For crash and remount-ro, it won't resume since it is not that necessary and we're all
COWed so that the data is ok.

And autodefrag will only take effect when taking the 'autodefrag' mount option.

thanks,
liubo

>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

