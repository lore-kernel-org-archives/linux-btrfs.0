Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38290 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab2I0KqR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Sep 2012 06:46:17 -0400
Message-ID: <50642746.3050902@cn.fujitsu.com>
Date: Thu, 27 Sep 2012 18:15:34 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
MIME-Version: 1.0
To: Ilya Dryomov <idryomov@gmail.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V3 1/2] Btrfs: cleanup duplicated division functions
References: <5051BAB8.7080200@cn.fujitsu.com> <505A8632.10101@cn.fujitsu.com> <505C2E62.2000400@cn.fujitsu.com> <20120923114924.GA1975@zambezi.lan> <505FBFCE.3010503@cn.fujitsu.com> <20120924164742.GN14582@twin.jikos.cz>
In-Reply-To: <20120924164742.GN14582@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry to reply late.

On Mon, 24 Sep 2012 18:47:42 +0200, David Sterba wrote:
>>> This is the most straightforward transformation I can think of.  It
>>> doesn't result in an unnecessary BUG_ON, keeps churn to a minimum and
>>
>> agree with you.
>>
>>> doesn't change the "style" of the balance ioctl.  (If I were to check
>>> every filter argument that way, btrfs_balance_ioctl() would be very long
>>> and complicated.)
>>
>> I think the check in btrfs_balance_ioctl() is necessary, the reason is above.
> 
> btrfs_balance_ioctl does not seem as the right place, it does the
> processing related to the state of balance (resume/cancel etc). Look at
> btrfs_balance() itself, it does lot more sanity checks of the parameters

I think we should not put the check in btrfs_balance(), because the arguments
are valid forever if they pass the check when they are input, if we put the
check in btrfs_balance(), the check will be done every time we resume the balance.
it is unnecessary.

> We can put the extra checks into helpers (and not only this
> one) if clarity and readability of the function becomes a concern.

Agree. I will put this check into a helper in the next version of this patch.
And I will make a separate patch to move the current check in btrfs_balance
from btrfs_balance to the above helper after this patch is received.

Thanks
Miao
