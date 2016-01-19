Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:30473 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756806AbcASCOO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 21:14:14 -0500
Subject: Re: [PATCH V6 1/3] btrfs: Introduce new mount option usebackuproot to
 replace recovery
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1453168195-18518-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1453168195-18518-2-git-send-email-quwenruo@cn.fujitsu.com>
 <1453168853.6445.3.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <569D9BDB.50400@cn.fujitsu.com>
Date: Tue, 19 Jan 2016 10:13:47 +0800
MIME-Version: 1.0
In-Reply-To: <1453168853.6445.3.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Christoph Anton Mitterer wrote on 2016/01/19 03:00 +0100:
> On Tue, 2016-01-19 at 09:49 +0800, Qu Wenruo wrote:
>> Also, since "backuproot" will only affect mount behavior and after
>> open_ctree() it has nothing to do with the filesystem, so clear the
>> flag
>> after mount succeeded.
> Haven't we talked about that it may be better to use something like
> "usebackuproot",... cause just "backuproot" rather sounds like
> "[perform] backup [of] root"?
>
> Cheers,
> Chris.
>
Oh, comment message copy and paste error.

The code is using "usebackuproot".

Thanks for pointing this out.
I'll update it soon.

Thanks,
Qu


