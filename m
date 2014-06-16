Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34811 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaFPBGf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 21:06:35 -0400
Received: by mail-qc0-f174.google.com with SMTP id x13so6804051qcv.19
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Jun 2014 18:06:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1709025.rRUgx5gMp1@xev>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost>
	<539BFF47.8060006@libero.it>
	<20140615221307.GE24386@tango.0pointer.de>
	<1709025.rRUgx5gMp1@xev>
Date: Sun, 15 Jun 2014 18:06:34 -0700
Message-ID: <CAJBj3vdQp3d+t-Nf112UVt_Kfrv9avhbSs1Rx=d8ca2kwtRQdw@mail.gmail.com>
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
From: John Williams <jwilliams4200@gmail.com>
To: russell@coker.com.au
Cc: Lennart Poettering <lennart@poettering.net>, kreijack@inwind.it,
        Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 15, 2014 at 5:17 PM, Russell Coker <russell@coker.com.au> wrote:
> I just did some tests using fallocate(1).  I did the tests both with and
> without the -n option which appeared to make no difference.
>
> I started by allocating a 24G file on a 106G filesystem that had 30G free
> according to df.  The first time that took almost 2 minutes of system CPU time
> on a Q8400 CPU.

Why does it take 2 minutes? On XFS or ext4, fallocate is almost
instantaneous, even for multi-Terabyte allocations.

According the fallocate man page, preallocation should be quick and
require no IO:

"      fallocate  is  used  to manipulate the allocated disk space for a file,
       either to deallocate or preallocate it. For filesystems  which  support
       the  fallocate system call, preallocation is done quickly by allocating
       blocks and marking them as uninitialized, requiring no IO to  the  data
       blocks.  This  is  much  faster than creating a file by filling it with
       zeros."
