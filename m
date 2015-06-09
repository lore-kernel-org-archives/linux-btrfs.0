Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1695 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbbFIOzZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Jun 2015 10:55:25 -0400
Message-ID: <5576FE3E.9050202@fb.com>
Date: Tue, 9 Jun 2015 10:54:54 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: adam900710 <adam900710@gmail.com>
CC: Chris Mason <clm@fb.com>, <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [GIT PULL] Qgroup rework with other Fujitsu fix.
References: <557506BC.701@cn.fujitsu.com>	<5576F3F0.6050900@fb.com> <CAFy8SQW58c7DUUod7FaiNtY2MaoY6ZYt3jacG-RQHJZx+4so7A@mail.gmail.com>
In-Reply-To: <CAFy8SQW58c7DUUod7FaiNtY2MaoY6ZYt3jacG-RQHJZx+4so7A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/09/2015 10:23 AM, adam900710 wrote:
> Sorry, forgot to reply to all.
>
> To Josef,
>
> I am afraid that your conclusion is not right, as in the patch, it will
> only merge delayed refs when they are in same sequence number.
>
> In fact, in the patch, conditions for merge is even more restrict than
> before, it will not allow merging delayed refs for the same extent if
> there are other delayed refs between them.
>

You're right, I missed this bit

+	if (exist->type != ref->type || exist->no_quota != ref->no_quota ||
+	    exist->seq != ref->seq)
+		goto add_tail;

I don't want the merging more strict, I want to merge as much as 
possible, this was the problem with the original qgroup work and that's 
why I reworked all this sequence number crap.  Thanks,

Josef
