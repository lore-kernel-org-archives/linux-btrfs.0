Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:48239 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbbACO3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jan 2015 09:29:41 -0500
Received: by mail-wg0-f43.google.com with SMTP id k14so7484656wgh.30
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Jan 2015 06:29:40 -0800 (PST)
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] Fixing quota error when removing files from a limit exceeded subvols
From: Khaled Ahmed <khaled.gnu@gmail.com>
In-Reply-To: <CA+qeAOqzm14gGx4R5Bc-+hZkyRmTPq_jST+Ke0AyszSD0inHZg@mail.gmail.com>
Date: Sat, 3 Jan 2015 16:29:36 +0200
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <2DAD7296-8CD0-4733-9CED-FF06397B3C99@gmail.com>
References: <1420156114-10849-1-git-send-email-khaled.gnu@gmail.com> <CA+qeAOqzm14gGx4R5Bc-+hZkyRmTPq_jST+Ke0AyszSD0inHZg@mail.gmail.com>
To: Dongsheng Yang <dongsheng081251@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Yang,

This is how to reproduce the bug,

[root@algodev ~]# uname -r
3.18.0+

[root@algodev ~]# btrfs version
Btrfs v3.18-2-g6938452-dirty

[root@algodev ~]# btrfs quota enable LOOP/
[root@algodev ~]# btrfs qgroup show  LOOP/
qgroupid rfer  excl  
-------- ----  ----  
0/5      16384 16384 

[root@algodev ~]# btrfs subvol create LOOP/subvol1
Create subvolume 'LOOP/subvol1'

[root@algodev ~]# btrfs qgroup limit 1g LOOP/subvol1/

[root@algodev ~]# btrfs qgroup show  LOOP/
qgroupid rfer  excl  
-------- ----  ----  
0/5      16384 16384 
0/258    16384 16384 

[root@algodev ~]# dd if=/dev/zero of=LOOP/subvol1/bigfile
dd: writing to ‘LOOP/subvol1/bigfile’: Disk quota exceeded
2097018+0 records in
2097017+0 records out
1073672704 bytes (1.1 GB) copied, 10.0759 s, 107 MB/s

[root@algodev ~]# rm -f LOOP/subvol1/bigfile 
rm: cannot remove ‘LOOP/subvol1/bigfile’: Disk quota exceeded
[root@algodev ~]# 

Best Regards,
~Khaled Ahmed


On Jan 3, 2015, at 4:09 AM, Dongsheng Yang <dongsheng081251@gmail.com> wrote:

> Hi Khaled,
> 
> Could you give use more description about the problem this patch
> is trying to solve? Maybe an example will help a lot to understand it.
> 
> Thanx
> 
> On Fri, Jan 2, 2015 at 7:48 AM, Khaled Ahmed <khaled.gnu@gmail.com> wrote:
>> Signed-off-by: Khaled Ahmed <khaled.gnu@gmail.com>
>> ---
>> fs/btrfs/qgroup.c | 4 ++--
>> 1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
>> index 48b60db..b85200d 100644
>> --- a/fs/btrfs/qgroup.c
>> +++ b/fs/btrfs/qgroup.c
>> @@ -2408,14 +2408,14 @@ int btrfs_qgroup_reserve(struct btrfs_root *root, u64 num_bytes)
>> 
>>                if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_RFER) &&
>>                    qg->reserved + (s64)qg->rfer + num_bytes >
>> -                   qg->max_rfer) {
>> +                   qg->max_rfer - 1 ) {
>>                        ret = -EDQUOT;
>>                        goto out;
>>                }
>> 
>>                if ((qg->lim_flags & BTRFS_QGROUP_LIMIT_MAX_EXCL) &&
>>                    qg->reserved + (s64)qg->excl + num_bytes >
>> -                   qg->max_excl) {
>> +                   qg->max_excl - 1) {
>>                        ret = -EDQUOT;
>>                        goto out;
>>                }
>> --
>> 2.1.0
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

