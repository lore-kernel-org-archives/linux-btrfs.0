Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:57915 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S967181Ab2EQPdL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 May 2012 11:33:11 -0400
Message-ID: <4FB51A4E.6000501@gmx.net>
Date: Thu, 17 May 2012 17:33:34 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs: initial readahead code and prototypes
References: <20120517071446.GI14660@elgon.mountain> <4FB4FDC6.5070306@gmx.net> <20120517134613.GN16999@mwanda>
In-Reply-To: <20120517134613.GN16999@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/17/12 15:46, Dan Carpenter wrote:
> On Thu, May 17, 2012 at 03:31:50PM +0200, Arne Jansen wrote:
>> The assumption here is that if err == 0, eb is always != NULL. There's
>> even a tiny comment above the function stating this:
>>
>>        107              /* in case of err, eb might be NULL */
>>
>
> Ah, right.  I missed the comment.

Thanks for doing this kind of sanity checking :)

-Arne

>
>> This code changes significantly with the patch
>>
>> btrfs: extend readahead interface
>>
>> Where it is written in a more obvious way.
>
> Cool.
>
> regards,
> dan carpenter
>

