Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33376 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbcDQUwY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 16:52:24 -0400
Received: by mail-io0-f177.google.com with SMTP id o126so179067530iod.0
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Apr 2016 13:52:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160416000758.GD7369@localhost.localdomain>
References: <CAJCQCtSKDunrKyU8+wmh8qLp9zEgP06Ej58Xj4_24PUk8v5Yqg@mail.gmail.com>
	<20160416000758.GD7369@localhost.localdomain>
Date: Sun, 17 Apr 2016 14:52:23 -0600
Message-ID: <CAJCQCtQCj0cOq2gpGvTQvEfKfGunscC6jPKoxtKNMf-yYosGfA@mail.gmail.com>
Subject: Re: BUG at fs/btrfs/inode.c:1828! RIP: btrfs_merge_bio_hook+0x8b/0xa0 [btrfs]
From: Chris Murphy <lists@colorremedies.com>
To: bo.li.liu@oracle.com
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 15, 2016 at 6:07 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Fri, Apr 15, 2016 at 09:28:49AM -0600, Chris Murphy wrote:
>> Note this is a testing VM, no user data is at risk
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=116331
>
> From the call stack we can tell that btrfs_root_bytenr() returns 0
> somehow.  And this comes from btrfs_recover_relocation() reading
> the root on which reloc_root is snapshoted, and it's not the FS tree,
> might be a snapshot root or subvolume root.
>
> Looks like our COW fails for that root.

QEMU disk cache is set to unsafe, which might be a contributing
factor. I've updated the bug to reflect some data loss is expected,
but seems like the file system should still rollback to a known good
state? And if not should be repairable. But maybe that's not a valid
expectation for unsafe caching.

-- 
Chris Murphy
