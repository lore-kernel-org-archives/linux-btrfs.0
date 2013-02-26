Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab3BZEgo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Feb 2013 23:36:44 -0500
Message-ID: <512C3BD9.6000008@redhat.com>
Date: Mon, 25 Feb 2013 22:36:41 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Shilong Wang <wangshilong1991@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 14/17] btrfs-progs: fix mem leak in resolve_root
References: <1361832890-40921-1-git-send-email-sandeen@redhat.com> <1361832890-40921-15-git-send-email-sandeen@redhat.com> <CAP9B-QkUP7ZftFkWw-_W-K2YKT8KdymabTf2mEK8Z_mgiKaJnA@mail.gmail.com>
In-Reply-To: <CAP9B-QkUP7ZftFkWw-_W-K2YKT8KdymabTf2mEK8Z_mgiKaJnA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/25/13 6:36 PM, Shilong Wang wrote:
> Hello, Eric
> 
> 2013/2/26 Eric Sandeen <sandeen@redhat.com>:
>> If we exit with error we must free the allocated memory
>> to avoid a leak.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>  btrfs-list.c |    8 ++++++--
>>  1 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/btrfs-list.c b/btrfs-list.c
>> index 851c059..8c3f84d 100644
>> --- a/btrfs-list.c
>> +++ b/btrfs-list.c
>> @@ -568,8 +568,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
>>                 * ref_tree = 0 indicates the subvolumes
>>                 * has been deleted.
>>                 */
>> -               if (!found->ref_tree)
>> +               if (!found->ref_tree) {
>> +                       free(full_path);
>>                         return -ENOENT;
>> +               }
>>                 int add_len = strlen(found->path);
>>
>>                 /* room for / and for null */
>> @@ -612,8 +614,10 @@ static int resolve_root(struct root_lookup *rl, struct root_info *ri,
>>                 * subvolume was deleted.
>>                 */
>>                 found = root_tree_search(rl, next);
>> -               if (!found)
>> +               if (!found) {
>> +                       free(full_path);
>>                         return -ENOENT;
>> +               }
>>         }
>>
>>         ri->full_path = full_path;
>> --
>> 1.7.1
> 
> I think the patch is wrong;
> Here we return ENOENT, it means a subvolume/snapshot deletion happens.
> We just filter them in the filter_root, But the free work is done by
> the function all_subvolume_free..
> so your modification will cause a double free..

Thanks for the review.  I'll admit that when looking at too many of
these static checker reports, sometimes things look obvious when
they are actually subtle, and I've certainly made mistakes before. :)

However, full_path location doesn't seem to be available outside the
scope of this function unless we exit normally and do:

        ri->full_path = full_path;

        return 0;
}

If we exit early at the -ENOENT points, it seems that full_path
is leaked; there are no other references to it.
Am I missing something?

Thanks,
-Eric

> Thanks,
> Wang
> 
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

