Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:34822 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964799AbbDIJ0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 05:26:14 -0400
Message-ID: <552645AE.4090507@cn.fujitsu.com>
Date: Thu, 9 Apr 2015 17:26:06 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Piotr Szymaniak <szarpaj@grubelek.pl>
CC: BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: snapshot space use
References: <201504091039.33442.russell@coker.com.au> <5525CBA1.5000408@cn.fujitsu.com> <20150409090210.GZ9470@wloczykij>
In-Reply-To: <20150409090210.GZ9470@wloczykij>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: snapshot space use
From: Piotr Szymaniak <szarpaj@grubelek.pl>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年04月09日 17:02

> On Thu, Apr 09, 2015 at 08:45:21AM +0800, Qu Wenruo wrote:
>> *snip*
>> NOTE: quota is not so stable and has some problem, but should give
>> you enough info.
>
> Those are related to actually using quota or can also hit you when you
> want to use it just for things like this snapshot space use?
Using quota has more problems. Like exceeding quota make you unable to 
delete any file(like a deadlock).

Your use case, just showing how much space you used, may still hit some 
unusual problem like inaccurate number or even minus number, with 
performance drop.
But overall, it should be OK and meets your need.

Thanks,
Qu
>
>
> Piotr Szymaniak.
>
