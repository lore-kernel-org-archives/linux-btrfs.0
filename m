Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:48336 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751182AbdIPKTD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 06:19:03 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id A57458DD6
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Sep 2017 12:19:01 +0200 (MEST)
Date: Sat, 16 Sep 2017 12:19:01 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: A user cannot remove his readonly snapshots?!
Message-ID: <20170916101901.GM32347@rus.uni-stuttgart.de>
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
 <ce51b681-b86a-242a-1ac1-106454c32ddb@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ce51b681-b86a-242a-1ac1-106454c32ddb@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 2017-09-16 (10:10), Goffredo Baroncelli wrote:
> On 09/15/2017 06:37 PM, Ulli Horlacher wrote:

> > I have my btrfs filesystem mounted with option user_subvol_rm_allowed
> 
> You should change the "ro" property to false before deleting it
> 
> 	btrfs property set /test/tux/zz/.snapshot/2017-09-15_1824.test ro false

Still one problem is left: 
How can I test a subvolume for the mount option user_subvol_rm_allowed?
df only works for the root subvolume:

root@xerus:/test/tux# df -T .
Filesystem     Type  1K-blocks   Used Available Use% Mounted on
/dev/sdd4      btrfs  54524928 103372  52326324   1% /test

root@xerus:/test/tux# df -T zz
Filesystem     Type 1K-blocks   Used Available Use% Mounted on
-              -     54524928 103372  52326324   1% /test/tux/zz

root@xerus:/test/tux# mount | grep /test
/dev/sdd4 on /test type btrfs (rw,relatime,space_cache,user_subvol_rm_allowed,subvolid=5,subvol=/)

How do I know the btrfs filesystem for a given subvolume?
Do I really have to manually test the diretory path upwards?


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<ce51b681-b86a-242a-1ac1-106454c32ddb@libero.it>
