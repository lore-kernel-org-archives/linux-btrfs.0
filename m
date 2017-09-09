Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:61745 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757337AbdIIKlM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 9 Sep 2017 06:41:12 -0400
Subject: Re: generic name for volume and subvolume root?
To: linux-btrfs@vger.kernel.org, framstag@rus.uni-stuttgart.de
References: <20170909083551.GC22060@rus.uni-stuttgart.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <48008a58-a82e-d9f7-327e-eeb905e18aa1@gmx.com>
Date: Sat, 9 Sep 2017 18:40:57 +0800
MIME-Version: 1.0
In-Reply-To: <20170909083551.GC22060@rus.uni-stuttgart.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月09日 16:35, Ulli Horlacher wrote:
> As I am writing some documentation abount creating snapshots:
> Is there a generic name for both volume and subvolume root?
> 
> Example:
> 
> root@fex:~# btrfs subvol show /mnt
> ERROR: not a subvolume: /mnt
> 
> root@fex:~# btrfs subvol show /mnt/test
> /mnt/test is toplevel subvolume
> 
> root@fex:~# btrfs subvol show /mnt/test/data
> /mnt/test/data
>          Name:                   data
>          UUID:                   b32a5949-dfd6-ef45-8616-34ae4cdf6fb8
> (...)
> 
> root@fex:~# btrfs subvol show /mnt/test/data/sw
> ERROR: not a subvolume: /mnt/test/data/sw
> 
> 
> I can create snapshots of /mnt/test and /mnt/test/data, but not of /mnt
> and /mnt/test/data/sw
> 
> Is there a simple name for directories I can snapshot?
> 
> 

Nope, subvolume (including snapshot) is not distinguished by its 
filename/path/directory name.

And you can only do snapshot on subvolume (snapshot is one kind of 
subvolume) boundary.

For user to determine where is the subvolume boundary, one should first 
determine there is the btrfs mounted and then use "btrfs subvol show" to 
determine the boundaries.

Or, in a btrfs test the directory inode number. Subvolume/snapshot in 
btrfs will always have the same inode number 256, and regular 
file/directories/special files will not use that magic number.

Thanks,
Qu
