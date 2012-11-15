Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51995 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933443Ab2KOEV5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 23:21:57 -0500
Received: by mail-lb0-f174.google.com with SMTP id gp3so1016828lbb.19
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2012 20:21:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50A41C71.1060504@prnet.org>
References: <50A41C71.1060504@prnet.org>
Date: Wed, 14 Nov 2012 23:21:55 -0500
Message-ID: <CAAdM644U3k=0N4RsxTont7rObi9zD2FqZZk6X4+M5AtupdtoFA@mail.gmail.com>
Subject: Re: btrfs send/receive symlink bug
From: Marios Titas <redneb8888@gmail.com>
To: David Arendt <admin@prnet.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 14, 2012 at 5:34 PM, David Arendt <admin@prnet.org> wrote:
> Hi,
>
> I am using kernel 3.7.0-rc5 and latest btrfs-progs git.
>
> I am trying btrfs send/receive. When I have a filesystem containing a
> symlink pointing to a nonexistent destination or a destination created
> after the symlink was created, btrfs receive aborts with: ERROR: chown
> link1.txt failed. No such file or directory.
>
> Steps to reproduce (/dev/loop0 and /dev/loop1 are test images):
>
> mkfs.btrfs /dev/loop0
> mount /dev/loop0 /u00
> btrfs subvolume create /u00/test
> cd /u00/test
> ln -s test1.txt link1.txt
> btrfs subvolume snapshot -r /u00/test /u00/test.snapshot
> mkfs.btrfs /dev/loop1
> mount /dev/loop1 /u01
> btrfs send /u00/test.snapshot | btrfs receive /u01
> ERROR: chown link1.txt failed. No such file or directory


A patch [1] for btrfs-progs that solves this issue was posted a month
ago but has landed yet on the btrfs-progs git repository.

[1] http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg19539.html
