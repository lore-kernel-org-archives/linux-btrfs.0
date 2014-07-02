Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:38047 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbaGBRSD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Jul 2014 13:18:03 -0400
Received: by mail-qg0-f44.google.com with SMTP id j107so5071844qga.31
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Jul 2014 10:18:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140702163107.GL1738@carfax.org.uk>
References: <CAMXuLLrQoEB0sfY5P4ZCYn3a8Urk-RC3N_a2AoQrnKG-OeYNuQ@mail.gmail.com>
	<20140702163107.GL1738@carfax.org.uk>
Date: Wed, 2 Jul 2014 13:18:01 -0400
Message-ID: <CAMXuLLrQFm2QR0iK==2C0GXuMjU4_mtL+8dB-MrA6jhuS-sT7Q@mail.gmail.com>
Subject: Re: Question about debugfs on btrfs
From: Zhe Zhang <zhe.zhang.research@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Zhe Zhang <zhe.zhang.research@gmail.com>,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Hugo, that works great.

On Wed, Jul 2, 2014 at 12:31 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Wed, Jul 02, 2014 at 12:23:01PM -0400, Zhe Zhang wrote:
>> Hi,
>>
>> I'm trying to use a functionality like "debugfs blocks" or
>> "dump_extents" on a btrfs partition. The current debugfs user space
>> program doesn't seem to support it (from e2fsprogs). I cannot find
>> debugfs in btrfs-progs either. Any advice on how to do it?
>
>    I don't know what the ext* debugfs does, but the odds of it
> actually working on btrfs are pretty slim, given that they're
> completely different filesystems. :)
>
>    If you want a human-readable view of the filesystem's metadata,
> then btrfs-debug-tree is the tool you need.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>        --- Someone's been throwing dead sheep down my Fun Well ---
