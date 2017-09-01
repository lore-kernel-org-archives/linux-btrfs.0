Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:35551 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752397AbdIAUnb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 16:43:31 -0400
Date: Fri, 1 Sep 2017 13:43:29 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960: errno=-17 Object already exists (since 3.4 / 2012)
Message-ID: <20170901204329.GH30689@merlins.org>
References: <20170715012216.njq6az3y34qyomtb@merlins.org> <20170715231245.GA28281@merlins.org> <20170829031637.GA15290@merlins.org> <F952197E-3A13-410A-B299-F5C0791A99DF@fb.com> <20170829143955.GD15290@merlins.org> <EEF8B32C-179F-431A-880F-A27AD96B4BEF@fb.com> <20170830034001.rlwaqsitco65exqi@merlins.org> <D6E7AD8E-AF2B-4A17-9692-FDE17F31A8D2@fb.com> <20170831173607.GM15290@merlins.org> <5320FF2E-D183-4D2A-A155-49424E1CD60F@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5320FF2E-D183-4D2A-A155-49424E1CD60F@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 31, 2017 at 05:48:23PM +0000, Josef Bacik wrote:
> We are using 4.11 in production at fb with backports from recent (a month ago?) stuff.  I’m relatively certain nothing bad will happen, and this branch has the most recent fsync() corruption fix (which exists in your kernel so it’s not new).  That said if you are uncomfortable I can rebase this patch onto whatever base you want and push out a branch, it’s your choice.  Keep in mind this is going to hold a lot of shit in memory, so I hope you have enough, and I’d definitely remove the sleep’s from your script, there’s no telling if this is a race condition or not and the overhead of the ref-verify stuff may cause it to be less likely to happen.  Thanks,

Thanks for the warning. I have 32GB of RAM in the server, and I probably use
8. Most of the rest is so that I can do btrfs check --repair without the
machine dying :-/

I am concerned that I have a lot more metadata than I have memory:
gargamel:~# btrfs fi df /mnt/btrfs_pool1
Data, single: total=10.66TiB, used=10.60TiB
System, DUP: total=32.00MiB, used=1.20MiB
Metadata, DUP: total=58.00GiB, used=12.76GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
gargamel:~# btrfs fi df /mnt/btrfs_pool2
Data, single: total=5.07TiB, used=4.78TiB
System, DUP: total=8.00MiB, used=640.00KiB
Metadata, DUP: total=70.50GiB, used=66.58GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

That's 13GB + 67GB.
Is it going to fall over if I only have 32GB of RAM?

If I stop mounting /mnt/btrfs_pool2 for a while, will 32GB of RAM
cover the 13GB of metadata from /mnt/btrfs_pool1 ?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
