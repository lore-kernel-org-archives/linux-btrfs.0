Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55056 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751164AbdIOXW7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 15 Sep 2017 19:22:59 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dszwg-0006uR-7u
        for linux-btrfs@vger.kernel.org; Sat, 16 Sep 2017 01:22:50 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: A user cannot remove his readonly snapshots?!
Date: Sat, 16 Sep 2017 01:22:48 +0200
Message-ID: <20170916012248.0870f72d@jupiter.sol.kaishome.de>
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
        <22972.16657.822204.646994@tree.ty.sabi.co.uk>
        <20170915214434.GG32347@rus.uni-stuttgart.de>
        <20170915220201.GH32347@rus.uni-stuttgart.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sat, 16 Sep 2017 00:02:01 +0200
schrieb Ulli Horlacher <framstag@rus.uni-stuttgart.de>:

> On Fri 2017-09-15 (23:44), Ulli Horlacher wrote:
> > On Fri 2017-09-15 (22:07), Peter Grandi wrote:
> >   
>  [...]  
> > > 
> > > Ordinary permissions still apply both to 'create' and 'delete':  
> > 
> > My user tux is the owner of the snapshot directory, because he has
> > created it!  
> 
> I can delete normal subvolumes but not the readonly snapshots:
> 
> tux@xerus:/test/tux/zz/.snapshot: btrfs subvolume create test
> Create subvolume './test'
> 
> tux@xerus:/test/tux/zz/.snapshot: ll
> drwxr-xr-x  tux      users    - 2017-09-15 18:22:26
> 2017-09-15_1822.test drwxr-xr-x  tux      users    - 2017-09-15
> 18:22:26 2017-09-15_1824.test drwxr-xr-x  tux      users    -
> 2017-09-15 18:57:39 2017-09-15_1859.test drwxr-xr-x  tux
> users    - 2017-09-15 23:58:51 test
> 
> tux@xerus:/test/tux/zz/.snapshot: btrfs subvolume delete test
> Delete subvolume (no-commit): '/test/tux/zz/.snapshot/test'
> 
> tux@xerus:/test/tux/zz/.snapshot: btrfs subvolume delete
> 2017-09-15_1859.test Delete subvolume (no-commit):
> '/test/tux/zz/.snapshot/2017-09-15_1859.test' ERROR: cannot delete
> '/test/tux/zz/.snapshot/2017-09-15_1859.test': Read-only file system

See "man mount" in section btrfs mount options: There is a mount option
to allow normal user to delete snapshots. But this is said to has
security implication I cannot currently tell. Maybe someone else knows.


-- 
Regards,
Kai

Replies to list-only preferred.

