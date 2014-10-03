Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43361 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbaJCPrQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 3 Oct 2014 11:47:16 -0400
Message-ID: <542EC500.8020805@fb.com>
Date: Fri, 3 Oct 2014 11:47:12 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: make fsck deal with bogus items
References: <1412348066-6284-1-git-send-email-jbacik@fb.com> <CAKcLGm-1Qy7uh6sFPQKD7r5qvc=NiK=KhieV+Zay-uT-Z3n23A@mail.gmail.com>
In-Reply-To: <CAKcLGm-1Qy7uh6sFPQKD7r5qvc=NiK=KhieV+Zay-uT-Z3n23A@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/03/2014 11:46 AM, Mitch Harder wrote:
> On Fri, Oct 3, 2014 at 9:54 AM, Josef Bacik <jbacik@fb.com> wrote:
>> We can deal with corrupt items by deleting them in a few cases.  Fsck can easily
>> recover from a missing extent item or a dir index item.  So if we notice a item
>> is completely bogus and it is of a key that we know we can repair then just
>> delete it and carry on.  Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>>   cmds-check.c                             |  45 +++++++++++++++++++++++++++++++
>>   tests/fsck-tests/005-bad-item-offset.img | Bin 0 -> 398336 bytes
>>   2 files changed, 45 insertions(+)
>>   create mode 100644 tests/fsck-tests/005-bad-item-offset.img
>>
>
> It looks like tests/fsck-tests/005-bad-item-offset.img was added
> unintentionally to this patch.
>

Nope I meant to do that, its a testcase for the patch.  Thanks,

Josef
