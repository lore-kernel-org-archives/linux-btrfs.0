Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:33558 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbbLLKem (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 12 Dec 2015 05:34:42 -0500
Received: by oifz134 with SMTP id z134so7439355oif.0
        for <linux-btrfs@vger.kernel.org>; Sat, 12 Dec 2015 02:34:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtTLrGin24rFGdvYV-JcegEgGEE7qK3gAYSd8K_SXFeu=g@mail.gmail.com>
References: <566b0cff.pXiyzYE4dYIOt31+%sivan606@gmail.com> <CAJCQCtTLrGin24rFGdvYV-JcegEgGEE7qK3gAYSd8K_SXFeu=g@mail.gmail.com>
From: Ivan Sizov <sivan606@gmail.com>
Date: Sat, 12 Dec 2015 13:34:21 +0300
Message-ID: <CAMG9ccx6ahFfnsq3DHUzemYjQwuTHD46nL1SqPsjeDNL4KTRWg@mail.gmail.com>
Subject: Re: Will "btrfs check --repair" fix the mounting problem?
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-12-11 21:24 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
> I would not repair it if the risk of it getting worse is bad for your data.
>
> Note the wiki says this feature is not well tested and is reported to
> not work reliably.
> https://btrfs.wiki.kernel.org/index.php/Conversion_from_Ext3
>
> Qu is working on patches to fix some of these problems, I don't know
> the status of any of that. I just did a conversion myself the other
> day with kernel 4.4.0rc3 and btrfs-progs 4.3.1 and that worked without
> error. But there were also no big files at all (it was just a clean OS
> installation). I immediately took a snapshot of that, and btrfs
> send/receive it to a new Btrfs volume, and then discarded the
> converted one entirely.
>
> The trace looks like it's mounting read-only? If it can be mounted
> read only, get the important data off the volume if it's not already
> backed up, and then blow it away. I personally wouldn't bother with
> repairing it.

What is the better way to get data? send/receive works only with RO
snapshots. Is there another way to preserve subvolumes and CoW
structure (a lot of files was copied between subvols using "cp
--reflink=always")? Or just rsync'ing files is all what I can do?
