Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:36239 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbcDSLa2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 07:30:28 -0400
Received: by mail-lf0-f42.google.com with SMTP id g184so14988512lfb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2016 04:30:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <526644665.2251591.1461058513616.JavaMail.yahoo@mail.yahoo.com>
References: <CAPmG0jb0e5L=BYbO7k-4qh+o4qNqEjDqLe1=04+QMSWyhk0hFg@mail.gmail.com>
	<526644665.2251591.1461058513616.JavaMail.yahoo@mail.yahoo.com>
Date: Tue, 19 Apr 2016 13:30:25 +0200
Message-ID: <CAPmG0jbrupUYFdem2yAkFvSLwt9TL1e3pAv-0itGtGMD2AJATQ@mail.gmail.com>
Subject: Re: btrfs-image and btrfs send related queries
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I have /dev/sdb , /dev/sdc. Using wipefs -fa I cleared both devices and
> created btrfs on /dev/sdb. Mounted and written some files and unmounted it.
>
> Then I ran btrfs-image /dev/sdc /img1.img and got the dump.

It looks like you imaged the wrong device, that might clarify the IO
errors later on

> Once image created I again ran wipefs -fa /dev/sdb.
>
> Then I ran btrfs-image -r /img1.img /dev/sdc and mounted /dev/sdc.
>
> ls to dumped filesystem shows the file size as original and no file content.
> I guess btrfs-image doesn't modify files stat so i feel it is showing size
> as original.
>
> However running cat on some of files give i/o error
>
> qd67:/btrfs1 # cat shadow.h
> cat: shadow.h: Input/output error
>
> These errors are not on all files on other files, since dump doesn't
> contains any data it just prompts for cat as below.
>
> qd67:/btrfs1 # cat stab.h
> qd67:/btrfs1 # cat stdio_ext.h
>
> Not sure why i/o errors are coming.
