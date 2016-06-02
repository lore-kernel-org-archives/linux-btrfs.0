Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:36322 "EHLO
	mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbcFBWpw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jun 2016 18:45:52 -0400
Received: by mail-vk0-f49.google.com with SMTP id a6so91483358vkg.3
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jun 2016 15:45:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE8gLhkR4XzNx9tarhzD2LdsCRJ3e+BPcWYpE-qA4jnJsvSrLg@mail.gmail.com>
References: <CAE8gLhm0-+kkwFv1-+t+tWLrZrzh4B9cJUDRrgPpwfvB_obVCA@mail.gmail.com>
	<CAEtw4r2hsCd1+bFNcXn_s5jj-8x6qer+x0gLx8wTgNi1=nAXhw@mail.gmail.com>
	<CAE8gLh=g7oUK_FAcSN2HaeFmEsK1jBMar4DEfzBwEWiUioDhAQ@mail.gmail.com>
	<CAPmG0jb0eVsg1gX4q3TMA9icRaPS9ULcs2KPBX-_biJ5KPUsrQ@mail.gmail.com>
	<CAE8gLhkR4XzNx9tarhzD2LdsCRJ3e+BPcWYpE-qA4jnJsvSrLg@mail.gmail.com>
Date: Fri, 3 Jun 2016 00:45:51 +0200
Message-ID: <CAPmG0jZj6S6TXe0xLdiJWMto=VX7NM7WhSc5T3MLf=HWvsR7+Q@mail.gmail.com>
Subject: Re: "No space left on device" and balance doesn't work
From: Henk Slager <eye1tm@gmail.com>
To: MegaBrutal <megabrutal@gmail.com>
Cc: Peter Becker <floyd.net@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 2, 2016 at 3:55 PM, MegaBrutal <megabrutal@gmail.com> wrote:
> 2016-06-02 0:22 GMT+02:00 Henk Slager <eye1tm@gmail.com>:
>> What is the kernel version used?
>> Is the fs on a mechanical disk or SSD?
>> What are the mount options?
>> How old is the fs?
>
> Linux 4.4.0-22-generic (Ubuntu 16.04).
> Mechanical disks in LVM.
> Mount: /dev/mapper/centrevg-rootlv on / type btrfs
> (rw,relatime,space_cache,subvolid=257,subvol=/@)
> I don't know how to retrieve the exact FS age, but it was created in
> 2014 August.
>
> Snapshots (their names encode their creation dates):
>
> ID 908 gen 487349 top level 5 path @-snapshot-20160503000001
...<snip>
> ID 937 gen 521829 top level 5 path @-snapshot-20160602000001
>
> Removing old snapshots is the most feasible solution, but I can also
> increase the FS size. It's easy since it's in LVM, and there is plenty
> of space in the volume group.
>
> Probably I should rewrite my alert script to check btrfs fi show
> instead of plain df.

Yes I think that makes sense, to decide on chunk-level. You can see
how big the chunks are with the linked show_usage.py program, most of
33 should be 1GiB as already very well explained by Austin.

The setup looks all pretty normal and btrfs should be able to handle
it, but unfortunately your fs is a typical example that one currently
needs to monitor/tune a btrfs fs for its 'health' in order to keep it
running longterm. You might want to change mount option relatime to
noatime, so that you have less writes to metadata chunks. It should
lower the scattering inside the metadata chunks.
