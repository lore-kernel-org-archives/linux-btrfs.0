Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:59944 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756210AbdIHSl7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 8 Sep 2017 14:41:59 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 7D217243C
        for <linux-btrfs@vger.kernel.org>; Fri,  8 Sep 2017 20:41:57 +0200 (MEST)
Date: Fri, 8 Sep 2017 20:41:57 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: test if a subvolume is a snapshot?
Message-ID: <20170908184157.GB7876@rus.uni-stuttgart.de>
References: <20170908085446.GA7876@rus.uni-stuttgart.de>
 <20170908131035.GO31874@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170908131035.GO31874@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 2017-09-08 (15:10), David Sterba wrote:
> On Fri, Sep 08, 2017 at 10:54:46AM +0200, Ulli Horlacher wrote:
> 
> > How can I test if a subvolume is a snapshot?
> 
> The inode number is 256 on a btrfs filesystem:
> 
> if [ stat -f --format=%T $path = btrfs -a stat --format=%i $path = 256 ]; ...
> 
> The directory that's result of snapshotting a subvolume, also called
> EMPTY_SUBVOL has inode number 2, but that's not considered a normal
> subvolume.

This is not true.

root@fex:~# mount | grep /mnt/test
/dev/sdc1 on /mnt/test type btrfs (rw,relatime,space_cache,subvolid=5,subvol=/)

root@fex:~# btrfs subvol show /mnt/test
/mnt/test is toplevel subvolume

root@fex:~# btrfs subvolume snapshot -r /mnt/test /mnt/test/.snapshot/test
Create a readonly snapshot of '/mnt/test' in '/mnt/test/.snapshot/test'

root@fex:~# stat --format=%i /mnt/test
256

root@fex:~# stat --format=%i /mnt/test/.snapshot/test
256

No difference: both have inode=256


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170908131035.GO31874@twin.jikos.cz>
