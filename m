Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f171.google.com ([209.85.214.171]:52500 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932067Ab3ENGsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 May 2013 02:48:21 -0400
Received: by mail-ob0-f171.google.com with SMTP id ef5so175403obb.30
        for <linux-btrfs@vger.kernel.org>; Mon, 13 May 2013 23:48:20 -0700 (PDT)
MIME-Version: 1.0
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Date: Tue, 14 May 2013 08:47:59 +0200
Message-ID: <CADn-QaPnKj1uxTURyv65NUoduZZN4G-1dXuN5G+677yW=_ujJg@mail.gmail.com>
Subject: Determining size of subvolumes
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

What's the easiest way to determine the size of snapshots/subvolumes?

As I come from a Solaris/FreeBSD background with ZFS, I compare the
feature sets and in ZFS I can easily do this:


# zfs list -t snapshot,filesystem -r datapool/home/ftp_example
NAME                        USED  AVAIL  REFER  MOUNTPOINT
datapool/home/ftp_example       442M  4.66G   346M  /home/ftp_example/
datapool/home/ftp_example@Tue  11.7M      -   344M  -
datapool/home/ftp_example@Wed  6.94M      -   345M  -
datapool/home/ftp_example@Thu  5.00M      -   344M  -
datapool/home/ftp_example@Fri  6.87M      -   345M  -
datapool/home/ftp_example@Sat  7.47M      -   346M  -
datapool/home/ftp_example@Sun  5.14M      -   346M  -
datapool/home/ftp_example@Mon  5.02M      -   346M  -


This shows me, that in the "ftp_example" filesystem, there are 346 MB
and in the "Wed"nesday snapshot, 6.94 MB got changed (or so…).

How could I do something like this with btrfs?

PS: On Ubuntu Linux 13.04 with their 3.8.0-20-generic kernel. Btrfs
v0.20-rc1-253-g7854c8b-dirty tools (from Git).

Thanks a lot,

Alexander
-- 
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
