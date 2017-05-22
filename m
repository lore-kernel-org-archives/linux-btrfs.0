Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:36448 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756846AbdEVBbk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 May 2017 21:31:40 -0400
Received: by mail-oi0-f42.google.com with SMTP id h4so144231501oib.3
        for <linux-btrfs@vger.kernel.org>; Sun, 21 May 2017 18:31:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <eff06906-08a0-4789-10fa-e0613a4ad848@cn.fujitsu.com>
From: Sargun Dhillon <sargun@sargun.me>
Date: Sun, 21 May 2017 18:30:59 -0700
Message-ID: <CAMp4zn-rZzJw5tgMj_fp+TsRu196ObWrkpChPH857+QM_fiwuQ@mail.gmail.com>
Subject: Re: [PATCH 2/8] btrfs: Fail on removing qgroup if del_qgroup_item fails
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
References: <20170520083902.GA4204@ircssh-2.c.rugged-nimbus-611.internal>
 <eff06906-08a0-4789-10fa-e0613a4ad848@cn.fujitsu.com>

On Sun, May 21, 2017 at 6:14 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
>
> At 05/20/2017 04:39 PM, Sargun Dhillon wrote:
>>
>> Previously, we were calling del_qgroup_item, and ignoring the return code
>> resulting in a potential to have divergent in-memory state without an
>> error. Perhaps, it makes sense to handle this error code, and put the
>> filesystem into a read only, or similar state.
>>
>> This patch only adds reporting of the error.
>>
>> Signed-off-by: Sargun Dhillon <sargun@sargun.me>
>> ---
>>   fs/btrfs/qgroup.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index a2add44..7e772ba 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -1303,6 +1303,8 @@ static int __btrfs_remove_qgroup(struct
>> btrfs_trans_handle *trans,
>>                 return -EBUSY;
>>         ret = del_qgroup_item(trans, quota_root, qgroupid);
>> +       if (ret)
>> +               goto out;
>
>
> I think we should continue to remove in-memory qgroup relationship even we
> didn't find corresponding qgroup item.
>
> IIRC it's better to catch less severe error like -ENOENT and continue.
>
> Although normally previous find_qgroup_rb() should return -ENOENT before we
> continue to del_qgroup_item(), but catching -ENOENT here could make the code
> more robust.
Agreed. Will fix this. I think it also return ENOMEM.
>
> Thanks,
> Qu
>
>
>>         while (!list_empty(&qgroup->groups)) {
>>                 list = list_first_entry(&qgroup->groups,
>>
>
>
