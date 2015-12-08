Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:45158 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932688AbbLHGIo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 01:08:44 -0500
Subject: Re: [PATCH] btrfs: Introduce new mount option to disable tree log
 replay
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <1449468402-27914-1-git-send-email-quwenruo@cn.fujitsu.com>
 <5665B596.3060309@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <566673CD.6070406@cn.fujitsu.com>
Date: Tue, 8 Dec 2015 14:08:13 +0800
MIME-Version: 1.0
In-Reply-To: <5665B596.3060309@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Austin S Hemmelgarn wrote on 2015/12/07 11:36 -0500:
> On 2015-12-07 01:06, Qu Wenruo wrote:
>> Introduce a new mount option "nologreplay" to co-operate with "ro" mount
>> option to get real readonly mount, like "norecovery" in ext* and xfs.
>>
>> Since the new parse_options() need to check new flags at remount time,
>> so add a new parameter for parse_options().
>>
>
> Passes xfstests and a handful of other things that I really should just
> take the time to integrate into xfstests, so:
> Tested-by: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>
Thanks for the test.

But I'm afraid you may need to test v2 patch again, as the v2 changed 
some behavior.

Thanks,
Qu


