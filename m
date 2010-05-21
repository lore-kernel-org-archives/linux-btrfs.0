From: Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH 07/10] btrfs: fix wrong ctime when adding link
Date: Fri, 21 May 2010 17:36:41 +0800
Message-ID: <4BF65429.2030802@cn.fujitsu.com>
References: <4BF4E336.40603@cn.fujitsu.com> <AANLkTilVU-QFaBJKnjt7XF95RPpmrBv1EaZkFtfUraYa@mail.gmail.com>
Reply-To: miaox@cn.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: Mike Fedyk <mfedyk@mikefedyk.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilVU-QFaBJKnjt7XF95RPpmrBv1EaZkFtfUraYa@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

on 2010-5-20 17:01, Mike Fedyk wrote:
> On Thu, May 20, 2010 at 12:22 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>> the ctime of file has not been updated when I create a link for it.
>>
>> Steps to reproduce:
>>  # touch file1
>>  # stat -c %Z file1
>>  1273592239
>>  # link flink1 file1
>>  # stat -c %Z file1
>>  1273592239             <-- have not been updated
>>
>> This patch fix this problem.
>>
>> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>> ---
>>  fs/btrfs/inode.c |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>> index a85b90c..5271887 100644
>> --- a/fs/btrfs/inode.c
>> +++ b/fs/btrfs/inode.c
>> @@ -4218,8 +4218,12 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
>>
>>                btrfs_i_size_write(parent_inode, parent_inode->i_size +
>>                                   name_len * 2);
>> -               parent_inode->i_mtime = parent_inode->i_ctime = CURRENT_TIME;
>> -               ret = btrfs_update_inode(trans, root, parent_inode);
>> +               parent_inode->i_mtime = parent_inode->i_ctime = inode->i_ctime
>> +                                     = CURRENT_TIME;
>> +
>> +               ret = btrfs_update_inode(trans, root, inode);
>> +               if (!ret)
>> +                       ret = btrfs_update_inode(trans, root, parent_inode);
> 
> You only update parent inode if write to current inode fails?

I think if write to current inode fails, updating the parent inode is unnecessary,
it is better to do rollback.

> 
> Also should you be updating the ctime of parent inode even with link
> count of parent inode is not modified (btrfs always reports link count
> of 1 on directories)?

the i_size of the parent inode is changed, so we must update the ctime of parent inode.

Thanks

