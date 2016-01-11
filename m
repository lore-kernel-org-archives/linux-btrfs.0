Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:34590 "EHLO
	mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759700AbcAKNGF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 08:06:05 -0500
Received: by mail-io0-f170.google.com with SMTP id 1so300501727ion.1
        for <linux-btrfs@vger.kernel.org>; Mon, 11 Jan 2016 05:06:04 -0800 (PST)
Subject: Re: 6TB partition, Data only 2TB - aka When you haven't hit the
 "usual" problem
To: "cheater00 ." <cheater00@gmail.com>, Hugo Mills <hugo@carfax.org.uk>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtSyJ8cHrmZcnLQ_fvsaaS1qZiQx_rsFt7-_6LJuvhKR-A@mail.gmail.com>
 <CA+9GZUgnmMoLeGsyeo=tFe2GLsDkLEr0umiDovf3P2aBtDA+Xg@mail.gmail.com>
 <CA+9GZUjRWNVShW=6jfCVDTjRdQQCS9T_-cMkOF3s8846uAhn+w@mail.gmail.com>
 <CA+9GZUiWQ2tAotFuq2Svkjnk+2Quz5B8UwZSSpm4SJfhqfoStQ@mail.gmail.com>
 <CAJCQCtR3Gj5K0dsAhDBo27Z6h3ki5cs6X0SrrFhC0dPPgY=4nw@mail.gmail.com>
 <CA+9GZUjLcRnRX_mwO-McXWFd+G4o3jtBENMLnszg-rJTn6vL1w@mail.gmail.com>
 <CAJCQCtRhYZi9nqWP_LYmZeg1yRQVkpnmUDQ-P5o1-gc-3w+Pdg@mail.gmail.com>
 <CA+9GZUg1CSFAURu05MuQvsYPVr9maiYvGMQHTzCmU5ev-C63Kg@mail.gmail.com>
 <20160109202659.GC6060@carfax.org.uk>
 <CA+9GZUjeJBhjr4ERBLHehhA2xow=-5gBYR4+y8eiMGxhiCi_mA@mail.gmail.com>
 <20160109210429.GD6060@carfax.org.uk>
 <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5693A8B3.2090508@gmail.com>
Date: Mon, 11 Jan 2016 08:05:55 -0500
MIME-Version: 1.0
In-Reply-To: <CA+9GZUg-F1PWSAvpwy3=D6tz1gNgK88nTYzUP32D_hbg0H=rYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-09 16:07, cheater00 . wrote:
> Would like to point out that this can cause data loss. If I'm writing
> to disk and the disk becomes unexpectedly read only - that data will
> be lost, because who in their right mind makes their code expect this
> and builds a contingency (e.g. caching, backpressure, etc)...
If a data critical application (mail server, database server, anything 
similar) can't gracefully handle ENOSPC, then that application is 
broken, not the FS.  As an example, set up a small VM with an SMTP 
server, then force the FS the server uses for queuing mail read-only, 
and see if you can submit mail, then go read the RFCs for SMTP and see 
what clients are supposed to do when they can't submit mail.  A properly 
designed piece of software is supposed to be resilient against common 
failure modes of the resources it depends on (which includes ENOSPC and 
read-only filesystems for anything that works with data on disk).
>
> There's no loss of data on the disk because the data doesn't make it
> to disk in the first place. But it's exactly the same as if the data
> had been written to disk, and then lost.
>
No, it isn't.  If you absolutely need the data on disk, you should be 
calling fsync or fdatasync, and then assuming if those return an error 
that none of the data written since the last call has gotten to the disk 
(some of it might have, but you need to assume it hasn't).  Every piece 
of software in wide usage that requires data to be on the disk does 
this, because otherwise it can't guarantee that the data is on disk.
