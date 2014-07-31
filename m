Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:44884 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaGaMl7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 08:41:59 -0400
Received: by mail-la0-f51.google.com with SMTP id pn19so1971994lab.38
        for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 05:41:57 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAL3q7H5JhRB_k+X++qzaHE5kYORaFxCn-JHfNmnA1MFJuRde1A@mail.gmail.com>
References: <1401795704-20668-1-git-send-email-fdmanana@gmail.com>
	<CAOcd+r1VqCogBa+S4C3ZejsNsAiWgOkVAJjSWttJbJcqKfBwpQ@mail.gmail.com>
	<CAL3q7H5JhRB_k+X++qzaHE5kYORaFxCn-JHfNmnA1MFJuRde1A@mail.gmail.com>
Date: Thu, 31 Jul 2014 13:41:57 +0100
Message-ID: <CAL3q7H76NAMQzVJkCTW+ZOD0ukvfk--CGiWj3925p5eE9pOfYg@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: update commit root on snapshot creation after
 orphan cleanup
From: Filipe David Manana <fdmanana@gmail.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 28, 2014 at 6:31 PM, Filipe David Manana <fdmanana@gmail.com> wrote:
> On Sat, Jul 19, 2014 at 8:11 PM, Alex Lyakas
> <alex.btrfs@zadarastorage.com> wrote:
>> Hi Filipe,
>> It's quite possible I don't fully understand the issue. It seems that
>> we are creating a read-only snapshot, commit a transaction, and then
>> go and modify the snapshot once again, by deleting all the
>> ORPHAN_ITEMs we have in its file tree (btrfs_orphan_cleanup).
>> Shouldn't all this be part of snapshot creation, so that after we
>> commit, we have a clean file tree with no orphans there? (not sure if
>> this makes sense though).
>>
>> With your patch we do this additional commit after the cleanup. But
>> nothing prevents "send" from starting before this additional commit,
>> correct? And it would still see the orphans through the commit root.
>> You say that it is not a problem, but I am not sure why (probably I am
>> missing something here). So for me it looks like your patch closes a
>> race window significantly (at the cost of an additional commit), but
>> does not close it fully.
>
> Hi Alex,
>
> That's right, after the transaction commit finishes, the snapshot will
> be visible and accessible to user space - so someone may start a send
> before the orphan cleanup starts. It was ok only for the serialized
> case (create snapshot, wait for ioctl to return, call send ioctl).

Actually no. If after the 1st transaction commit (the one that creates
the snapshot and makes it visible to user space) and before the orphan
cleanup is called another task attempts to use the snapshot for a send
operation, it will block when doing the snapshot dentry lookup -
because both tasks acquire the parent inode's mutex (implicitly
through the vfs and explicitly via the snapshot/subvol ioctl entry
point).

Nevertheless, it's better to move the commit root switch part to the
dentry lookup function (as the new patch does), since after the first
transaction commit and before the second one commits, a reboot might
happen, and after that we would get into the same issue until the
first transaction commit happens after the reboot. I'll update the new
patch's comment.

thanks

>
>>
>> But most important: perhaps "send" should look for ORPHAN_ITEMs and
>> treat those inodes as "deleted"?
>
> There are other cases were orphans can exist, like for file truncates
> for example, where ignoring the inode wouldn't be very correct.
> Tried that approach initially, but it's actually more complex to
> implement and adds some additional overhead (tree searches - and the
> orphan items are normally too far from the inode items, due to a very
> high objectid (-5ULL)).
>
> I've reworked this with a different approach and CC'ed you
> (https://patchwork.kernel.org/patch/4635471/).
>
> thanks
>
>>
>> Thanks,
>> Alex.
>>
>>
>>
>> On Tue, Jun 3, 2014 at 2:41 PM, Filipe David Borba Manana
>> <fdmanana@gmail.com> wrote:
>>> On snapshot creation (either writable or read-only), we do orphan cleanup
>>> against the root of the snapshot. If the cleanup did remove any orphans,
>>> then the current root node will be different from the commit root node
>>> until the next transaction commit happens.
>>>
>>> A send operation always uses the commit root of a snapshot - this means
>>> it will see the orphans if it starts computing the send stream before the
>>> next transaction commit happens (triggered by a timer or sync() for .e.g),
>>> which is when the commit root gets assigned a reference to current root,
>>> where the orphans are not visible anymore. The consequence of send seeing
>>> the orphans is explained below.
>>>
>>> For example:
>>>
>>>     mkfs.btrfs -f /dev/sdd
>>>     mount -o commit=999 /dev/sdd /mnt
>>>
>>>     # open a file with O_TMPFILE and leave it open
>>>     # write some data to the file
>>>     btrfs subvolume snapshot -r /mnt /mnt/snap1
>>>
>>>     btrfs send /mnt/snap1 -f /tmp/send.data
>>>
>>> The send operation will fail with the following error:
>>>
>>>     ERROR: send ioctl failed with -116: Stale file handle
>>>
>>> What happens here is that our snapshot has an orphan inode still visible
>>> through the commit root, that corresponds to the tmpfile. However send
>>> will attempt to call inode.c:btrfs_iget(), with the goal of reading the
>>> file's data, which will return -ESTALE because it will use the current
>>> root (and not the commit root) of the snapshot.
>>>
>>> Of course, there are other cases where we can get orphans, but this
>>> example using a tmpfile makes it much easier to reproduce the issue.
>>>
>>> Therefore on snapshot creation, after calling btrfs_orphan_cleanup, if
>>> the commit root is different from the current root, just commit the
>>> transaction associated with the snapshot's root (if it exists), so that
>>> a send will not see any orphans that don't exist anymore. This also
>>> guarantees a send will always see the same content regardless of whether
>>> a transaction commit happened already before the send was requested and
>>> after the orphan cleanup (meaning the commit root and current roots are
>>> the same) or it hasn't happened yet (commit and current roots are
>>> different).
>>>
>>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>>> ---
>>>  fs/btrfs/ioctl.c | 29 +++++++++++++++++++++++++++++
>>>  1 file changed, 29 insertions(+)
>>>
>>> diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
>>> index 95194a9..6680ad9 100644
>>> --- a/fs/btrfs/ioctl.c
>>> +++ b/fs/btrfs/ioctl.c
>>> @@ -712,6 +712,35 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>>>         if (ret)
>>>                 goto fail;
>>>
>>> +       /*
>>> +        * If orphan cleanup did remove any orphans, it means the tree was
>>> +        * modified and therefore the commit root is not the same as the
>>> +        * current root anymore. This is a problem, because send uses the
>>> +        * commit root and therefore can see inode items that don't exist
>>> +        * in the current root anymore, and for example make calls to
>>> +        * btrfs_iget, which will do tree lookups based on the current root
>>> +        * and not on the commit root. Those lookups will fail, returning a
>>> +        * -ESTALE error, and making send fail with that error. So make sure
>>> +        * a send does not see any orphans we have just removed, and that it
>>> +        * will see the same inodes regardless of whether a transaction
>>> +        * commit happened before it started (meaning that the commit root
>>> +        * will be the same as the current root) or not.
>>> +        */
>>> +       if (readonly && pending_snapshot->snap->node !=
>>> +           pending_snapshot->snap->commit_root) {
>>> +               trans = btrfs_join_transaction(pending_snapshot->snap);
>>> +               if (IS_ERR(trans) && PTR_ERR(trans) != -ENOENT) {
>>> +                       ret = PTR_ERR(trans);
>>> +                       goto fail;
>>> +               }
>>> +               if (!IS_ERR(trans)) {
>>> +                       ret = btrfs_commit_transaction(trans,
>>> +                                                      pending_snapshot->snap);
>>> +                       if (ret)
>>> +                               goto fail;
>>> +               }
>>> +       }
>>> +
>>>         inode = btrfs_lookup_dentry(dentry->d_parent->d_inode, dentry);
>>>         if (IS_ERR(inode)) {
>>>                 ret = PTR_ERR(inode);
>>> --
>>> 1.9.1
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
