Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:43301 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592Ab3BJQvc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 10 Feb 2013 11:51:32 -0500
Received: by mail-la0-f54.google.com with SMTP id gw10so5191819lab.13
        for <linux-btrfs@vger.kernel.org>; Sun, 10 Feb 2013 08:51:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAFhuFEeZqu_t0geQSi-8sfGnwvxaJYqvVx9izvpb4UdGS8Zt-g@mail.gmail.com>
References: <CAFhuFEcT=2rNA0dkyKjeEExOX5dMJt04hkgEr1QGgq8M74UYsg@mail.gmail.com>
	<CAFhuFEff9KV1QFE8geEw__jRAcjnBEbTkG9p6S6v0xMsf7G=Vg@mail.gmail.com>
	<CAFhuFEeZqu_t0geQSi-8sfGnwvxaJYqvVx9izvpb4UdGS8Zt-g@mail.gmail.com>
Date: Sun, 10 Feb 2013 22:21:31 +0530
Message-ID: <CAFhuFEeKTSZEr-Hy_1wj0GwKTP29SgG1sQr4Et7icBeRqh8CMQ@mail.gmail.com>
Subject: Re: Diff using send-receive code
From: nafisa mandliwala <nafisa.mandliwala@gmail.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
        We're a team of 4 final year computer science students and are
working on generating a diff between file system snapshots using the
send receive code.

        The output of our utility  looks like this-
(I've tested it on a small subvol with minimal changes just to give an idea)

root@nafisa-M-6319:/mnt/btrfs# btrfs sub diff -p /mnt/btrfs/snap1
/mnt/btrfs/snap2

Directory Deleted path = dir5

File Deleted path = 1.c

File Written path = 3.c data written : "3.c was changed"

File Moved path from = 4.c path to = dir1/4.c

new files created = 0
new dir created = 0
files deleted = 1
changed links = 1
dirs deleted = 1
files written = 1

         We want the diff output to look more structured and request
suggestions on the same. Something along the lines of git-diff output
format.

Thanks!
