Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f51.google.com ([209.85.128.51]:57779 "EHLO
	mail-qe0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab3JJBTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 21:19:33 -0400
MIME-Version: 1.0
In-Reply-To: <20131010005220.GI16461@localhost.localdomain>
References: <1381362030-29595-1-git-send-email-geyslan@gmail.com>
	<20131010005220.GI16461@localhost.localdomain>
Date: Wed, 9 Oct 2013 22:19:31 -0300
Message-ID: <CAGG-pUR2hQJ48z4SMi8S4uYVV6GvhQ9vDS5bbvZ41OfymZyw0Q@mail.gmail.com>
Subject: Re: [PATCH v3] btrfs: Fix memory leakage in the tree-log.c
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: chris.mason@fusionio.com, linux-btrfs@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Josef,

Thank you. Sending v4.

Geyslan Gregório Bem
hackingbits.com


2013/10/9 Josef Bacik <jbacik@fusionio.com>:
> On Wed, Oct 09, 2013 at 08:40:30PM -0300, Geyslan G. Bem wrote:
>> In some cases, add_inode_ref() is returning without freeing
>> the 'name' pointer.
>>
>> Added bail out to explicitly call kfree when necessary.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>> ---
>>  fs/btrfs/tree-log.c | 10 ++++++++--
>>  1 file changed, 8 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
>> index 79f057c..ad7cc5f 100644
>> --- a/fs/btrfs/tree-log.c
>> +++ b/fs/btrfs/tree-log.c
>> @@ -1170,13 +1170,16 @@ static noinline int add_inode_ref(struct btrfs_trans_handle *trans,
>>                       if (!dir)
>>                               dir = read_one_inode(root, parent_objectid);
>>                       if (!dir)
>> -                             return -ENOENT;
>> +                     {
>> +                             ret = -ENOENT;
>> +                             goto bail;
>> +                     }
>
> Code formatting is
>
> if () {
> }
>
> not
>
> if ()
> {
> }
>
>
>>               } else {
>>                       ret = ref_get_fields(eb, ref_ptr, &namelen, &name,
>>                                            &ref_index);
>>               }
>>               if (ret)
>> -                     return ret;
>> +                     goto bail;
>>
>>               /* if we already have a perfect match, we're done */
>>               if (!inode_in_dir(root, path, btrfs_ino(dir), btrfs_ino(inode),
>> @@ -1227,6 +1230,9 @@ out:
>>       btrfs_release_path(path);
>>       iput(dir);
>>       iput(inode);
>> +bail:
>> +     if (name)
>> +             kfree(name);
>
> kfree already does the if (name) part of this so this is redundant.  Also if you
> are going to do this you need to set name = NULL; after the kfree above it
> otherwise we have a double free.  Thanks,
>
> Josef
