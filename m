Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp02.belwue.de ([129.143.71.87]:38045 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750909AbdIPHgf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 03:36:35 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id 1581291D0
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Sep 2017 09:36:34 +0200 (MEST)
Date: Sat, 16 Sep 2017 09:36:33 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: A user cannot remove his readonly snapshots?!
Message-ID: <20170916073633.GI32347@rus.uni-stuttgart.de>
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
 <22972.16657.822204.646994@tree.ty.sabi.co.uk>
 <20170915214434.GG32347@rus.uni-stuttgart.de>
 <20170915220201.GH32347@rus.uni-stuttgart.de>
 <20170916012248.0870f72d@jupiter.sol.kaishome.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170916012248.0870f72d@jupiter.sol.kaishome.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 2017-09-16 (01:22), Kai Krakow wrote:

> > tux@xerus:/test/tux/zz/.snapshot: btrfs subvolume delete
> > 2017-09-15_1859.test Delete subvolume (no-commit):
> > '/test/tux/zz/.snapshot/2017-09-15_1859.test' ERROR: cannot delete
> > '/test/tux/zz/.snapshot/2017-09-15_1859.test': Read-only file system
> 
> See "man mount" in section btrfs mount options: There is a mount option
> to allow normal user to delete snapshots.

As I wrote first: "I have mounted with option user_subvol_rm_allowed"

tux@xerus:/test/tux/zz/.snapshot: mount | grep /test
/dev/sdd4 on /test type btrfs (rw,relatime,space_cache,user_subvol_rm_allowed,subvolid=5,subvol=/)

This does not help. A user cannot remove a readonly snapshot he just has
created.


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170916012248.0870f72d@jupiter.sol.kaishome.de>
