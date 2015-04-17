Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:35530 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbbDQMcg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Apr 2015 08:32:36 -0400
Received: by igbyr2 with SMTP id yr2so10112472igb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 17 Apr 2015 05:32:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CADfjVrg=hZNE1x4F3H05Ds_H9WDBjuY2ZPPixuxiUanAd2mOHw@mail.gmail.com>
References: <553046DA.7090809@gmail.com>
	<CADfjVrg=hZNE1x4F3H05Ds_H9WDBjuY2ZPPixuxiUanAd2mOHw@mail.gmail.com>
Date: Fri, 17 Apr 2015 08:32:35 -0400
Message-ID: <CAPL5yKf7Qb3ogyNf8UoXGLonj-nKPCqQf9UdktbUXthWqBHn_g@mail.gmail.com>
Subject: Re: [PATCH] btrfs-progs: have restore set atime/mtime
From: Dan Merillat <dan.merillat@gmail.com>
To: Noah Massey <noah.massey@gmail.com>, BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 17, 2015 at 7:54 AM, Noah Massey <noah.massey@gmail.com> wrote:
> On Thu, Apr 16, 2015 at 7:33 PM, Dan Merillat <dan.merillat@gmail.com> wrote:
>> The inode is already found, use the data and make restore friendlier.
>>
>> Signed-off-by: Dan Merillat <dan.merillat@gmail.com>
>> ---
>>  cmds-restore.c | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/cmds-restore.c b/cmds-restore.c
>> index d2fc951..95ac487 100644
>> --- a/cmds-restore.c
>> +++ b/cmds-restore.c
>> @@ -567,12 +567,22 @@ static int copy_file(struct btrfs_root *root, int
>> fd, struct btrfs_key *key,
>>                 fprintf(stderr, "Ran out of memory\n");
>>                 return -ENOMEM;
>>         }
>> +       struct timespec times[2];
>> +       int times_ok=0;
>>
>>         ret = btrfs_lookup_inode(NULL, root, path, key, 0);
>>         if (ret == 0) {
>>                 inode_item = btrfs_item_ptr(path->nodes[0], path->slots[0],
>>                                     struct btrfs_inode_item);
>>                 found_size = btrfs_inode_size(path->nodes[0], inode_item);
>> +               struct btrfs_timespec bts;
>> +               read_eb_member(path->nodes[0], inode_item, struct btrfs_inode_item, atime, &bts);
>> +               times[0].tv_sec=bts.sec;
>> +               times[0].tv_nsec=bts.nsec;
>> +               read_eb_member(path->nodes[0], inode_item, struct btrfs_inode_item, atime, &bts);
>
> I think you mean 'mtime' here

I absolutely do, whoops.  This is probably a good time to mention how
much I dislike the fake pointers being used everywhere, coupled with
the partially-implemented macro magic to get fields out of them.  Is
there a good reason why btrfs_item_ptr isn't just a type-pun, with the
understanding that you'll need to copy it to keep it?

>> +       if (times_ok)
>> +               futimens(fd, times);
>
> return value isn't checked here.

What could we do with the error if it occurred?  Restoring times is a
nice bonus if it works, but if it gets lost while the data was
restored successfully, that shouldn't be an error condition.  I can
add a comment to that effect to make it clearer why it's being ignored
though, or perhaps something like a warn_once if the filesystem being
restored to doesn't support changing the times.

On the subject of errors - is it possible for read_eb_member to fail
the way I'm using it?  It's defined, but never used anywhere else, so
I have nothing to compare it to.  My feeling is that if btrfs_item_ptr
works the data in the structure returned is going to be there, but I'm
not sure.
