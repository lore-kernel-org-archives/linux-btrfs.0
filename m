Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:42884 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933017AbbGVJ2y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Jul 2015 05:28:54 -0400
Subject: Re: [GIT PULL] Fix for btrfs/070 checksum error
To: Chris Mason <clm@fb.com>, btrfs <linux-btrfs@vger.kernel.org>
References: <559C9A75.60506@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55AF6250.8070602@cn.fujitsu.com>
Date: Wed, 22 Jul 2015 17:28:48 +0800
MIME-Version: 1.0
In-Reply-To: <559C9A75.60506@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Chris,

Is there anything wrong with it?

It has been 2 weeks, and it's still not in your for linus branch.

Is there anything wrong?

Thanks,
Qu

Qu Wenruo wrote on 2015/07/08 11:35 +0800:
> Hi Chris,
>
> Sorry for the late pull request, this one should be sent on Monday. :(
>
> This patchset is meant to fix an annoying bug triggered by btrfs/070 and
> some other concurrency scrub + IO load test.
>
> The bug itself is triggered by chance and took Zhao Lei quite a long
> time to trace and debug it.
>
> Although previous patchset sent to mail-list has some problem, it turned
> out that's rebasing typo, and can be fixed quite easy.
>
> We have spend a whole weekend running tests this time to ensure the
> patch is OK.
>
> The fix itself is small enough and only fixes a long standing problem.
> IMHO it is OK for the late fix merge window.
>
> So please merge the following branch:
> https://github.com/adam900710/linux.git  for_chris_4.2_070_fix
>
> Thanks,
> Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
