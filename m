Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:36833 "EHLO
        mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753952AbcLLAMh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Dec 2016 19:12:37 -0500
Received: by mail-io0-f171.google.com with SMTP id a81so138403237ioe.3
        for <linux-btrfs@vger.kernel.org>; Sun, 11 Dec 2016 16:12:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQLRRaAyCa8DBHmcizcLHTajmp_vzGU7MkEvshtO4bbNQ@mail.gmail.com>
References: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
 <CAJCQCtTC5T0v6jZpALTPwn=CvWn-kJXZX2vVFAEjjk9xokqoPQ@mail.gmail.com>
 <CADph71wae2AQT-v-hu0YcJdNE+dWxRZ7yQVmMEMLyhzsC-FHqQ@mail.gmail.com>
 <CAJCQCtT5CG4M4nYmmefEfWjapmg3TpMXJSVmTE89r6iPxV6xHw@mail.gmail.com>
 <CADph71zoOB72o2PoUY_qqMsg_TpvBokugR9UzZHo6kPsNm4PNg@mail.gmail.com> <CAJCQCtQLRRaAyCa8DBHmcizcLHTajmp_vzGU7MkEvshtO4bbNQ@mail.gmail.com>
From: Markus Binsteiner <makkus@gmail.com>
Date: Mon, 12 Dec 2016 13:12:35 +1300
Message-ID: <CADph71yACvRhb6AWixoaR28+VHZeaGmZqawqY3MSBcSeJM=6Qw@mail.gmail.com>
Subject: Re: btrfs-find-root duration?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> You might try 'btrfs check' without repairing, using a recent version
> of btrfs-progs and see if it finds anything unusual.

Not quite sure what that output means, but btrfs check returns instantly:

$ sudo btrfs check /dev/mapper/think--big-home
Checking filesystem on /dev/mapper/think--big-home
UUID: 7f1ce0ed-5986-43ae-b0dd-727eee19fd08
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 655360 bytes used err is 0
total csum bytes: 0
total tree bytes: 131072
total fs tree bytes: 32768
total extent tree bytes: 16384
btree space waste bytes: 123528
file data blocks allocated: 524288
 referenced 524288

When I do the same thing on the root-OS partition that is on the same
disk, it takes a bit longer to complete, and I'm getting:

$ sudo btrfs check /dev/mapper/think--big-jessie
Checking filesystem on /dev/mapper/think--big-jessie
UUID: d82e2746-4164-41fa-b528-5a5838d818c6
checking extents
checking free space cache
checking fs roots
checking csums
checking root refs
found 29295181824 bytes used err is 0
total csum bytes: 27623652
total tree bytes: 973848576
total fs tree bytes: 874446848
total extent tree bytes: 62554112
btree space waste bytes: 154131992
file data blocks allocated: 29202391040
 referenced 30898016256

So I reckon the tree(s) in my home partition is just empty? Why would
btrfs-find-tree take so long to complete though? Also, I've tried to
run btrfs-find-tree on the root-OS partition, but that also didn't
complete within the 10 minutes I tried (so far).

> Although, are there many snapshots? That would cause the rentention of roots.

I can't remember exactly, but it's very possible I didn't use any
snapshots on this machine at all.
