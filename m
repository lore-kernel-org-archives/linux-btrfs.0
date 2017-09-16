Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33-wd.italiaonline.it ([212.48.13.167]:43864 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751183AbdIPIKv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 16 Sep 2017 04:10:51 -0400
Reply-To: kreijack@inwind.it
Subject: Re: A user cannot remove his readonly snapshots?!
To: linux-btrfs@vger.kernel.org
References: <20170915163736.GD32347@rus.uni-stuttgart.de>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <ce51b681-b86a-242a-1ac1-106454c32ddb@libero.it>
Date: Sat, 16 Sep 2017 10:10:48 +0200
MIME-Version: 1.0
In-Reply-To: <20170915163736.GD32347@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/2017 06:37 PM, Ulli Horlacher wrote:
> I have my btrfs filesystem mounted with option user_subvol_rm_allowed
> 
> tux@xerus: btrfs --version
> btrfs-progs v4.4
> 
> tux@xerus: uname -a
> Linux xerus 4.4.0-93-generic #116-Ubuntu SMP Fri Aug 11 21:17:51 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
> 
> tux@xerus: id
> uid=1000(tux) gid=100(users) groups=100(users)
> 
> tux@xerus: btrfs subvolume snapshot -r /test/tux/zz /test/tux/zz/.snapshot/2017-09-15_1824.test
> tux@xerus: btrfs subvolume delete /test/tux/zz/.snapshot/2017-09-15_1824.test
> Delete subvolume (no-commit): '/test/tux/zz/.snapshot/2017-09-15_1824.test'
> ERROR: cannot delete '/test/tux/zz/.snapshot/2017-09-15_1824.test': Read-only file system
> 
> root can delete this snapshot, but not the user. Why?

You should change the "ro" property to false before deleting it

	btrfs property set /test/tux/zz/.snapshot/2017-09-15_1824.test ro false


BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
