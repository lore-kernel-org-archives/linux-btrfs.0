Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:46878 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaBYBkt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Feb 2014 20:40:49 -0500
Message-ID: <530BF42E.4010006@cn.fujitsu.com>
Date: Tue, 25 Feb 2014 09:38:54 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: fsck: fix wrong return value in check_block()
References: <1393242914-21867-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <CAKcLGm8v=1JwxrJ4JAiiGoZLTLon-ttRzrVBTsHgf_U1Lx9_Ng@mail.gmail.com>
In-Reply-To: <CAKcLGm8v=1JwxrJ4JAiiGoZLTLon-ttRzrVBTsHgf_U1Lx9_Ng@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Mitch,

On 02/25/2014 07:03 AM, Mitch Harder wrote:
> On Mon, Feb 24, 2014 at 5:55 AM, Wang Shilong
> <wangsl.fnst@cn.fujitsu.com> wrote:
>> We found btrfsck will output backrefs mismatch while the filesystem
>> is defenitely ok.
>>
>> The problem is that check_block() don't return right value,which
>> makes btrfsck won't walk all tree blocks thus we don't get a consistent
>> filesystem, we will fail to check extent refs etc.
>>
>> Reported-by: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>   cmds-check.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/cmds-check.c b/cmds-check.c
>> index a2afae6..253569f 100644
>> --- a/cmds-check.c
>> +++ b/cmds-check.c
>> @@ -2477,7 +2477,7 @@ static int check_block(struct btrfs_trans_handle *trans,
>>          struct cache_extent *cache;
>>          struct btrfs_key key;
>>          enum btrfs_tree_block_status status;
>> -       int ret = 1;
>> +       int ret = 0;
>>          int level;
>>
>>          cache = lookup_cache_extent(extent_cache, buf->start, buf->len);
>> --
> I tried this fix on a broken btrfs volume I've been trying to repair,
> and it seemed to put me in an infinite loop.
>
> I agree that something seems wrong with the way the caller of
> check_block uses the return value, and I also noticed that it seemed
> to exit before walking all the tree blocks.
>
> But I think the problem is more subtle than flipping the default ret
> value from 1 to 0.
No, not really even though i know there are other problems with fsck 
repair mode.
But this problem should be fixed and pushed into btrfs-progsv3.13.(Notice,
the below problem did not exist in btrfs-progsv3.12)

An easy way to trigger this problem:

# mkfs.btrfs -f /dev/sda9
# mount /dev/sda9 /mnt
# dd if=/dev/zero of=/mnt/data bs=4k count=10240 oflag=direct
# btrfs sub snapshot /mnt /mnt/snap1
# btrfs sub snapshot /mnt /mnt/snap2
# umount /mnt
# btrfs check /dev/sda9

After applying this patch, the above problems did not exist.
Feel free to correct me if i miss something here.^_^


Thanks,
Wang
>

