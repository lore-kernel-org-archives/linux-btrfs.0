Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:64684 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753616AbcBVHel (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Feb 2016 02:34:41 -0500
Subject: Re: [Question]: Contributing to btrfs
To: Philippe Loctaux <phil@philippeloctaux.com>
References: <20160220210903.GA3182@carbon.home>
 <20160220224050.GA10864@carbon.home> <56CA61CC.7010703@cn.fujitsu.com>
 <20160222072659.GC17243@carbon.ljdarc.local>
CC: <linux-btrfs@vger.kernel.org>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <56CABA08.2000403@cn.fujitsu.com>
Date: Mon, 22 Feb 2016 15:34:32 +0800
MIME-Version: 1.0
In-Reply-To: <20160222072659.GC17243@carbon.ljdarc.local>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Philippe Loctaux wrote on 2016/02/22 08:26 +0100:
> On Mon, Feb 22, 2016 at 09:18:04AM +0800, Qu Wenruo wrote:
>> https://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git
>> For branch, normally I use 'integration-X.X' as base for kernel development.
>>
>> And for btrfs-progs,
>> https://github.com/kdave/btrfs-progs.git devel
>
> Allright, I'll work from these repos!
>
> Is it fine if I work from Linus's repo?
> Will my patches get rejected if I do so?

It depends.
If it's just small fix, and can be applied on Chris' integration branch, 
that's OK.

In that case, just submit patches to mail list, and if it's OK, 
maintainers like David will pick and rebase them properly.

But for huge modifications, it's recommended to use integration branch, 
as the final pull request is sent to btrfs maintainer Chris, not Linus.

Although all above is just my personal experience, other developers may 
give better advice though.

Thanks,
Qu

>
> --
> Philippe Loctaux
> phil@philippeloctaux.com
>
>


