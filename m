Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:40863 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932260AbbIYNiI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 09:38:08 -0400
Subject: Re: [PATCH] Btrfs: add a flags field to btrfs_transaction
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
References: <1443106023-2158-1-git-send-email-jbacik@fb.com>
 <CAHji153OssW8n0ukTeiYk+2dgSmB0Wcfzy=b7P5fnh370929bg@mail.gmail.com>
CC: <kernel-team@fb.com>, <linux-btrfs@vger.kernel.org>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <56054E39.4090407@fb.com>
Date: Fri, 25 Sep 2015 09:38:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAHji153OssW8n0ukTeiYk+2dgSmB0Wcfzy=b7P5fnh370929bg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/25/2015 08:30 AM, Holger Hoffstätte wrote:
> Followup from my observation wrt. "Btrfs: change how we wait for
> pending ordered extents" and balance sitting idle:
>
> On Thu, Sep 24, 2015 at 4:47 PM, Josef Bacik <jbacik@fb.com> wrote:
>> I want to set some per transaction flags, so instead of adding yet another int
>> lets just convert the current two int indicators to flags and add a flags field
>> for future use.  Thanks,
>
> ..snip..
>
>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
>> index ff64689..3f5a781 100644
>> --- a/fs/btrfs/volumes.c
>> +++ b/fs/btrfs/volumes.c
>> @@ -1399,7 +1399,7 @@ again:
>>                  btrfs_error(root->fs_info, ret,
>>                              "Failed to remove dev extent item");
>>          } else {
>> -               trans->transaction->have_free_bgs = 1;
>> +               set_bit(BTRFS_TRANS_DIRTY_BG_RUN, &trans->transaction->flags);
>
> Judging from the rest of the code transformation TRANS_DIRTY_BG_RUN
> seems like the wrong bit to set here. A quick test with
> set_bit(BTRFS_TRANS_HAVE_FREE_BGS) confirms that it fixes the balance
> delays.

Haha oops, thanks for catching that, I'll fix it up locally and send out 
an updated one in a bit.

Josef

