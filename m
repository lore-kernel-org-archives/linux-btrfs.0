Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2821 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752173AbaGDDyu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 3 Jul 2014 23:54:50 -0400
Message-ID: <53B62481.3030606@cn.fujitsu.com>
Date: Fri, 4 Jul 2014 11:50:25 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: 3.15.1: kernel BUG at fs/btrfs/locking.c:269
References: <20140702204152.GI20961@merlins.org> <20140703081318.GB20612@localhost.localdomain> <53B5125F.4070707@cn.fujitsu.com> <20140703134421.GS26932@merlins.org>
In-Reply-To: <20140703134421.GS26932@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/03/2014 09:44 PM, Marc MERLIN wrote:
> Thanks for the patch. Hopefully this will make it to the next 3.15.x
> kernel.
>
> I also went back to 3.14 anyway since the 'blocked for 120 seconds' look
> like another instance of deadlocks we've been discussing here.
>
> But just curious:
>
>>>> [160562.925463] parent transid verify failed on 2776298520576 wanted 41015 found 18120
> What should I be doing about this?
> Does it mean that I do have some kind of corruption/damage on my
> filesystem?
I am afraid, scrub maybe could not fix such kind of errors, all scrub 
doing is to verify whether
checksums match and if possible use good mirrors to rewrite bad one.

Such errors seem imply contention  itself is corrupted, we may have 
passed checksum
check after ending io, but we fail generation check afterwards.

So backups are always good.....:-)
>
> Also, is it possible to have all these messages state which devid they
> occurred on? I don't even know which device I should be worrying about
> right now, and although I'm running scrub now, my understanding is that
> scrub doesn't actually look at FS structures and is likely to miss this
> anyway.
To get physical device name, we still need mirror num to know which device
we are locating.

Feel free to correct me if i miss something here.:-)

Thanks,
Wang
>
> Thanks,
> Marc

