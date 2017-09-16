Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:46326 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751050AbdIPIyS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 04:54:18 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 1962D852C
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Sep 2017 10:54:16 +0200 (MEST)
Date: Sat, 16 Sep 2017 10:54:12 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: A user cannot remove his readonly snapshots?!
Message-ID: <20170916085412.GJ32347@rus.uni-stuttgart.de>
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
 <ce51b681-b86a-242a-1ac1-106454c32ddb@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ce51b681-b86a-242a-1ac1-106454c32ddb@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat 2017-09-16 (10:10), Goffredo Baroncelli wrote:

> > tux@xerus: btrfs subvolume snapshot -r /test/tux/zz /test/tux/zz/.snapshot/2017-09-15_1824.test
> > tux@xerus: btrfs subvolume delete /test/tux/zz/.snapshot/2017-09-15_1824.test
> > Delete subvolume (no-commit): '/test/tux/zz/.snapshot/2017-09-15_1824.test'
> > ERROR: cannot delete '/test/tux/zz/.snapshot/2017-09-15_1824.test': Read-only file system
> > 
> > root can delete this snapshot, but not the user. Why?
> 
> You should change the "ro" property to false before deleting it
> 
> 	btrfs property set /test/tux/zz/.snapshot/2017-09-15_1824.test ro false

tux@xerus: btrfs property set /test/tux/zz/.snapshot/2017-09-15_1824.test ro false
tux@xerus: btrfs subvolume delete /test/tux/zz/.snapshot/2017-09-15_1824.test
Delete subvolume (no-commit): '/test/tux/zz/.snapshot/2017-09-15_1824.test'

That's it! It works (now)! Great! Thanks!

Up to now I was thinking about a sudo solution, but this is not necessary
any more. Less complex solutions are always better :-)

I *love* this mailing list :-)

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<ce51b681-b86a-242a-1ac1-106454c32ddb@libero.it>
