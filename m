From: Arne Jansen <sensille@gmx.net>
Subject: Re: How to handle badblocks with btrfs?
Date: Tue, 28 Jun 2011 13:14:39 +0200
Message-ID: <4E09B79F.70703@gmx.net>
References: <BANLkTinrJV8DApCp8R=MnN-UZdPe6OrujA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: "Marco L. Crociani" <marco.crociani@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTinrJV8DApCp8R=MnN-UZdPe6OrujA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 28.06.2011 01:36, Marco L. Crociani wrote:
> # smartctl -d ata -l selftest /dev/sda
> smartctl 5.40 2010-07-12 r3124 [x86_64-unknown-linux-gnu] (local build)
> Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net
> 
> === START OF READ SMART DATA SECTION ===
> SMART Self-test log structure revision number 1
> Num  Test_Description    Status                  Remaining
> LifeTime(hours)  LBA_of_first_error
> # 1  Extended offline    Completed: read failure       90%       171
>       494581664
> 
> 
> What should I do to repair the disk?

Scrub can repair bad blocks as long as there's a good copy. To use scrub
you'll need the most recent rc-kernel and a btrfs-utility that supports
scrub, e.g. from the integration branch of Hugo Mills git tree, see his
recent mail for this.

> Is it possible to know which file is affected by the badblock?

There's a patch from Jan Schmidt for this, but it's not yet integrated.

> 
> I found http://smartmontools.sourceforge.net/badblockhowto.html but is
> about to ext2/3/4 fs.
> 
> I am concerned about the absence of fsck tool. Should I run badblocks
> on the unmounted fs?
> Thanks,
> 

