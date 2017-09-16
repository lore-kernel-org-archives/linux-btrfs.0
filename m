Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34-i6.italiaonline.it ([212.48.14.168]:47174 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751170AbdIPJEQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 05:04:16 -0400
Reply-To: kreijack@inwind.it
Subject: Re: A user cannot remove his readonly snapshots?!
To: Kai Krakow <hurikhan77@gmail.com>, linux-btrfs@vger.kernel.org
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
 <22972.16657.822204.646994@tree.ty.sabi.co.uk>
 <20170915214434.GG32347@rus.uni-stuttgart.de>
 <20170915220201.GH32347@rus.uni-stuttgart.de>
 <20170916012248.0870f72d@jupiter.sol.kaishome.de>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <2d343791-7b32-bd53-a03d-a5b26465d358@libero.it>
Date: Sat, 16 Sep 2017 11:04:13 +0200
MIME-Version: 1.0
In-Reply-To: <20170916012248.0870f72d@jupiter.sol.kaishome.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/16/2017 01:22 AM, Kai Krakow wrote:
> Am Sat, 16 Sep 2017 00:02:01 +0200
> schrieb Ulli Horlacher <framstag@rus.uni-stuttgart.de>:
> 
>> On Fri 2017-09-15 (23:44), Ulli Horlacher wrote:
[...]
> 
> See "man mount" in section btrfs mount options: There is a mount option
> to allow normal user to delete snapshots. But this is said to has
> security implication I cannot currently tell. Maybe someone else knows.

"btrfs sub del" removes a subvolume independently by its contents: it doesn't check the subvolume files/directories and their permission/ownership. 

This is different from a "rm -rf", which (e.g.) can't delete a directory owned by a different user with files

ghigo@venice:/tmp$ mkdir d
ghigo@venice:/tmp$ mkdir d/d
ghigo@venice:/tmp$ touch d/d/f
ghigo@venice:/tmp$ sudo chown nobody d/d
ghigo@venice:/tmp$ rm -rf d
rm: cannot remove 'd/d/f': Permission denied

In the past I proposed to allow an ordinary user to remove an *empty* subvolume with a simple rmdir (if he has the permissions). This would solve this kind of problem.

https://www.spinics.net/lists/linux-btrfs/msg06499.html

or to relax the check around "btrfs sub del", so an user can remove an _empty_ subvolume

https://www.spinics.net/lists/linux-btrfs/msg06522.html

> 
> 
BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
