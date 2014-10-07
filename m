Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:43346 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753469AbaJGJSz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Oct 2014 05:18:55 -0400
Message-ID: <5433AFFB.20101@cn.fujitsu.com>
Date: Tue, 7 Oct 2014 17:18:51 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        Juan Orti Alcaine <juan.orti@miceliux.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: Identify mounted subvolume
References: <c7a9551462105e36f8ac5f874d19e9c2@miceliux.com> <20141007090608.GE11870@carfax.org.uk>
In-Reply-To: <20141007090608.GE11870@carfax.org.uk>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: Identify mounted subvolume
From: Hugo Mills <hugo@carfax.org.uk>
To: Juan Orti Alcaine <juan.orti@miceliux.com>
Date: 2014年10月07日 17:06
> On Tue, Oct 07, 2014 at 10:47:56AM +0200, Juan Orti Alcaine wrote:
>> I cannot find the answer to this one. How can I determine which subvolume I
>> have mounted in a certain path? I'm looking through /sys but no clue.
>     Rumour has it that /proc/self/mountinfo is meant to have the
> information, but I've just checked, and it doesn't seem to have the
> subvol in it on my server (3.16.2).
>
>     Hugo.
>
This accepted patch will make /proc/self/mountinfo to have all the info.
https://patchwork.kernel.org/patch/4593831/

But I didn't see it in 3.17 kernel or integration branch, maybe next 
merge window?

Even without the patch, when mounting using '-o subvol=' mount option 
will also fill the /proc/self/mountinfo,
using 3.16.4.
---
149 19 0:39 / /mnt/btrfs rw,relatime shared:101 - btrfs /dev/sda6 
rw,space_cache
153 19 0:39 */subvol1* /mnt/other rw,relatime shared:104 - btrfs 
/dev/sda6 rw,space_cache
---

On the other hand, without the patch and you mount with '-o subvolid=', 
then mountinfo will not help.

Thanks,
Qu



