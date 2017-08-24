Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:60618 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753228AbdHXRpW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 13:45:22 -0400
Received: from ty.sabi.co.uk ([95.172.230.208]:56566)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1dkwC0-00042R-Nm
        for linux-btrfs@vger.kernel.org; Thu, 24 Aug 2017 18:45:20 +0100
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1dkwBv-00085d-4k
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Aug 2017 18:45:15 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22943.4266.793339.528061@tree.ty.sabi.co.uk>
Date: Thu, 24 Aug 2017 18:45:14 +0100
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: number of subvolumes
In-Reply-To: <onkbkk$qs1$1@blaine.gmane.org>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
        <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
        <20170822142451.GI14804@rus.uni-stuttgart.de>
        <20170822214531.44538589@natsu>
        <20170822165725.GL14804@rus.uni-stuttgart.de>
        <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
        <20170822180155.GM14804@rus.uni-stuttgart.de>
        <22940.31139.194399.982315@tree.ty.sabi.co.uk>
        <20170822204811.GO14804@rus.uni-stuttgart.de>
        <20170823071821.GA28319@rus.uni-stuttgart.de>
        <f75e66d.7ade2c40.15e0e3ced5c@gmail.com>
        <onkbkk$qs1$1@blaine.gmane.org>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> Using hundreds or thousands of snapshots is probably fine
>> mostly.

As I mentioned previously, with a link to the relevant email
describing the details, the real issue is reflinks/backrefs.
Usually subvolume and snapshots involve them.

> We find that typically apt is very slow on a machine with 50
> or so snapshots and raid10. Slow as in probably 10x slower as
> doing the same update on a machine with 'single' and no
> snapshots.

That seems to indicate using snapshots on a '/' volume to
provide a "rollback machine" like SUSE. Since '/' usually has
many small files and installation of upgraded packages involves
only a small part of them, that usually involves a lot of
reflinks/backrefs.

But that you find that the system has slowed down significantly
in ordinary operations is unusual, because what is slow in
situations with many relinks/backrefs per extent is not access,
but operations like 'balance' or 'delete'.

Guessing wildly what you describe seems more the effect of low
locality (aka high fragmentation) which is often the result of
the 'ssd' option which should always be explicitly disabled
(even for volumes on flash SSD storage). I would suggest some
use of 'filefrag' to analyze and perhaps use of 'defrag' and
'balance'.

Another possibility is having enabled compression with the
presence of many in-place updates on some files, which can
result also in low locality (high fragmentation).

As usual with Btrfs, there are corner cases to avoid: 'defrag'
should be done before 'balance' and with compression switched
off (IIRC):

https://wiki.archlinux.org/index.php/Btrfs#Defragmentation

  Defragmenting a file which has a COW copy (either a snapshot
  copy or one made with cp --reflink or bcp) plus using the -c
  switch with a compression algorithm may result in two
  unrelated files effectively increasing the disk usage.

https://wiki.debian.org/Btrfs

  Mounting with -o autodefrag will duplicate reflinked or
  snapshotted files when you run a balance. Also, whenever a
  portion of the fs is defragmented with "btrfs filesystem
  defragment" those files will lose their reflinks and the data
  will be "duplicated" with n-copies. The effect of this is that
  volumes that make heavy use of reflinks or snapshots will run
  out of space.

  Additionally, if you have a lot of snapshots or reflinked files,
  please use "-f" to flush data for each file before going to the
  next file.

I prefer dump-and-reload.
