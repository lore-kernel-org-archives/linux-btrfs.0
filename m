Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:32788 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489AbcC3Rzr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Mar 2016 13:55:47 -0400
Received: by mail-lf0-f51.google.com with SMTP id p188so14695880lfd.0
        for <linux-btrfs@vger.kernel.org>; Wed, 30 Mar 2016 10:55:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160330172509.GC20816@localhost.localdomain>
References: <CAOi1vP9HWN98jo23sG_iOjVy1OSXNjeoJWukOhLCmA42rzZHrA@mail.gmail.com>
	<20160330172509.GC20816@localhost.localdomain>
Date: Wed, 30 Mar 2016 19:55:45 +0200
Message-ID: <CAOi1vP_EBAvDgGePAhsKW4wAHoOttGYkhnqTJdGsbVH6yEH1JQ@mail.gmail.com>
Subject: Re: Infinite loop in in btrfs_find_space_cluster() with
 btrfs_free_cluster::lock held
From: Ilya Dryomov <idryomov@gmail.com>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 30, 2016 at 7:25 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Wed, Mar 30, 2016 at 05:24:04PM +0200, Ilya Dryomov wrote:
>> Hi,
>>
>> We are hitting the attached lockup on a somewhat regular basis during
>> nightly tests.  Looks like a bunch of CPUs spin in find_free_extent()
>> on btrfs_free_cluster::lock, which is held by writer, who seems to be
>> stuck in an endless loop in btrfs_find_space_cluster(), trying to
>> cleanup bitmaps list.  Smells like a list corruption to me?
>
> My objdump shows that find_free_extent() may wait on down_read(&space_info->groups_sem);

It's spinning on a spinlock:

6228         if (last_ptr) {
6229                 spin_lock(&last_ptr->lock);
6230                 if (last_ptr->block_group)

>
> One possible thing is that there're too many entries in bitmap, and
> list_for_each_entry just is just stuck there.

I don't think so - look at the two journal_write splats.

>
> Are these stacks from "Blocked more than 120s"?

No, these are all soft lockups.  Sorry, I had to edit it to make it
readable and concentrated on stack traces.  I guess "BUG: soft lockup"
were mixed up with modules and object code all over the place.

Thanks,

                Ilya
