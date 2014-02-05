Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:63556 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbaBENXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Feb 2014 08:23:39 -0500
Received: by mail-pd0-f179.google.com with SMTP id q10so350825pdj.24
        for <linux-btrfs@vger.kernel.org>; Wed, 05 Feb 2014 05:23:38 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 1/2] Btrfs: switch to btrfs_previous_extent_item()
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CAL3q7H7n+L2CqT9whDDT1ZjUzgU378HUhOuQHhjKUp7eiKD=aw@mail.gmail.com>
Date: Wed, 5 Feb 2014 21:23:33 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <337FC422-D102-4310-A714-FA35538DD402@gmail.com>
References: <1391186525-2965-1-git-send-email-wangshilong1991@gmail.com> <CAL3q7H7n+L2CqT9whDDT1ZjUzgU378HUhOuQHhjKUp7eiKD=aw@mail.gmail.com>
To: fdmanana@gmail.com
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So i knew what was wrong here, we need found_key while btrfs_previous_extent_item() did set
it properly..^_^

I will send a v2 to fix this, thanks!


> On Fri, Jan 31, 2014 at 4:42 PM, Wang Shilong <wangshilong1991@gmail.com> wrote:
>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> 
>> Since we have introduced btrfs_previous_extent_item() to search previous
>> extent item, just switch into it.
>> 
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
> 
> Hi Shilong,
> 
> This patch is making btrfs/004 fail for me, consistently:
> 
> btrfs/004 99s ... [failed, exit status 1] - output mismatch (see
> /home/fdmanana/git/hub/xfstests_2/results//btrfs/004.out.bad)
>    --- tests/btrfs/004.out 2013-11-26 18:25:29.263333714 +0000
>    +++ /home/fdmanana/git/hub/xfstests_2/results//btrfs/004.out.bad
> 2014-02-05 12:20:26.053570545 +0000
>    @@ -1,3 +1,100 @@
>     QA output created by 004
>     *** test backref walking
>    -*** done
>    +unexpected output from
>    + /home/fdmanana/git/hub/btrfs-progs/btrfs inspect-internal
> logical-resolve -P 137719808 /home/fdmanana/btrfs-tests/scratch_1
>    +expected inum: 278, expected address: 53248, file:
> /home/fdmanana/btrfs-tests/scratch_1/snap1/p0/d3/da/d174/d1c/d3e/d4d/d16f/f132,
> got:
>    +ioctl ret=-1, error: No such file or directory
>    ...
>    (Run 'diff -u tests/btrfs/004.out
> /home/fdmanana/git/hub/xfstests_2/results//btrfs/004.out.bad'  to see
> the entire diff)
> Ran: btrfs/004
> Failures: btrfs/004
> Failed 1 of 1 tests
> 
> See comment inline below as well.
> 
> Thanks
> 
>> ---
>> fs/btrfs/backref.c | 34 +++-------------------------------
>> 1 file changed, 3 insertions(+), 31 deletions(-)
>> 
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index aded3ef..4f59f07 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -1333,37 +1333,9 @@ int extent_from_logical(struct btrfs_fs_info *fs_info, u64 logical,
>>        if (ret < 0)
>>                return ret;
>> 
>> -       while (1) {
>> -               u32 nritems;
>> -               if (path->slots[0] == 0) {
>> -                       btrfs_set_path_blocking(path);
>> -                       ret = btrfs_prev_leaf(fs_info->extent_root, path);
>> -                       if (ret != 0) {
>> -                               if (ret > 0) {
>> -                                       pr_debug("logical %llu is not within "
>> -                                                "any extent\n", logical);
>> -                                       ret = -ENOENT;
>> -                               }
>> -                               return ret;
>> -                       }
>> -               } else {
>> -                       path->slots[0]--;
>> -               }
>> -               nritems = btrfs_header_nritems(path->nodes[0]);
>> -               if (nritems == 0) {
>> -                       pr_debug("logical %llu is not within any extent\n",
>> -                                logical);
>> -                       return -ENOENT;
>> -               }
>> -               if (path->slots[0] == nritems)
>> -                       path->slots[0]--;
>> -
>> -               btrfs_item_key_to_cpu(path->nodes[0], found_key,
>> -                                     path->slots[0]);
>> -               if (found_key->type == BTRFS_EXTENT_ITEM_KEY ||
>> -                   found_key->type == BTRFS_METADATA_ITEM_KEY)
>> -                       break;
>> -       }
>> +       ret = btrfs_previous_extent_item(fs_info->extent_root, path, 0);
>> +       if (ret)
>> +               return ret;
> 
> This isn't equivalent to what we had before. We're now returning 1
> when we previously returned -ENOENT. However this isn't what's making
> the test fail.
> 
>> 
>>        if (found_key->type == BTRFS_METADATA_ITEM_KEY)
>>                size = fs_info->extent_root->leafsize;
>> --
>> 1.8.4
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> Filipe David Manana,
> 
> "Reasonable men adapt themselves to the world.
> Unreasonable men adapt the world to themselves.
> That's why all progress depends on unreasonable men."

