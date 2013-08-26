Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vb0-f51.google.com ([209.85.212.51]:42655 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3HZOrB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 10:47:01 -0400
Received: by mail-vb0-f51.google.com with SMTP id x16so2156482vbf.10
        for <linux-btrfs@vger.kernel.org>; Mon, 26 Aug 2013 07:47:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201308262335.25871.russell@coker.com.au>
References: <201308262335.25871.russell@coker.com.au>
Date: Mon, 26 Aug 2013 16:47:00 +0200
Message-ID: <CAFvQSYSgAPZkYUPF-pqSTGAQpHWAG7NDjBiJhwdxhsEqxSR+nA@mail.gmail.com>
Subject: Re: snapshot space available
From: Clemens Eisserer <linuxhippy@gmail.com>
To: russell@coker.com.au, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You are out of metadata, not "normal space".
However, the good question is why 0.5GB of metadata are unused and
btrfs reports no space left.
I have seen similar behaviour on a machine of mine, with exactly 0.5GB
of metadata unused.

Regards

2013/8/26 Russell Coker <russell@coker.com.au>:
> Linux xev 3.10-2-amd64 #1 SMP Debian 3.10.5-1 (2013-08-07) x86_64 GNU/Linux
>
> I've attached a file of script output from a system running the above Debian
> kernel on a system with an Intel 120G SSD.  To get this working again I
> extended the filesystem in question to also use a small USB flash device (4G
> from memory) and then deleted some old snapshots to free some space.
>
> The most intereting part of the script output is pasted below.  The system
> reports that the filesystem is 82% full but that there is no space left.
>
> root@xev:~# df -h /
> Filesystem                                              Size  Used Avail Use%
> Mounted on
> /dev/disk/by-uuid/586e6f48-2985-4115-9f89-f844b319c7c0  108G   87G   21G  82%
> /
> root@xev:~# btrfs filesystem df /
> Data: total=101.57GB, used=81.50GB
> System, DUP: total=8.00MB, used=20.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=3.00GB, used=2.50GB
> Metadata: total=8.00MB, used=0.00
> root@xev:~# ls -l > test
> bash: test: No space left on device
> root@xev:~# touch test
> touch: cannot touch ‘test’: No space left on device
> root@xev:~#
>
> --
> My Main Blog         http://etbe.coker.com.au/
> My Documents Blog    http://doc.coker.com.au/
