Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:34983 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751778AbdIOTcN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 15:32:13 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 5B0538892
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Sep 2017 21:32:11 +0200 (MEST)
Date: Fri, 15 Sep 2017 21:32:11 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: A user cannot remove his readonly snapshots?!
Message-ID: <20170915193211.GE32347@rus.uni-stuttgart.de>
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
 <38b35e41-313a-1eed-667a-ee3138c8170d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <38b35e41-313a-1eed-667a-ee3138c8170d@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 2017-09-15 (13:08), Austin S. Hemmelgarn wrote:
> On 2017-09-15 12:37, Ulli Horlacher wrote:
> 
> > I have my btrfs filesystem mounted with option user_subvol_rm_allowed
> > tux@xerus: btrfs subvolume delete /test/tux/zz/.snapshot/2017-09-15_1824.test
> > Delete subvolume (no-commit): '/test/tux/zz/.snapshot/2017-09-15_1824.test'
> > ERROR: cannot delete '/test/tux/zz/.snapshot/2017-09-15_1824.test': Read-only file system
> > 
> > root can delete this snapshot, but not the user. Why?
> > 
> 
> Add 'user_subvol_rm' to the mount options and try again.

root@xerus:~# mount -vo user_subvol_rm /dev/sdd4 /test
mount: wrong fs type, bad option, bad superblock on /dev/sdd4,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

root@xerus:~# dmesg | tail -2
[1514588.018991] BTRFS info (device sdd4): unrecognized mount option 'user_subvol_rm'
[1514588.028430] BTRFS: open_ctree failed

user_subvol_rm is not listed on
https://btrfs.wiki.kernel.org/index.php/Mount_options

Did you mean user_subvol_rm_allowed?
I have already used this option, without success. See above.


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<38b35e41-313a-1eed-667a-ee3138c8170d@gmail.com>
