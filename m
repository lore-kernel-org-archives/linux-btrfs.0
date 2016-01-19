Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:33565 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756793AbcASCN3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jan 2016 21:13:29 -0500
Subject: Re: [PATCH V6 2/3] btrfs: Introduce new mount option to disable tree
 log replay
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1453168195-18518-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1453168195-18518-3-git-send-email-quwenruo@cn.fujitsu.com>
 <1453168792.6445.2.camel@scientia.net>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <569D9BAA.3090106@cn.fujitsu.com>
Date: Tue, 19 Jan 2016 10:12:58 +0800
MIME-Version: 1.0
In-Reply-To: <1453168792.6445.2.camel@scientia.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Christoph Anton Mitterer wrote on 2016/01/19 02:59 +0100:
> On Tue, 2016-01-19 at 09:49 +0800, Qu Wenruo wrote:
>> Introduce a new mount option "nologreplay" to co-operate with "ro"
>> mount
>> option to get real readonly mount, like "norecovery" in ext* and xfs.
>
> What happened to the nice plans to get a proper dedicated mount option
> for hard ro mounts, that will work even as btrfs changes and would
> require further options to get that behaviour?
>
> Chris.
>

Sorry, I'm convinced by the fsdevel guys, and know I also believe we 
don't need to make things too complicated.
Just norecovery should be good enough.

Further hard ro would need use blockdev to set device to RO.

Thanks,
Qu


