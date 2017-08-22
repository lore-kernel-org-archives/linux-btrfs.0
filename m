Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:45043 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932657AbdHVNM0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 09:12:26 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id 2173945C8
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 15:12:25 +0200 (MEST)
Date: Tue, 22 Aug 2017 15:12:13 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: finding root filesystem of a subvolume?
Message-ID: <20170822131213.GC14804@rus.uni-stuttgart.de>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <20170822124036.GA32302@carfax.org.uk>
 <20170822125030.GB14804@rus.uni-stuttgart.de>
 <fb1f381a-9f88-95cf-529c-2b12059fdae7@rqc.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fb1f381a-9f88-95cf-529c-2b12059fdae7@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 2017-08-22 (15:58), Marat Khalili wrote:
> On 22/08/17 15:50, Ulli Horlacher wrote:
> 
> > It seems, I have to scan the subvolume path upwards until I found a real
> > mount point,
> 
> I think searching /proc/mounts for the same device and subvol=/ in 
> options is most straightforward.

I have no subvol=/ option at all:

root@fex:~# grep btrfs /proc/mounts
/dev/sdf1 /backup btrfs rw,relatime,compress=zlib,space_cache 0 0
/dev/sde1 /local btrfs rw,relatime,compress=zlib,space_cache 0 0


> But what makes you think it's mounted at all?

I am only interested in mounted volumes.

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<fb1f381a-9f88-95cf-529c-2b12059fdae7@rqc.ru>
