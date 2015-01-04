Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f50.google.com ([209.85.213.50]:63734 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbbADKyB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 4 Jan 2015 05:54:01 -0500
Received: by mail-yh0-f50.google.com with SMTP id 29so10540593yhl.23
        for <linux-btrfs@vger.kernel.org>; Sun, 04 Jan 2015 02:54:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2DAD7296-8CD0-4733-9CED-FF06397B3C99@gmail.com>
References: <1420156114-10849-1-git-send-email-khaled.gnu@gmail.com>
	<CA+qeAOqzm14gGx4R5Bc-+hZkyRmTPq_jST+Ke0AyszSD0inHZg@mail.gmail.com>
	<2DAD7296-8CD0-4733-9CED-FF06397B3C99@gmail.com>
Date: Sun, 4 Jan 2015 18:54:00 +0800
Message-ID: <CA+qeAOrhaNqrMK+UweM5+BrPahs56rdExXZwczM0i8G6zgi4_A@mail.gmail.com>
Subject: Re: [PATCH] Fixing quota error when removing files from a limit
 exceeded subvols
From: Dongsheng Yang <dongsheng081251@gmail.com>
To: Khaled Ahmed <khaled.gnu@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 3, 2015 at 10:29 PM, Khaled Ahmed <khaled.gnu@gmail.com> wrote:
> Hi Yang,
>
> This is how to reproduce the bug,
>
> [root@algodev ~]# uname -r
> 3.18.0+
>
> [root@algodev ~]# btrfs version
> Btrfs v3.18-2-g6938452-dirty
>
> [root@algodev ~]# btrfs quota enable LOOP/
> [root@algodev ~]# btrfs qgroup show  LOOP/
> qgroupid rfer  excl
> -------- ----  ----
> 0/5      16384 16384
>
> [root@algodev ~]# btrfs subvol create LOOP/subvol1
> Create subvolume 'LOOP/subvol1'
>
> [root@algodev ~]# btrfs qgroup limit 1g LOOP/subvol1/
>
> [root@algodev ~]# btrfs qgroup show  LOOP/
> qgroupid rfer  excl
> -------- ----  ----
> 0/5      16384 16384
> 0/258    16384 16384
>
> [root@algodev ~]# dd if=/dev/zero of=LOOP/subvol1/bigfile
> dd: writing to ‘LOOP/subvol1/bigfile’: Disk quota exceeded
> 2097018+0 records in
> 2097017+0 records out
> 1073672704 bytes (1.1 GB) copied, 10.0759 s, 107 MB/s
>
> [root@algodev ~]# rm -f LOOP/subvol1/bigfile
> rm: cannot remove ‘LOOP/subvol1/bigfile’: Disk quota exceeded

Hi Ahmed,
Okey, thanx for your example.

a). I guess your problem is getting a EQUOTA when remove a file here.
It's because we need to reserve some metadata in transaction of btrfs_unlink().

b). I think you patch here will not solve your problem. The root cause is
current quota in btrfs is accounting data and metadata together.

c). I admit getting a EQUOTA is strange when you did not writing anything but
only remove a file. I had a plan in my TODO list which is making qgroup to
limit and account the size in three modes, data, metadata and both.
Then in this case
if you only limit the size of data, you will not get a EQUOTA any more.

Thanx
Yang
> [root@algodev ~]#
>
> Best Regards,
> ~Khaled Ahmed
>
>
> On Jan 3, 2015, at 4:09 AM, Dongsheng Yang <dongsheng081251@gmail.com> wrote:
>
>> Hi Khaled,
>>
>> Could you give use more description about the problem this patch
>> is trying to solve? Maybe an example will help a lot to understand it.
>>
>> Thanx
>>
>> On Fri, Jan 2, 2015 at 7:48 AM, Khaled Ahmed <khaled.gnu@gmail.com> wrote:
>>> Signed-off-by: Khaled Ahmed <khaled.gnu@gmail.com>
>>> ---
>>> fs/btrfs/qgroup.c | 4 ++--
>>> 1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>>> index 48b60db..b85200d 100644
>>> --- a/fs/btrfs/qgroup.c
>>> +++ b/fs/btrfs/qgroup.c
>>> @@ -2408,14 +2408,14 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
>>>
>>>                if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
>>>                    qg->reserved + (s64)qg->rfer + num_bytes >
>>> -                   qg->max_rfer) {
>>> +                   qg->max_rfer - 1 ) {
>>>                        ret = -EDQUOT;
>>>                        goto out;
>>>                }
>>>
>>>                if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
>>>                    qg->reserved + (s64)qg->excl + num_bytes >
>>> -                   qg->max_excl) {
>>> +                   qg->max_excl - 1) {
>>>                        ret = -EDQUOT;
>>>                        goto out;
>>>                }
>>> --
>>> 2.1.0
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
