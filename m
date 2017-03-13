Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f47.google.com ([74.125.83.47]:34167 "EHLO
        mail-pg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdCMWTu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 18:19:50 -0400
Received: by mail-pg0-f47.google.com with SMTP id 77so71197087pgc.1
        for <linux-btrfs@vger.kernel.org>; Mon, 13 Mar 2017 15:19:49 -0700 (PDT)
Date: Mon, 13 Mar 2017 15:19:02 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Kai Krakow <hurikhan77@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Hard crash on 4.9.5
Message-ID: <20170313221902.GA2352@vader.DHCP.thefacebook.com>
References: <83c1a49a-b2ea-c7b6-151d-cbd15b6c9c93@techsquare.com>
 <20170125210618.GA18416@localhost.localdomain>
 <1d4c2360-0e6d-b476-e1af-2789ca01e59f@techsquare.com>
 <20170313225829.01c06724@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313225829.01c06724@jupiter.sol.kaishome.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 13, 2017 at 10:58:29PM +0100, Kai Krakow wrote:
> Am Sat, 28 Jan 2017 15:50:38 -0500
> schrieb Matt McKinnon <matt@techsquare.com>:
> 
> > This same file system (which crashed again with the same errors) is
> > also giving this output during a metadata or data balance:
> 
> This looks somewhat familiar to the err=-17 that I am experiencing when
> using VirtualBox image on btrfs in CoW mode (compress=lzo).
> 
> During IO intensive workloads, it results in "object already exists,
> err -17" (or similar, someone else also experienced it through another
> workload). The resulting btrfs check show the same errors, giving
> inodes without csum.
> 
> Trying to continue using this file system in successive boots usually
> results in boot freezes or complete unmountable filesystem, broken
> beyond repair.
> 
> I'm feeling that using the bfq elevator usually enables me to trigger
> this bug also without using VirtualBox, i.e. during normal system
> usage, and mostly during boot when IO load is very high. So I also
> stopped using bfq although it was giving me a much superior
> interactivity.
> 
> Marking vbox images nocow and using standard elevators (cfq, deadline)
> exposes no such problems so far - even during excessive IO loads.
> 
> EOM

This sounds similar to a bug I fixed here:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=8e2bd3b7fac91b79a6115fd1511ca20b2a09696d

That change is in v4.10. If you're not already running a kernel version
with that fix, could you check if that solves it?
