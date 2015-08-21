Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:53328 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752089AbbHUBc2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Aug 2015 21:32:28 -0400
Subject: Re: btrfs-image gets stuck, using 100%, looping on bad file
 descriptor
To: Timothy Normand Miller <theosib@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAK7bmU_MnppE5EptmAmqDYfpmC4vP8ydOLb6JROXDZFuasPong@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <55D67FA9.1030503@cn.fujitsu.com>
Date: Fri, 21 Aug 2015 09:32:25 +0800
MIME-Version: 1.0
In-Reply-To: <CAK7bmU_MnppE5EptmAmqDYfpmC4vP8ydOLb6JROXDZFuasPong@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Succeeded in reproducing the bug.

Any missing device will cause btrfs-image to inifinite loop.
It should be easy to fix.

I'll CC you when the patch is out.

Thanks,
Qu

Timothy Normand Miller wrote on 2015/08/18 11:40 -0400:
> I've filed a bug report on this:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=103081
>
