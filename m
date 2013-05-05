Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from atl4mhob05.myregisteredsite.com ([209.17.115.43]:52151 "EHLO
	atl4mhob05.myregisteredsite.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751035Ab3EEB6w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 4 May 2013 21:58:52 -0400
Received: from mailpod1.hostingplatform.com ([10.30.71.113])
	by atl4mhob05.myregisteredsite.com (8.14.4/8.14.4) with ESMTP id r451wp2x025940
	for <linux-btrfs@vger.kernel.org>; Sat, 4 May 2013 21:58:51 -0400
Message-ID: <5185BCDF.8070805@chinilu.com>
Date: Sat, 04 May 2013 18:58:55 -0700
From: George Mitchell <george@chinilu.com>
Reply-To: george@chinilu.com
MIME-Version: 1.0
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Scrub CPU usage ...
References: <518555FF.4020704@chinilu.com> <dpog5a-t12.ln1@hurikhan.ath.cx>
In-Reply-To: <dpog5a-t12.ln1@hurikhan.ath.cx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/04/2013 06:21 PM, Kai Krakow wrote:
> George Mitchell <george@chinilu.com> schrieb:
>
>> 1)  The system fails to boot intermittently due to dracut/initrd issues
>> (btrfs: open_ctree failed).  This is being worked on upstream and I am
>> seeing a continual flow of patches addressing it, but so far no fix.
>> This will take time to fix and it usually leaps to life in 3 attempts or
>> less.
> Try rootdelay=1 or a higher number. This solved exactly that problem for me.
> It will delay mounting the rootfs by the given number of seconds. You need
> to pass this on the kernel command line, probably using grub. This seems to
> only be needed with multi-device btrfs as rootfs.
>
> Greetings,
> Kai
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

Thanks immensely for that tip.  I will give it a try.  - George
