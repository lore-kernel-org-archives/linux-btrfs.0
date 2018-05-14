Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:46255 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752038AbeENUqq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 16:46:46 -0400
Received: by mail-ot0-f193.google.com with SMTP id t1-v6so15892412ott.13
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 13:46:45 -0700 (PDT)
MIME-Version: 1.0
References: <20180514070210.27047-1-wqu@suse.com> <20180514165205.GP6649@twin.jikos.cz>
In-Reply-To: <20180514165205.GP6649@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Mon, 14 May 2018 23:46:09 +0300
Message-ID: <CAGqmi75S-ceHKpG0fsocFnQfgBbbP7W=FrNHgwjcXJMn3SDWsQ@mail.gmail.com>
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW set
To: David Sterba <dsterba@suse.cz>, wqu@suse.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

пн, 14 мая 2018 г. в 20:32, David Sterba <dsterba@suse.cz>:

> On Mon, May 14, 2018 at 03:02:10PM +0800, Qu Wenruo wrote:
> > As btrfs(5) specified:
> >
> >       Note
> >       If nodatacow or nodatasum are enabled, compression is disabled.
> >
> > If NODATASUM or NODATACOW set, we should not compress the extent.
> >
> > And in fact, we have bug report about corrupted compressed extent
> > leading to memory corruption in mail list.

> Link please.

> > Although it's mostly buggy lzo implementation causing the problem, btrfs
> > still needs to be fixed to meet the specification.

> That's very vague, what's the LZO bug? If the input is garbage and lzo
> decompression cannot decompress it, it's not a lzo bug.

> > Reported-by: James Harvey <jamespharvey20@gmail.com>
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> > ---
> >  fs/btrfs/inode.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index d241285a0d2a..dbef3f404559 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -396,6 +396,14 @@ static inline int inode_need_compress(struct inode
*inode, u64 start, u64 end)
> >  {
> >       struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> >
> > +     /*
> > +      * Btrfs doesn't support compression without csum or CoW.
> > +      * This should have the highest priority.
> > +      */
> > +     if (BTRFS_I(inode)->flags & BTRFS_INODE_NODATACOW ||
> > +         BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM)
> > +             return 0;

> This is also the wrong place to fix that, NODATASUM or NODATACOW inode
> should never make it to compress_file_range (that calls
> inode_need_compress).


David, i've talk about that some time ago:
https://www.spinics.net/lists/linux-btrfs/msg73137.html

NoCow files can be *easy* compressed.
```
➜  ~ touch test
➜  ~ chattr +C test
➜  ~ lsattr test
---------------C-- test
➜  ~ dd if=/dev/zero of=./test bs=1M count=1
1+0 records in
1+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 0.00099878 s, 1.0 GB/s
➜  ~ sync
➜  ~ filefrag -v test
Filesystem type is: 9123683e
File size of test is 1048576 (256 blocks of 4096 bytes)
ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..     255:   88592741..  88592996:    256:
last,eof
test: 1 extent found
➜  ~ btrfs fi def -vrczstd test
test
➜  ~ filefrag -v test
Filesystem type is: 9123683e
File size of test is 1048576 (256 blocks of 4096 bytes)
ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..      31:       3125..      3156:     32:             encoded
   1:       32..      63:       3180..      3211:     32:       3157: encoded
   2:       64..      95:       3185..      3216:     32:       3212: encoded
   3:       96..     127:       3188..      3219:     32:       3217: encoded
   4:      128..     159:       3263..      3294:     32:       3220: encoded
   5:      160..     191:       3355..      3386:     32:       3295: encoded
   6:      192..     223:       3376..      3407:     32:       3387: encoded
   7:      224..     255:       3411..      3442:     32:       3408:
last,encoded,eof
test: 8 extents found
```
-- 
Have a nice day,
Timofey.
