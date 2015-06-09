Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.synology.com ([59.124.41.242]:24042 "EHLO
	mail.synology.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbbFIKEx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Jun 2015 06:04:53 -0400
Received: from mail-ig0-f180.google.com (mail-ig0-f180.google.com [209.85.213.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: robbieko@synology.com)
	by mail.synology.com (Postfix) with ESMTPSA id 0837F619A15
	for <linux-btrfs@vger.kernel.org>; Tue,  9 Jun 2015 18:04:45 +0800 (CST)
Received: by igbhj9 with SMTP id hj9so9147483igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Jun 2015 03:04:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H5q0bfsdXajZVe_WZ73xUdpfFL9XUmOa31=WR5PL+Xjmw@mail.gmail.com>
References: <1433416690-19177-1-git-send-email-robbieko@synology.com>
	<1433416690-19177-6-git-send-email-robbieko@synology.com>
	<CAL3q7H4LR_72Gs6mrtoaanEum__U8h_tq=VR0CgdV3saJKu1Xw@mail.gmail.com>
	<CAJiZgcpNgyka+L+PRx+QGhb5S8Q10Q3yOrdkcg3OLKKpJczpng@mail.gmail.com>
	<CAL3q7H5q0bfsdXajZVe_WZ73xUdpfFL9XUmOa31=WR5PL+Xjmw@mail.gmail.com>
Date: Tue, 9 Jun 2015 18:04:44 +0800
Message-ID: <CAJiZgcoJvt_ZM60kjuzDRWZRBXo8qQ1KTaedrzEAUEyYSkE60g@mail.gmail.com>
Subject: Re: [PATCH 5/5] Btrfs: incremental send, fix rmdir not send utimes
From: Robbie Ko <robbieko@synology.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe,

2015-06-08 22:00 GMT+08:00 Filipe David Manana <fdmanana@gmail.com>:
> On Mon, Jun 8, 2015 at 4:44 AM, Robbie Ko <robbieko@synology.com> wrote:
>> Hi Filipe,
>
> Hi Robbie,
>
>>
>> I've fixed "don't send utimes for non-existing directory" with another solution.
>>
>>  In apply_dir_move(), the old parent dir. and new parent dir. will be
>> updated after the current dir. has moved.
>>
>> And there's only one entry in old parent dir. (e.g. entry with
>> smallest ino) will be tagged with rmdir_ino to prevent its parent dir.
>> is deleted but updated.
>
> Can't parse this phrase. What do you mean by tagging an entry with rmdir_ino?
> rmdir_ino corresponds to the number of a inode that wasn't deleted
> when it was processed because there was some inode with a lower number
> that is a child of the directory in the parent snapshot and had its
> rename/move operation delayed (it happens after the directory we want
> to delete is processed).
>

Right , my "tagged with rmdir_ino" is same meaning as you explained here.

>>
>> However, if we process rename for another entry not tagged with
>> rmdir_ino first, its old parent dir. which is deleted  will be updated
>> according to apply_dir_move().
>>
>> Therefore, I think we should check the existence of  the dir. before
>> we're going to update it's utime.
>>
>> The patch is pasted in the following link, could you give me some comment?
>>
>> https://friendpaste.com/h8tZqOS9iAUpp2DvgGI2k
>
> Looks better.
> However I still don't understand your explanation, and just tried the
> example in your commit message:
>
> "Parent snapshot:
>
> |---- a/ (ino 259)
>   |---- c (ino 264)
> |---- b/ (ino 260)
>   |---- d (ino 265)
> |---- del/ (ino 263)
>   |---- item1/ (ino 261)
>   |---- item2/ (ino 262)
>
> Send snapshot:
> |---- a/ (ino 259)
> |---- b/ (ino 260)
> |---- c/ (ino 2)
>   |---- item2 (ino 259)
> |---- d/ (ino 257)
>   |---- item1/ (ino 258)"
>
> So it's confusing after looking at it.
> First the send snapshot mentions inode number 2, which doesn't exist
> in the parent snapshot - I assume you meant inode number 264.
> Then, the send snapshot has two inodes with number 259. Is "item2" in
> the send snapshot supposed to be inode 262?
>

Your guess is right. And I correct it as follow.

 # Parent snapshot:
 #
 # |---- a/            (ino 259)
 # |     |---- c       (ino 264)
 # |
 # |---- b/            (ino 260)
 # |     |---- d       (ino 265)
 # |
 # |---- del/          (ino 263)
 #        |---- item1/ (ino 261)
 #        |---- item2/ (ino 262)

 # Send snapshot:
 #
 # |---- a/            (ino 259)
 # |---- b/            (ino 260)
 # |---- c/            (ino 264)
 # |     |---- item2/  (ino 262)
 # |
 # |---- d/            (ino 265)
 #       |---- item1/  (ino 261)

> Anyway, assuming those 2 fixes to the example are correct guesses, I
> tried the following and it didn't fail without your patches (i.e. no
> attempts to send utimes to a non-existing directory):
>

Here my mean is :  btrfs tries to get utime from non-existing directory and
apply it on the existing directory. And my patch is attempted to avoid
this case.
However, this case is not guaranteed to cause error anytime but it may
fails somehow
which is depending on the data on the disk.
The following are the incremental procedures to send the snapshot.

utimes
utimes a
utimes b
rename del -> o263-259-0
utimes
rename a/c -> c
utimes
utimes a
rename o263-259-0/item2 -> c/item2
utimes c/item2
utimes o263-259-0          <<---------------------- this step may cause error
utimes c
utimes c
rename b/d -> d
utimes
utimes b
rename o263-259-0/item1 -> d/item1
rmdir o263-259-0
utimes d/item1
utimes d
utimes d

As the above pointed procedure, o263-259-0 is not appeared in the send root.
When utime got from o263-259-0 is invalid (i.e. out of range of time
format), it will fail.
I saw the error occurs at utimensat() and got EINVAL. Here's
explanation from linux man page.

EINVAL Invalid value in one of the tv_nsec fields (value outside
              range 0 to 999,999,999, and not UTIME_NOW or UTIME_OMIT); or
              an invalid value in one of the tv_sec fields.

So if o263-259-0 is not the send root, invalid format of utime may be got.

Thanks.
Robbie Ko

> # Parent snapshot:
> #
> # |---- a/            (ino 259)
> # |     |---- c       (ino 264)
> # |
> # |---- b/            (ino 260)
> # |     |---- d       (ino 265)
> # |
> # |---- del/          (ino 263)
> #        |---- item1/ (ino 261)
> #        |---- item2/ (ino 262)
>
> # Send snapshot:
> #
> # |---- a/            (ino 259)
> # |---- b/            (ino 260)
> # |---- c/            (ino 264)
> # |     |---- item2/  (ino 262)
> # |
> # |---- d/            (ino 265)
> #       |---- item1/  (ino 258)
>
> mkdir $SCRATCH_MNT/0
> mkdir $SCRATCH_MNT/1
>
> mkdir $SCRATCH_MNT/a # 259
> mkdir $SCRATCH_MNT/b # 260
> mkdir $SCRATCH_MNT/item1 # 261
> mkdir $SCRATCH_MNT/item2 # 262
> mkdir $SCRATCH_MNT/del # 263
> mv $SCRATCH_MNT/item1 $SCRATCH_MNT/del/item1
> mv $SCRATCH_MNT/item2 $SCRATCH_MNT/del/item2
> mkdir $SCRATCH_MNT/a/c # 264
> mkdir $SCRATCH_MNT/b/d # 265
>
> _run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap1
>
> mv $SCRATCH_MNT/a/c $SCRATCH_MNT/c
> mv $SCRATCH_MNT/b/d $SCRATCH_MNT/d
> mv $SCRATCH_MNT/del/item2 $SCRATCH_MNT/c
> mv $SCRATCH_MNT/del/item1 $SCRATCH_MNT/d
> rmdir $SCRATCH_MNT/del
>
> _run_btrfs_util_prog subvolume snapshot -r $SCRATCH_MNT $SCRATCH_MNT/mysnap2
>
> run_check $FSSUM_PROG -A -f -w $tmp/1.fssum $SCRATCH_MNT/mysnap1
> run_check $FSSUM_PROG -A -f -w $tmp/2.fssum -x $SCRATCH_MNT/mysnap2/mysnap1 \
> $SCRATCH_MNT/mysnap2
>
> _run_btrfs_util_prog send $SCRATCH_MNT/mysnap1 -f $tmp/1.snap
> _run_btrfs_util_prog send -p $SCRATCH_MNT/mysnap1 $SCRATCH_MNT/mysnap2 \
> -f $tmp/2.snap
>
> _check_scratch_fs
>
> _scratch_unmount
> _scratch_mkfs >/dev/null 2>&1
> _scratch_mount
>
> _run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/1.snap
> run_check $FSSUM_PROG -r $tmp/1.fssum $SCRATCH_MNT/mysnap1
>
> _run_btrfs_util_prog receive $SCRATCH_MNT -f $tmp/2.snap
> run_check $FSSUM_PROG -r $tmp/2.fssum $SCRATCH_MNT/mysnap2
>
>
>
> I would suggest making those hiearachy diagrams more readable - pipes
> right below the name of their parent, continuation pipes like and
> align all inode numbers in the same column, like the following:
>
> # Parent snapshot:
> #
> # |---- a/            (ino 259)
> # |     |---- c       (ino 264)
> # |
> # |---- b/            (ino 260)
> # |     |---- d       (ino 265)
> # |
> # |---- del/          (ino 263)
> #        |---- item1/ (ino 261)
> #        |---- item2/ (ino 262)
>
> # Send snapshot:
> #
> # |---- a/            (ino 259)
> # |---- b/            (ino 260)
> # |---- c/            (ino 264)
> # |     |---- item2/  (ino 262)
> # |
> # |---- d/            (ino 265)
> #       |---- item1/  (ino 258)
>
> (pasted here in case gmail screws up the indentation/formatting:
> https://friendpaste.com/12wzqdcfFrlDdd1AiKX0bU)
>
> thanks
>
>>
>> Thans!
>>
>> Robbie Ko
>>
>> 2015-06-05 0:14 GMT+08:00 Filipe David Manana <fdmanana@gmail.com>:
>>> On Thu, Jun 4, 2015 at 12:18 PM, Robbie Ko <robbieko@synology.com> wrote:
>>>> There's one case where we can't issue a utimes operation for a directory.
>>>> When 263 will delete, waiting 261 and set 261 rmdir_ino, but 262 earlier
>>>> processed and update uime between two parent directory.
>>>> So fix this by not update non exist utimes for this case.
>>>
>>> So you mean that we attempt to update utimes for an inode,
>>> corresponding to a directory, that exists in the parent snapshot but
>>> not in the send snapshot.
>>>
>>> So the subject should be something like "Btrfs: incremental send,
>>> don't send utimes for non-existing directory" instead of "Btrfs:
>>> incremental send, fix rmdir not send utimes"
>>>
>>>>
>>>> Example:
>>>>
>>>> Parent snapshot:
>>>> |---- a/ (ino 259)
>>>>   |---- c (ino 264)
>>>> |---- b/ (ino 260)
>>>>   |---- d (ino 265)
>>>> |---- del/ (ino 263)
>>>>   |---- item1/ (ino 261)
>>>>   |---- item2/ (ino 262)
>>>>
>>>> Send snapshot:
>>>> |---- a/ (ino 259)
>>>> |---- b/ (ino 260)
>>>> |---- c/ (ino 2)
>>>>   |---- item2 (ino 259)
>>>> |---- d/ (ino 257)
>>>>   |---- item1/ (ino 258)
>>>>
>>>> Signed-off-by: Robbie Ko <robbieko@synology.com>
>>>> ---
>>>>  fs/btrfs/send.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
>>>> index e8eb3ab..46f954c 100644
>>>> --- a/fs/btrfs/send.c
>>>> +++ b/fs/btrfs/send.c
>>>> @@ -2468,7 +2468,7 @@ verbose_printk("btrfs: send_utimes %llu\n", ino);
>>>>         key.type = BTRFS_INODE_ITEM_KEY;
>>>>         key.offset = 0;
>>>>         ret = btrfs_search_slot(NULL, sctx->send_root, &key, path, 0, 0);
>>>> -       if (ret < 0)
>>>> +       if (ret != 0)
>>>>                 goto out;
>>>
>>> So I don't think this is a good fix. The problem is in some code that
>>> calls this function (send_utimes) against the directory that doesn't
>>> exist - it just shouldn't do that, its logic should be fixed.
>>> Following this approach, while it works, it's just hiding logic errors
>>> in one or more code paths, and none of its callers checks for a return
>>> value of 1 - they only react to values < 0 and introduces the
>>> possibility of propagating a return value of 1 to user space.
>>>
>>> thanks
>>>
>>>>
>>>>         eb = path->nodes[0];
>>>> --
>>>> 1.9.1
>>>>
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>>
>>>
>>> --
>>> Filipe David Manana,
>>>
>>> "Reasonable men adapt themselves to the world.
>>>  Unreasonable men adapt the world to themselves.
>>>  That's why all progress depends on unreasonable men."
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
