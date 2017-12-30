Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:37519 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750937AbdL3Tyy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Dec 2017 14:54:54 -0500
Received: by mail-io0-f179.google.com with SMTP id n14so20756928iob.4
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Dec 2017 11:54:54 -0800 (PST)
MIME-Version: 1.0
Reply-To: swestrup@gmail.com
In-Reply-To: <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com>
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com> <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com> <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
 <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com> <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>
 <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com>
From: Stirling Westrup <swestrup@gmail.com>
Date: Sat, 30 Dec 2017 14:54:53 -0500
Message-ID: <CAJt7KB8OcRWE0=MUcA+tXgSYUr_=2RXsWTZcdEjhuN1agqh_nw@mail.gmail.com>
Subject: Re: Hand Patching a BTRFS Superblock?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Okay, so I've gone back to your earlier suggestion of dumping the
chunk tree to get info for rebuiling a superblock by hand, but its not
working.

/usr/local/bin/btrfs ins dump-tree -t chunk /dev/sdc
btrfs-progs v4.14
bytenr mismatch, want=294191104, have=314114048
Couldn't read tree root
ERROR: unable to open /dev/sdc

I get the exact same error (except for device name) for every valid
device in the FS.



On Thu, Dec 28, 2017 at 9:08 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>
>
> Yes, this means you could get the needed device UUID and hand craft a
> superblock.
> But I really doubt about the possibility to success.
>
> If you really want to do that, there is needed steps for you:
>
> 1) Get device info from your existing fs
>    # btrfs ins dump-tree -t chunk </dev/sda>
>    And looking for the following thing:
> ------
>        item 1 key (DEV_ITEMS DEV_ITEM 2) itemoff 16185 itemsize 98
>                 devid 2 total_bytes 10737418240 bytes_used 289406976
>                 io_align 4096 io_width 4096 sector_size 4096 type 0
>                 generation 0 start_offset 0 dev_group 0
>                 seek_speed 0 bandwidth 0
>                 uuid f1d9b288-7865-463f-a65c-ca8b1fbde09b
>                 fsid 1dd513fb-45f8-404f-ae23-979e3acb78ad
> ------
>    Look for the key (DEV_ITEMS DEV_ITEM 2) and grab the "uuid"
>    "total_bytes" "bytes_used" (other fields are mostly fixed)
>
> 2) Fill the fields of dev_item of a good superblock.
>    If you feel it hard, I could help to do it if you provide the binary
>    dump of any valid superblock, with above tree dump info.
>
