Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:37322 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751342AbdIOWCC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 18:02:02 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 9C55D2510
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Sep 2017 00:02:01 +0200 (MEST)
Date: Sat, 16 Sep 2017 00:02:01 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: A user cannot remove his readonly snapshots?!
Message-ID: <20170915220201.GH32347@rus.uni-stuttgart.de>
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
 <22972.16657.822204.646994@tree.ty.sabi.co.uk>
 <20170915214434.GG32347@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170915214434.GG32347@rus.uni-stuttgart.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 2017-09-15 (23:44), Ulli Horlacher wrote:
> On Fri 2017-09-15 (22:07), Peter Grandi wrote:
> 
> > >  [ ... ] mounted with option user_subvol_rm_allowed [ ... ]
> > > root can delete this snapshot, but not the user. Why? [ ... ]
> > 
> > Ordinary permissions still apply both to 'create' and 'delete':
> 
> My user tux is the owner of the snapshot directory, because he has created it!

I can delete normal subvolumes but not the readonly snapshots:

tux@xerus:/test/tux/zz/.snapshot: btrfs subvolume create test
Create subvolume './test'

tux@xerus:/test/tux/zz/.snapshot: ll
drwxr-xr-x  tux      users    - 2017-09-15 18:22:26 2017-09-15_1822.test
drwxr-xr-x  tux      users    - 2017-09-15 18:22:26 2017-09-15_1824.test
drwxr-xr-x  tux      users    - 2017-09-15 18:57:39 2017-09-15_1859.test
drwxr-xr-x  tux      users    - 2017-09-15 23:58:51 test

tux@xerus:/test/tux/zz/.snapshot: btrfs subvolume delete test
Delete subvolume (no-commit): '/test/tux/zz/.snapshot/test'

tux@xerus:/test/tux/zz/.snapshot: btrfs subvolume delete 2017-09-15_1859.test
Delete subvolume (no-commit): '/test/tux/zz/.snapshot/2017-09-15_1859.test'
ERROR: cannot delete '/test/tux/zz/.snapshot/2017-09-15_1859.test': Read-only file system

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170915214434.GG32347@rus.uni-stuttgart.de>
