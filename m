Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:31256 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbaAMB2y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jan 2014 20:28:54 -0500
Message-ID: <52D34115.7010605@cn.fujitsu.com>
Date: Mon, 13 Jan 2014 09:27:49 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: Wang Shilong <wangshilong1991@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/3] Btrfs: fix missing inline refs when walking backrefs
References: <1389533914-2272-1-git-send-email-wangshilong1991@gmail.com> <1389533914-2272-4-git-send-email-wangshilong1991@gmail.com> <CAL3q7H66_b9qZFtT6sU7Ao0-xGbQJncmGFJ8h6x=8jHF9uMpUw@mail.gmail.com>
In-Reply-To: <CAL3q7H66_b9qZFtT6sU7Ao0-xGbQJncmGFJ8h6x=8jHF9uMpUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

On 01/12/2014 11:36 PM, Filipe David Manana wrote:
> On Sun, Jan 12, 2014 at 1:38 PM, Wang Shilong <wangshilong1991@gmail.com> wrote:
>> From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>>
>> If @slot=0, we may have an expected item in the previous leaf,
>> So we should handle that case, otherwise, we will miss inline refs
>> ,fix it.
> Hi Shilong.
>
> How can this happen exactly?
>
> So the search key, regardless of having an BTRFS_EXTENT_ITEM_KEY or  a
> BTRFS_METADATA_ITEM_KEY type, always has an offset set to (u64)-1.
> This means the btrfs_search_slot call will always return 1 (not found,
> as expected) or an error.
>
> And btrfs_search_slot, when it doesn't find a key and if that key
> should be the first item in a leaf, it makes the path point to the
> previous leaf with a "path->slots[0] ==
> btrfs_header_nritems(path->nodes[0])" (see [1]), otherwise to some
> value > 0. The only cases I can imagine getting "path->slots[0] == 0"
> is if we hit the first, i.e. left most, leaf in the btree or if the
> btree consists only of 1 leaf (no nodes) - in these cases there's
> isn't a previous leaf.
>
> Did I miss something here?
>
> thanks
>
> [1] - https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/ctree.c?id=refs/tags/v3.13-rc8#n2629
You are right, i was missing something when i made this patch.
Really thanks for you reviewing and correcting me!:-)

Thanks,
Wang
>
>> Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
>> ---
>>   fs/btrfs/backref.c | 13 ++++++-------
>>   1 file changed, 6 insertions(+), 7 deletions(-)
>>
>> diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
>> index 964679c..4ccd726 100644
>> --- a/fs/btrfs/backref.c
>> +++ b/fs/btrfs/backref.c
>> @@ -893,14 +893,13 @@ again:
>>                  spin_unlock(&delayed_refs->lock);
>>          }
>>
>> -       if (path->slots[0]) {
>> -               struct extent_buffer *leaf;
>> -               int slot;
>> +       ret = btrfs_previous_extent_item(fs_info->extent_root, path,
>> +                                        key.objectid);
>> +       if (ret < 0)
>> +               goto out;
>>
>> -               path->slots[0]--;
>> -               leaf = path->nodes[0];
>> -               slot = path->slots[0];
>> -               btrfs_item_key_to_cpu(leaf, &key, slot);
>> +       if (ret == 0) {
>> +               btrfs_item_key_to_cpu(path->nodes[0], &key, path->slots[0]);
>>                  if (key.objectid == bytenr &&
>>                      (key.type == BTRFS_EXTENT_ITEM_KEY ||
>>                       key.type == BTRFS_METADATA_ITEM_KEY)) {
>> --
>> 1.8.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

