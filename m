Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:60831 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754773AbdBGPDV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Feb 2017 10:03:21 -0500
Received: from ty.sabi.co.uk ([95.172.230.208]:56812)
        by azure.uno.uk.net with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
        (Exim 4.87)
        (envelope-from <pg@btrfs.list.sabi.co.uk>)
        id 1cb78d-0000LQ-SS
        for linux-btrfs@vger.kernel.org; Tue, 07 Feb 2017 14:52:59 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1cb73B-0004fI-If
        for <linux-btrfs@vger.kernel.org>; Tue, 07 Feb 2017 14:47:21 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <22681.56823.806106.671731@tree.ty.sabi.co.uk>
Date: Tue, 7 Feb 2017 14:47:19 +0000
To: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS for OLTP Databases
In-Reply-To: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
References: <CA+RUij3aW1ZYyJPNRLzckwOCCmoWa15Eu4h142jB_-qKc49hBw@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I have tried BTRFS from Ubuntu 16.04 LTS for write intensive
> OLTP MySQL Workload.

This has a lot of interesting and mostly agreeable information:

https://blog.pgaddict.com/posts/friends-dont-let-friends-use-btrfs-for-oltp

The main target of Btrfs is where one wants checksums and
occasional snapshot for backup (rather than rollback) and
applications do whole-file rewrites or appends.

> It did not go very well ranging from multi-seconds stalls
> where no transactions are completed

That usually is more because of the "clever" design and defaults
of the Linux page cache and block IO subsystem, which are
astutely pessimized for every workload, but especially for
read-modify-write ones, never mind for RMW workloads on
copy-on-write filesystems.

That most OS designs are pessimized for anything like a "write
intensive OLTP" workload is not new, M Stonebraker complained
about that 35 years ago, and nothing much has changed:

  http://www.sabi.co.uk/blog/anno05-4th.html?051012d#051012d

> to the finally kernel OOPS with "no space left on device"
> error message and filesystem going read only.

That's because Btrfs has a a two-level allocator, where space is
allocated in 1GiB chunks (distinct as to data and metadata) and
then in 16KiB nodes, and this makes it far more likely for free
space fragmentation to occur. Therefore Btrfs has a free space
compactor ('btrfs balance') that must be used the more often the
more updates happen.

> interested in "free" snapshots which look very attractive

The general problem is that it is pretty much impossible to have
read-modify-write rollbacks for cheap, because the writes in
general are scattered (that is their time coherence is very
different from their spatial coherence). That means either heavy
spatial fragmentation or huge write amplification.

The 'snapshot' type of DM/LVM2 device delivers heavy spatial
fragmentation, Btrfs does a balance of both. Another commenter
has mentioned the use of 'nodatacow' to prevent RMW resulting in
huge write-amplification.

> to use for database recovery scenarios allow instant rollback
> to the previous state.

You may be more interested in NILFS2 for that, but there are
significant tradeoffs there too, and NILFS2 requires a free
space compactor too, plus since NILFS2 gives up on short-term
spatial coherence, the compactor also needs to compact data
space.
