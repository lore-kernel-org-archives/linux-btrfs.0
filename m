Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:39297 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbeEKQKk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 11 May 2018 12:10:40 -0400
Received: by mail-oi0-f67.google.com with SMTP id n65-v6so5159107oig.6
        for <linux-btrfs@vger.kernel.org>; Fri, 11 May 2018 09:10:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180511100657.GR6649@twin.jikos.cz>
References: <cover.1526025007.git.osandov@fb.com> <844bfe29a31c7943053202c36a7990efd2437c69.1526025007.git.osandov@fb.com>
 <20180511100657.GR6649@twin.jikos.cz>
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 11 May 2018 12:10:38 -0400
Message-ID: <CAEzrpqeHVkVAEW+g0mrgt=WKzRQH26L4ZuazU8Htv4=X2aFHiQ@mail.gmail.com>
Subject: Re: [PATCH v3 05/11] Btrfs: get rid of BTRFS_INODE_HAS_ORPHAN_ITEM
To: David Sterba <dsterba@suse.cz>, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        Nikolay Borisov <nborisov@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I told him to do this, these flags aren't exposed anywhere are they?
They are in-kernel specific stuff, please tell me we aren't exposing
these via sysfs?

Josef

On Fri, May 11, 2018 at 6:06 AM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, May 11, 2018 at 12:56:10AM -0700, Omar Sandoval wrote:
>> --- a/fs/btrfs/btrfs_inode.h
>> +++ b/fs/btrfs/btrfs_inode.h
>> @@ -23,13 +23,12 @@
>>  #define BTRFS_INODE_ORPHAN_META_RESERVED     1
>>  #define BTRFS_INODE_DUMMY                    2
>>  #define BTRFS_INODE_IN_DEFRAG                        3
>> -#define BTRFS_INODE_HAS_ORPHAN_ITEM          4
>> -#define BTRFS_INODE_HAS_ASYNC_EXTENT         5
>> -#define BTRFS_INODE_NEEDS_FULL_SYNC          6
>> -#define BTRFS_INODE_COPY_EVERYTHING          7
>> -#define BTRFS_INODE_IN_DELALLOC_LIST         8
>> -#define BTRFS_INODE_READDIO_NEED_LOCK                9
>> -#define BTRFS_INODE_HAS_PROPS                        10
>> +#define BTRFS_INODE_HAS_ASYNC_EXTENT         4
>> +#define BTRFS_INODE_NEEDS_FULL_SYNC          5
>> +#define BTRFS_INODE_COPY_EVERYTHING          6
>> +#define BTRFS_INODE_IN_DELALLOC_LIST         7
>> +#define BTRFS_INODE_READDIO_NEED_LOCK                8
>> +#define BTRFS_INODE_HAS_PROPS                        9
>
> Please keep such changes minimal and only relevant to the purpose of the
> patch, in this case just remove the BTRFS_INODE_HAS_ORPHAN_ITEM .
>
> There will be a hole left in the sequence but this is not a problem and
> we're going to convert the defines to enums. The defines are prone to
> error if the nubmers get accidentally duplicated, like it happend not so
> long ago with the fsinfo::fs_flags.
