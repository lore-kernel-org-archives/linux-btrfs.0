Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:36189 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751568AbeDJBXP (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Apr 2018 21:23:15 -0400
Received: by mail-it0-f67.google.com with SMTP id 15-v6so12758199itl.1
        for <linux-btrfs@vger.kernel.org>; Mon, 09 Apr 2018 18:23:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANQeFDBu+oG2W7rxjM3G+KBkN=hVwVG_GdPm6-jpfJPpCnabCw@mail.gmail.com>
References: <1522447918-19147-1-git-send-email-bo.liu@linux.alibaba.com>
 <20180405164831.GI2635@twin.jikos.cz> <CANQeFDBSAX=+-S7umzWAXgVzUe7vXYM=qL6FJSUTw9jmPj=nnw@mail.gmail.com>
 <20180406132129.GD8557@twin.jikos.cz> <CANQeFDBu+oG2W7rxjM3G+KBkN=hVwVG_GdPm6-jpfJPpCnabCw@mail.gmail.com>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Mon, 9 Apr 2018 18:23:14 -0700
Message-ID: <CANQeFDCV5p+t0kLDHjrTmeT6_S9U-zLHP5c0btR_UbtON-TpaA@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: do not abort transaction when failing to insert
 hole extent
To: David Sterba <dsterba@suse.cz>, Liu Bo <obuil.liubo@gmail.com>,
        Liu Bo <bo.liu@linux.alibaba.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 6, 2018 at 10:43 AM, Liu Bo <obuil.liubo@gmail.com> wrote:
> On Fri, Apr 6, 2018 at 6:21 AM, David Sterba <dsterba@suse.cz> wrote:
>> On Thu, Apr 05, 2018 at 11:58:16AM -0700, Liu Bo wrote:
>>> On Thu, Apr 5, 2018 at 9:48 AM, David Sterba <dsterba@suse.cz> wrote:
>>> > On Sat, Mar 31, 2018 at 06:11:55AM +0800, Liu Bo wrote:
>>> >> This is running in a typical write path, not inside a critical path
>>> >> where we have to abort the running transaction, so it's OK to return
>>> >> errors to callers and eventually to userspace.
>>> >
>>> > I'm not sure this is entierly correct, several other places do not abort
>>> > after btrfs_drop_extents as there's nothing that would leave the
>>> > structres in some half-state.
>>> >
>>> >> Signed-off-by: Liu Bo <bo.liu@linux.alibaba.com>
>>> >> ---
>>> >>  fs/btrfs/inode.c | 5 +----
>>> >>  1 file changed, 1 insertion(+), 4 deletions(-)
>>> >>
>>> >> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
>>> >> index c7b75dd..b9310f8 100644
>>> >> --- a/fs/btrfs/inode.c
>>> >> +++ b/fs/btrfs/inode.c
>>> >> @@ -4939,16 +4939,13 @@ static int maybe_insert_hole(struct btrfs_root *root, struct inode *inode,
>>> >>
>>> >>       ret = btrfs_drop_extents(trans, root, inode, offset, offset + len, 1);
>>> >>       if (ret) {
>>> >> -             btrfs_abort_transaction(trans, ret);
>>> >>               btrfs_end_transaction(trans);
>>> >>               return ret;
>>> >>       }
>>> >>
>>> >>       ret = btrfs_insert_file_extent(trans, root, btrfs_ino(BTRFS_I(inode)),
>>> >>                       offset, 0, 0, len, 0, len, 0, 0, 0);
>>> >
>>> > But here the extents have been already dropped and missing to insert the
>>> > items does not seem to lead to a consistent state.
>>> >
>>> > It's possible that I'm missing something. In a call path that can be
>>> > safely rolled back even with a started transaction, we don't need to
>>> > abort in all cases. But if the rollback requires some non-trivial
>>> > modifications, I don't see options how to avoid the abort.
>>> >
>>> > __btrfs_drop_extents does a lot of state changes and can itself fail
>>> > in the middle of dropping the range, aborting looks like the safest
>>> > option.
>>> >
>>>
>>> As maybe_insert_hole is only called by btrfs_cont_expand here, which
>>> means it's a really hole, I don't expect drop_extents would drop
>>> anything, we can remove this drop_extents and put an assert after
>>> btrfs_insert_file_extent for checking EEXIST.
>>
>> Sounds good.
>>
>
> Let me make a v2 and have a fstests run.
>

It turns out that the btrfs_drop_extents() here is quite necessary
since fallocate(2) has a FALLOC_FL_KEEP_SIZE option, and when that
happens, a hole extent would be appended between the EOF and fallocate
range's start, then a later truncate up would have to drop these hole
extents in order to expand with a new hole...

As I don't see a way to gracefully solve this except keeping
drop_extents(), lets drop this patch instead.

thanks,
liubo

> thanks,
> liubo
>
>>> It's different from punch hole where we need to explicitly drop an
>>> actual extent and replace it with a hole range.
>>
>> Right, that's what I didn't see at first.
