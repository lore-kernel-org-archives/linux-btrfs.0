Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:41783 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932720AbdHVMub (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 08:50:31 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id AA065867B
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 14:50:30 +0200 (MEST)
Date: Tue, 22 Aug 2017 14:50:30 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: finding root filesystem of a subvolume?
Message-ID: <20170822125030.GB14804@rus.uni-stuttgart.de>
References: <20170822122350.GA14804@rus.uni-stuttgart.de>
 <20170822124036.GA32302@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170822124036.GA32302@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue 2017-08-22 (12:40), Hugo Mills wrote:
> On Tue, Aug 22, 2017 at 02:23:50PM +0200, Ulli Horlacher wrote:
> 
> > How do I find the root filesystem of a subvolume?
> > Example:
> > 
> > root@fex:~# df -T 
> > Filesystem     Type  1K-blocks      Used Available Use% Mounted on
> > -              -    1073740800 104244552 967773976  10% /local/.backup/home
> 
>    I've never seen the "- -" output from df before. Is this a bind
> mount or something?

No, /local/.backup/home is just a btrfs subvolume


> > I know, the root filesystem is /local, but who can I show it by command?
> 
>    Probably in /proc/self/mountinfo 

root@fex:~# grep home /proc/self/mountinfo
root@fex:~# grep btrfs /proc/self/mountinfo
31 22 0:23 / /backup rw,relatime - btrfs /dev/sdf1 rw,compress=zlib,space_cache
32 22 0:26 / /local rw,relatime - btrfs /dev/sde1 rw,compress=zlib,space_cache

No information about the subvolume /local/.backup/home

It seems, I have to scan the subvolume path upwards until I found a real
mount point,

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170822124036.GA32302@carfax.org.uk>
