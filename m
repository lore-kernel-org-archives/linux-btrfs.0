Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51606 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbdH3DkN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Aug 2017 23:40:13 -0400
Date: Tue, 29 Aug 2017 20:40:01 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20170830034001.rlwaqsitco65exqi@merlins.org>
References: <20170715004828.f4bom5wq34abe4lz@merlins.org>
 <20170711062155.hvlx5ud4zphpzjnp@merlins.org>
 <20170715012216.njq6az3y34qyomtb@merlins.org>
 <20170715231245.GA28281@merlins.org>
 <20170829031637.GA15290@merlins.org>
 <F952197E-3A13-410A-B299-F5C0791A99DF@fb.com>
 <20170829143955.GD15290@merlins.org>
 <EEF8B32C-179F-431A-880F-A27AD96B4BEF@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <EEF8B32C-179F-431A-880F-A27AD96B4BEF@fb.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 29, 2017 at 06:22:38PM +0000, Josef Bacik wrote:
> How much metadata do you have on this fs?  I was going to hold everything in bpf hash trees, but I’m worried we’ll hit collisions and then the tracing will be useless.  If it’s too big I’ll have to dump everything to userspace and let python take care of keeping everything in memory, so if you have a lot of metadata hopefully you have lots of memory too ;).  Thanks,

gargamel:~# btrfs fi df /mnt/btrfs_pool1
Data, single: total=10.60TiB, used=10.54TiB
System, DUP: total=32.00MiB, used=1.19MiB
Metadata, DUP: total=58.00GiB, used=12.69GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
