Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:37034 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751473AbdIOVog (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 17:44:36 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 9C3152347
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 23:44:34 +0200 (MEST)
Date: Fri, 15 Sep 2017 23:44:34 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: A user cannot remove his readonly snapshots?!
Message-ID: <20170915214434.GG32347@rus.uni-stuttgart.de>
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
 <22972.16657.822204.646994@tree.ty.sabi.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <22972.16657.822204.646994@tree.ty.sabi.co.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 2017-09-15 (22:07), Peter Grandi wrote:
> >  [ ... ] mounted with option user_subvol_rm_allowed [ ... ]
> > root can delete this snapshot, but not the user. Why? [ ... ]
> 
> Ordinary permissions still apply both to 'create' and 'delete':

My user tux is the owner of the snapshot directory, because he has created it!

tux@xerus:/test/tux/zz: id
uid=1000(tux) gid=100(users) groups=100(users)

tux@xerus:/test/tux/zz: ll .snapshot/
drwxr-xr-x  tux      users    - 2017-09-15 18:22:26 .snapshot/2017-09-15_1822.test
drwxr-xr-x  tux      users    - 2017-09-15 18:22:26 .snapshot/2017-09-15_1824.test
drwxr-xr-x  tux      users    - 2017-09-15 18:57:39 .snapshot/2017-09-15_1859.test

tux@xerus:/test/tux/zz: btrfs subvolume delete .snapshot/2017-09-15_1859.test
Delete subvolume (no-commit): '/test/tux/zz/.snapshot/2017-09-15_1859.test'
ERROR: cannot delete '/test/tux/zz/.snapshot/2017-09-15_1859.test': Read-only file system

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<22972.16657.822204.646994@tree.ty.sabi.co.uk>
