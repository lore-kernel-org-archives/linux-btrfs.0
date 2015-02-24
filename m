Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34756 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbbBXCLA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Feb 2015 21:11:00 -0500
Message-ID: <54EBDDBB.8040108@oracle.com>
Date: Tue, 24 Feb 2015 10:11:07 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>,
        Bob Williams <linux@barrowhillfarm.org.uk>,
        linux-btrfs@vger.kernel.org
Subject: Re: scrub problem
References: <CABgvyo__OdS8N=Gwf-n58FTViyOi5ZWOcchud+Hmt1JfD8pNpw@mail.gmail.com> <54E7A128.1060603@barrowhillfarm.org.uk> <54EA1F5A.7010802@pobox.com>
In-Reply-To: <54EA1F5A.7010802@pobox.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/23/2015 02:26 AM, Robert White wrote:
> On 02/20/2015 01:03 PM, Bob Williams wrote:
>> /var/lib/btrfs/scrub.status.0b07b829-9a0e-44ab-89ee-14b36a45199e
>>
>> (the last bit of the filename is the filesystem uuid)
>>
>> Look for a line that ends with "finished:0" and change it to say
>> "finished:1"
>
> Why does this data item even exist? The filesystem/kernel should know
> whether a scrub is ongoing. Isn't is universally cheaper to do the
> single IOCTL to ask the kernel whether a scrub is ongoing compared to
> the open-and-parse of this file?

good point. I wished btrfs activities/status are host independent. It 
helps in SAN configs.

-Anand

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
