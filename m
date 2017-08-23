Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from demfloro.ru ([188.166.0.225]:40880 "EHLO demfloro.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753263AbdHWHQ6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Aug 2017 03:16:58 -0400
Date: Wed, 23 Aug 2017 10:16:35 +0300
From: Dmitrii Tcvetkov <demfloro@demfloro.ru>
To: Ulli Horlacher <framstag@rus.uni-stuttgart.de>,
        Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: user snapshots
Message-ID: <20170823101635.114d02d2@job>
In-Reply-To: <124CEBB9-BF23-4688-B23C-294EDCAD27AA@demfloro.ru>
References: <20170822132208.GD14804@rus.uni-stuttgart.de>
        <CAEtw4r1cDuE0F_MXe6mHDUr03BhEueBWeq7YaRYjNhhf=UD6KQ@mail.gmail.com>
        <20170822142451.GI14804@rus.uni-stuttgart.de>
        <20170822214531.44538589@natsu>
        <20170822165725.GL14804@rus.uni-stuttgart.de>
        <ab52f32.7ade2c3f.15e0af46ee9@gmail.com>
        <20170822180155.GM14804@rus.uni-stuttgart.de>
        <22940.31139.194399.982315@tree.ty.sabi.co.uk>
        <20170822215343.GP14804@rus.uni-stuttgart.de>
        <124CEBB9-BF23-4688-B23C-294EDCAD27AA@demfloro.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> >Also in https://btrfs.wiki.kernel.org/index.php/Mount_options
> >"user_subvol_rm_allowed (...) Use with caution."
> >
> >Why? What is the problem?  
> 
> Because with the mount option any user can delete any subvolume,
> including root one (subvol_id=5)

Apologies, it works somewhat different:
filesystem doesn't allow to delete subvolume with id 5 and POSIX access
is checked before deleting subvolume with user_subvol_rm_allowed mount
option.

>From btrfs-progs cmds-subvolume.c:

res = ioctl(fd, BTRFS_IOC_SNAP_DESTROY, &args);
if(res < 0 ){
         error("cannot delete '%s/%s': %s", dname, vname,
                 strerror(errno));
