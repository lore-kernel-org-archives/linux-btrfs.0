Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:34147 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbbG2QYS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jul 2015 12:24:18 -0400
Received: by igk11 with SMTP id 11so140036308igk.1
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jul 2015 09:24:17 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <55A86AA8.6010404@cn.fujitsu.com>
References: <55A86AA8.6010404@cn.fujitsu.com>
Date: Wed, 29 Jul 2015 17:24:17 +0100
Message-ID: <CAL3q7H4agirHifhevvf1R+KSCFrxEE5gWHVKysm1KpAJOh=nkw@mail.gmail.com>
Subject: Re: Strange data backref offset?
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 17, 2015 at 3:38 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Hi all,
>
> While I'm developing a new btrfs inband dedup mechanism, I found btrfsck and
> kernel doing strange behavior for clone.
>
> [Reproducer]
> # mount /dev/sdc -t btrfs /mnt/test
> # dd if=/dev/zero of=/mnt/test/file1 bs=4K count=4
> # sync
> # ~/xfstests/src/cloner -s 4096 -l 4096 /mnt/test/file1 /mnt/test/file2
> # sync
>
> Then btrfs-debug-tree gives quite strange result on the data backref:
> ------
> <EXTENT TREE>
>         item 4 key (12845056 EXTENT_ITEM 16384) itemoff 16047 itemsize 111
>                 extent refs 3 gen 6 flags DATA
>                 extent data backref root 5 objectid 257 offset 0 count 1
>                 extent data backref root 5 objectid 258 offset
> 18446744073709547520 count 1
>
> <FS TREE>
>         item 8 key (257 EXTENT_DATA 0) itemoff 15743 itemsize 53
>                 extent data disk byte 12845056 nr 16384
>                 extent data offset 0 nr 16384 ram 16384
>                 extent compression 0
>         item 9 key (257 EXTENT_DATA 16384) itemoff 15690 itemsize 53
>                 extent data disk byte 12845056 nr 16384
>                 extent data offset 4096 nr 4096 ram 16384
>                 extent compression 0
> ------
>
> The offset is file extent's key.offset - file exntent's offset,
> Which is 0 - 4096, causing the overflow result.
>
> Kernel and fsck all uses that behavior, so fsck can pass the strange thing.
>
> But shouldn't the offset in data backref matches with the key.offset of the
> file extent?
>
> And I'm quite sure the change of behavior can hugely break the fsck and
> kernel, but I'm wondering is this a known BUG or feature, and will it be
> handled?

Obviously a bug.

I was recently investigating incremental send failures after
cloning/deduping extents and that lead me to this as well.
It's a bug but it's not too bad as it effects only backref walking,
which can have a simple workaround (I just sent a patch for it). For
the purposes of incrementing/decrementing the data backref's count we
do the same calculation everywhere, always leading to the same large
and unexpected value, so we don't get bogus backrefs added/left
around.

>
> Thanks,
> Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
