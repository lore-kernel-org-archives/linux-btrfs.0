Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:36994 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751607AbdG0UHr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Jul 2017 16:07:47 -0400
Received: by mail-it0-f42.google.com with SMTP id v127so88691336itd.0
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Jul 2017 13:07:47 -0700 (PDT)
MIME-Version: 1.0
From: Alan Brand <alan@georgiabrands.com>
Date: Thu, 27 Jul 2017 16:07:46 -0400
Message-ID: <CAFcRpx4O=rxSmd0=TgBF2r_Jzc4dE6WSy90n8HXsQkE=deVsHg@mail.gmail.com>
Subject: Re: Raid0 rescue
To: hugo@carfax.org.uk, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > Correct, I should have said 'superblock'.
> > It is/was raid0.  Funny thing is that this all happened when I was
> > prepping to convert to raid1.
>    If youre metadata was also RAID-0, then your filesystem is almost
> certainly toast. If any part of the btrfs metadata was overwritten by
> some of the NTFS metadata, then the FS will be broken (somewhere) and
> probably not in a fixable way.


It should have been raid-1 as I believe that is the default for
metadata when creating a btrfs volume
How do i put the good copy back on the corrupt volume?
I cant even look at the metadata on the good disk as it complains
about one of the disk being missing.

> running a btrfs-find-root shows this (which gives me hope)
> Well block 4871870791680(gen: 73257 level: 1) seems good, but
> generation/level doesn't match, want gen: 73258 level: 1
> Well block 4639933562880(gen: 73256 level: 1) seems good, but
> generation/level doesn't match, want gen: 73258 level: 1
> Well block 4639935168512(gen: 73255 level: 1) seems good, but
> generation/level doesn't match, want gen: 73258 level: 1
> Well block 4639926239232(gen: 73242 level: 0) seems good, but
> generation/level doesn't match, want gen: 73258 level: 1
>
> but when I run btrfs
> inspect-internal dump-tree -r /dev/sdc1
>
> checksum verify failed on 874856448 found 5A85B5D9 wanted 17E3CB7D
> checksum verify failed on 874856448 found 5A85B5D9 wanted 17E3CB7D
> checksum verify failed on 874856448 found 2204C752 wanted C6ADDF7E
> checksum verify failed on 874856448 found 2204C752 wanted C6ADDF7E
> bytenr mismatch, want=874856448, have=8568478783891655077

   This would suggest that some fairly important part of the metadata
was damaged. You'll probably spend far less effort recovering the data
by restoring your backups than trying to fix this.

   Hugo.

> root tree: 4871875543040 level 1
> chunk tree: 20971520 level 1
> extent tree key (EXTENT_TREE ROOT_ITEM 0) 4871875559424 level 2
> device tree key (DEV_TREE ROOT_ITEM 0) 4635801976832 level 1
> fs tree key (FS_TREE ROOT_ITEM 0) 4871870414848 level 3
> checksum tree key (CSUM_TREE ROOT_ITEM 0) 4871876034560 level 3
> uuid tree key (UUID_TREE ROOT_ITEM 0) 29376512 level 0
> checksum verify failed on 728891392 found 75E2752C wanted D6CA4FB4
> checksum verify failed on 728891392 found 75E2752C wanted D6CA4FB4
> checksum verify failed on 728891392 found F4F3A4AD wanted E6D063C7
> checksum verify failed on 728891392 found 75E2752C wanted D6CA4FB4
> bytenr mismatch, want=728891392, have=269659807399918462
> total bytes 5000989728768
> bytes used 3400345264128
>
>
>
> On Thu, Jul 27, 2017 at 11:10 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Thu, Jul 27, 2017 at 10:49:37AM -0400, Alan Brand wrote:
> >> I know I am screwed but hope someone here can point at a possible solution.
> >>
> >> I had a pair of btrfs drives in a raid0 configuration.  One of the
> >> drives was pulled by mistake, put in a windows box, and a quick NTFS
> >> format was done.  Then much screaming occurred.
> >>
> >> I know the data is still there.
> >
> >    Well, except for all the parts overwritten by a blank NTFS metadata
> > structure.
> >
> >>   Is there anyway to rebuild the raid
> >> bringing in the bad disk?  I know some info is still good, for example
> >> metadata0 is corrupt but 1 and 2 are good.
> >
> >    I assume you mean superblock there.
> >
> >> The trees look bad which is probably the killer.
> >
> >    We really should improve the error messages at some point. Whatever
> > you're inferring from the kernel logs is probably not quite right. :)
> >
> >    What's the metadata configuration on this FS? Also RAID-0? or RAID-1?
> >
> >> I can't run a normal recovery as only half of each file is there.
> >
> >    Welcome to RAID-0...
> >
> >    Hugo.
> >
