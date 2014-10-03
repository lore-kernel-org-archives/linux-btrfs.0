Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42376 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828AbaJCQxe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Oct 2014 12:53:34 -0400
Received: by mail-pd0-f178.google.com with SMTP id y10so2733353pdj.23
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Oct 2014 09:53:34 -0700 (PDT)
Date: Fri, 3 Oct 2014 09:53:32 -0700
From: Omar Sandoval <osandov@osandov.com>
To: Jogi =?iso-8859-1?Q?Hofm=FCller?= <jogi@mur.at>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs 3.16.2 does not recognize subvolumes correctly
Message-ID: <20141003165332.GA24593@mew.dhcp4.washington.edu>
References: <542D100F.9050502@mur.at>
 <542E7D21.2030905@mur.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <542E7D21.2030905@mur.at>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 03, 2014 at 12:40:33PM +0200, Jogi Hofmüller wrote:
> Hi all,
> 
> First of all, I am talking about btrfs-progs 3.16.2 if there was any doubt.
> 
> I did some more checking and found the following disturbing results.
> 
> I can still create snapshots of subvolumes and the default subvolume (/)
> without problems.  But sending the snapshot fails with the error:
> 
> ERROR: /.SNAPSHOT doesn't belong to btrfs mount point
> 
> btrfs subvolume list -a /
> 
> ID 259 gen 21444 top level 5 path home
> ID 260 gen 21443 top level 5 path var
> ID 742 gen 18830 top level 5 path .SNAPSHOT
> ID 743 gen 18832 top level 259 path home/.SNAPSHOT
> 
> But then again e.g.
> 
> btrfs subvolume show /home
> ERROR: /home doesn't belong to btrfs mount point
> 
> All this is happening on my laptop running kernel 3.16.3. (Debian).
> 
> Interestingly enough I have another machine where only the default
> subvolume makes problems but another subvolume can be snapshotted and
> the snapshot send.  This machine uses kernel 3.14.15.
> 
> Please let me know what I can do to fix this.

There was a similar issue in btrfs-progs 3.16 that was fixed in 3.16.1 by this
commit:
https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/commit/?id=6a47725a6fb8a463dd60611800222c7297195588

I'd do a quick `btrfs --version` just to make sure you're running the version
you think you are. Otherwise, the output of `mount` might shed some light on why
you're getting this.

-- 
Omar
