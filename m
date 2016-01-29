Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:33226 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbcA2U05 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 29 Jan 2016 15:26:57 -0500
Received: by mail-ig0-f180.google.com with SMTP id z14so44467122igp.0
        for <linux-btrfs@vger.kernel.org>; Fri, 29 Jan 2016 12:26:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAAcrkYJmDHNijZx45cdfZNTgVCgvih_06WROGJg+pjYsQT-=tg@mail.gmail.com>
References: <CAAcrkYJmDHNijZx45cdfZNTgVCgvih_06WROGJg+pjYsQT-=tg@mail.gmail.com>
Date: Fri, 29 Jan 2016 13:26:56 -0700
Message-ID: <CAJCQCtQDy3P2kWWU1=sHCY05T6qhFCnnk4j7r4NJ=hcfm+PFXA@mail.gmail.com>
Subject: Re: csum failed : d-raid0, m-raid1
From: Chris Murphy <lists@colorremedies.com>
To: John Smith <lenovomi@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 29, 2016 at 11:04 AM, John Smith <lenovomi@gmail.com> wrote:
> Hi
>
> i built btrfs volume using 2x3tb brand new /tested for badblocks
> drives. I copied into volume around 5Tb of data.
>
> I tried to read one file which is around 4GB and i got input / output error.
>
> Dmesg contains:
>
> [154159.040059] BTRFS warning (device sdd): csum failed ino 9995246
> off 4506214400 csum 383964635 expected csum 6478505
>
>
> Any idea what is it? Whats the reason that this happened? Can I recover?

You haven't provided enough info to really answer the first two
questions. That this is raid1 for metadata and you're getting a
checksum error without a fixup says this is a problem with a data
block not checksumming. Why? Need a complete dmesg to see what else
was going on. Even that won't necessarily answer the question. Could
be silent corruption anywhere in the chain, and may not be caused by
the drives themselves. Could be a connector. Could be a controller.
Could be RAM. Could be a bug (seems sorta unlikely at this point but
we don't know what kernel or btrfs-progs version you're using).

As far as I know you can't recover the affected file(s)
conventionally, Btrfs won't hand over data it thinks id corrupt. You
can use find <mountpoint> -inum <value> to find files with that inode
number. Unmount the file system. Then use btrfs restore to get the
file. The man page has more info including a wiki document on how to
use restore.



-- 
Chris Murphy
