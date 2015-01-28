Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23055 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761106AbbA1CHB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Jan 2015 21:07:01 -0500
Message-ID: <54C84462.1030408@cn.fujitsu.com>
Date: Wed, 28 Jan 2015 10:07:30 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Noah Massey <noah.massey@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: read_tree_block() and read_node_slot()
 cleanup.
References: <1422328363-11405-1-git-send-email-quwenruo@cn.fujitsu.com> <CADfjVrgL1XcV9=4hhGzhK5cB-sFWmMG5OUwjXZOuNnrzvauaiw@mail.gmail.com>
In-Reply-To: <CADfjVrgL1XcV9=4hhGzhK5cB-sFWmMG5OUwjXZOuNnrzvauaiw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 1/2] btrfs-progs: read_tree_block() and 
read_node_slot() cleanup.
From: Noah Massey <noah.massey@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年01月28日 00:48
> On Mon, Jan 26, 2015 at 10:12 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Allow read_tree_block() and read_node_slot() to return error pointer.
>> This should help caller to get more specified error number.
>>
>> For existing callers, change (!eb) judgmentt to
>> (!extent_buffer_uptodate(eb)) to keep the compatibility, and for caller
>> missing the check, use PTR_ERR(eb) if possible.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> [...snipped...]
>> @@ -2962,6 +2962,12 @@ static int noinline walk_down_tree(struct btrfs_trans_handle *trans,
>>                          next = read_tree_block(root, bytenr, blocksize,
>>                                                 ptr_gen);
>>                          mutex_lock(&root->fs_info->fs_mutex);
>> +                       if (!extent_buffer_uptodate(next)) {
>> +                               if (IS_ERR(next))
>> +                                       ret = PTR_ERR(next);
> + else
Oh, my fault.
Thanks for pointing it out.

Thanks,
Qu
>
>
>> +                               ret = -EIO;
>> +                               break;
>> +                       }
>>                  }
>>                  WARN_ON(*level <= 0);
>>                  if (path->nodes[*level-1])
>> diff --git a/extent_io.c b/extent_io.c
>> index 9c982f9..3a8f96b 100644
>> --- a/extent_io.c
>> +++ b/extent_io.c
>> @@ -845,9 +845,8 @@ int clear_extent_buffer_uptodate(struct extent_io_tree *tree,
>>
>>   int extent_buffer_uptodate(struct extent_buffer *eb)
>>   {
>> -       if (!eb)
>> +       if (!eb || IS_ERR(eb))
>>                  return 0;
>> -
>>          if (eb->flags & EXTENT_UPTODATE)
>>                  return 1;
>>          return 0;
>> diff --git a/print-tree.c b/print-tree.c
>> index 70a7acc..3a7c13c 100644
>> --- a/print-tree.c
>> +++ b/print-tree.c
>> @@ -1060,7 +1060,7 @@ void btrfs_print_tree(struct btrfs_root *root, struct extent_buffer *eb, int fol
>>                                               btrfs_node_blockptr(eb, i),
>>                                               size,
>>                                               btrfs_node_ptr_generation(eb, i));
>> -               if (!next) {
>> +               if (!extent_buffer_uptodate(next)) {
>>                          fprintf(stderr, "failed to read %llu in tree %llu\n",
>>                                  (unsigned long long)btrfs_node_blockptr(eb, i),
>>                                  (unsigned long long)btrfs_header_owner(eb));
>> diff --git a/qgroup-verify.c b/qgroup-verify.c
>> index c98c751..f7a94bf 100644
>> --- a/qgroup-verify.c
>> +++ b/qgroup-verify.c
>> @@ -513,7 +513,7 @@ static int travel_tree(struct btrfs_fs_info *info, struct btrfs_root *root,
>>   //            bytenr, num_bytes, ref_parent);
>>
>>          eb = read_tree_block(root, bytenr, num_bytes, 0);
>> -       if (!eb)
>> +       if (!extent_buffer_uptodate(eb))
>>                  return -EIO;
>>
>>          ret = 0;
>> --
>> 2.2.2
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

