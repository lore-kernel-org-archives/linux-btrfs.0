Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp.domeneshop.no ([194.63.252.54]:38325 "EHLO
	smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab3HCRhp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Aug 2013 13:37:45 -0400
Message-ID: <51FD3FDC.803@skagestad.org>
Date: Sat, 03 Aug 2013 19:37:32 +0200
From: =?ISO-8859-1?Q?Torbj=F8rn?= <lists@skagestad.org>
MIME-Version: 1.0
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Is the checkpoint interval adjustable?
References: <20130731200229.221580@gmx.com> <17rvca-hju.ln1@hurikhan.ath.cx>
In-Reply-To: <17rvca-hju.ln1@hurikhan.ath.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/03/2013 07:28 PM, Kai Krakow wrote:
> Mike Audia <mikey_a@gmx.com> schrieb:
>
>> I believe 30 sec is the default for the checkpoint interval.  Is this
>> adjustable? --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Just curious: What would be the benefit of increasing the checkpoint
> interval?
Laptops typically spin down disks to save power. If btrfs forces a write 
every 30 second, you have to spin it back up.

--
Torbjørn
>
> As far as I understood it would not decrease write load on the drives
> because it will only update a few pointers and probably increase the
> generation number...
>
> Greetings,
> Kai

