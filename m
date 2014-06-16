Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 220-245-31-42.static.tpgi.com.au ([220.245.31.42]:39627 "EHLO
	smtp.sws.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaFPCTx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Jun 2014 22:19:53 -0400
From: Russell Coker <russell@coker.com.au>
To: John Williams <jwilliams4200@gmail.com>
Reply-To: russell@coker.com.au
Cc: Lennart Poettering <lennart@poettering.net>, kreijack@inwind.it,
        Duncan <1i5t5.duncan@cox.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        systemd-devel@lists.freedesktop.org
Subject: Re: [systemd-devel] Slow startup of systemd-journal on BTRFS
Date: Mon, 16 Jun 2014 12:19:47 +1000
Message-ID: <11598527.ycfSoA5G7j@xev>
In-Reply-To: <CAJBj3vdQp3d+t-Nf112UVt_Kfrv9avhbSs1Rx=d8ca2kwtRQdw@mail.gmail.com>
References: <1346098950.2730051402571606829.JavaMail.defaultUser@defaultHost> <1709025.rRUgx5gMp1@xev> <CAJBj3vdQp3d+t-Nf112UVt_Kfrv9avhbSs1Rx=d8ca2kwtRQdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 15 Jun 2014 18:06:34 John Williams wrote:
> Why does it take 2 minutes? On XFS or ext4, fallocate is almost
> instantaneous, even for multi-Terabyte allocations.
> 
> According the fallocate man page, preallocation should be quick and
> require no IO:
> 
> "      fallocate  is  used  to manipulate the allocated disk space for a
> file, either to deallocate or preallocate it. For filesystems  which 
> support the  fallocate system call, preallocation is done quickly by
> allocating blocks and marking them as uninitialized, requiring no IO to 
> the  data blocks.  This  is  much  faster than creating a file by filling
> it with zeros."

No IO to data blocks but there is IO to metadata.

But I think that BTRFS may need some optimisation for such things.  While 
fallocate() on 24G is probably a very unusual case it will probably matter to 
some people (I can imagine scientific computing needing it) and it's likely 
that much smaller fallocate() calls also take longer than desired.

The issue was system CPU time, extending the file in that test was proceeding 
at a speed of about 200MB/s for allocated space - while the system was writing 
something less than 2MB/s to the device (sometimes it went for 10+ seconds 
without writing any data).  The SSD in question can sustain about 200MB/s of 
data written so in that case the BTRFS speed for allocating disk space was 
about equal to the speed it should be able to write real data.

-- 
My Main Blog         http://etbe.coker.com.au/
My Documents Blog    http://doc.coker.com.au/

