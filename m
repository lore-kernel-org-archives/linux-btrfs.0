Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7499 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932066AbbFJAha convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 20:37:30 -0400
Message-ID: <557785DE.9030307@cn.fujitsu.com>
Date: Wed, 10 Jun 2015 08:33:34 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, adam900710 <adam900710@gmail.com>
CC: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Qgroup rework with other Fujitsu fix.
References: <557506BC.701@cn.fujitsu.com>	<5576F3F0.6050900@fb.com> <CAFy8SQW58c7DUUod7FaiNtY2MaoY6ZYt3jacG-RQHJZx+4so7A@mail.gmail.com> <5576FE3E.9050202@fb.com>
In-Reply-To: <5576FE3E.9050202@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [GIT PULL] Qgroup rework with other Fujitsu fix.
From: Josef Bacik <jbacik@fb.com>
To: adam900710 <adam900710@gmail.com>
Date: 2015年06月09日 22:54

> On 06/09/2015 10:23 AM, adam900710 wrote:
>> Sorry, forgot to reply to all.
>>
>> To Josef,
>>
>> I am afraid that your conclusion is not right, as in the patch, it will
>> only merge delayed refs when they are in same sequence number.
>>
>> In fact, in the patch, conditions for merge is even more restrict than
>> before, it will not allow merging delayed refs for the same extent if
>> there are other delayed refs between them.
>>
>
> You're right, I missed this bit
>
> +    if (exist->type != ref->type || exist->no_quota != ref->no_quota ||
> +        exist->seq != ref->seq)
> +        goto add_tail;
>
> I don't want the merging more strict, I want to merge as much as
> possible, this was the problem with the original qgroup work and that's
> why I reworked all this sequence number crap.  Thanks,
>
> Josef
The old problem of qgroup is addressed by later patches, which reworks
the whole qgroup framework again.
So qgroup will not be a problem.

This patch is mainly used to cleanup the delayed-ref codes, at a little
cost of restrict merging condition, but delayed-refs will still be
mergeable unlike the very codes before your rework.

It's possible not to include this patch in this pull, but I still prefer
to include this one.
As old implements is not so clear and easy to cause bug, the new
straight-forward data structure with less codes will definitely make
sense for maintaining.

Thanks,
Qu
