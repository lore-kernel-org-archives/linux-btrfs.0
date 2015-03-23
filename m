Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40716 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089AbbCWIZh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 04:25:37 -0400
Message-ID: <550FCD9C.1000706@oracle.com>
Date: Mon, 23 Mar 2015 16:23:56 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: "G. Richard Bellamy" <rbellamy@pteradigm.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Upgrade to 3.19.2 Kernel fails to boot
References: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
In-Reply-To: <CADw2B2Nxr5PPSaVWpQWxg0ZaXYSpOTye_pMU1HbjCHif8q9_LQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Do you still have the problem ? Can you pls confirm on the latest btrfs 
? Since I am fixing the devices part of the btrfs, I am bit nervous.

Thanks,  Anand

On 03/20/2015 07:06 AM, G. Richard Bellamy wrote:
> When I upgrade to the 3.19.2 Kernel I get a deadlocked boot:
> INFO: task mount:302 blocked for more than 120 seconds.
> INFO: task btrfs-transacti:329 blocked for more than 120 seconds.
>
> I have an LTS Kernel at 3.14.35 that also fails to boot with the same behavior.
>
> My 3.18.6 works just fine.
>
> -rb
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
