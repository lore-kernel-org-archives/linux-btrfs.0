Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:58939 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab3DFHc6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2013 03:32:58 -0400
Message-ID: <515FCE82.1030309@gmx.net>
Date: Sat, 06 Apr 2013 09:28:02 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Koen De Wit <koen.de.wit@oracle.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [BUG?] Btrfs quota: overwritten space is counted twice
References: <515F3C0A.8080603@oracle.com>
In-Reply-To: <515F3C0A.8080603@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/05/13 23:03, Koen De Wit wrote:
> When data in a file is overwritten, starting somewhere in the middle of
> the file, the overwritten space is counted twice against the space usage
> numbers. Is this a bug, or did I something wrong?

Neither. This is a result of how btrfs allocates and overwrites extents.
Your file is firstly allocated in one extent of 1000kB. When you
overwrite parts of it, the original extent is kept, and a new extent for
the overwritten part is allocated, resulting in another allocation of
1000kB. Once you overwrite the first 100kB (the part that is still in
use from the first extent), it should be freed.
So your file really allocates 2000kB on disk, and qgroups accounts
it correctly. You can verify it with btrfs-debug-tree.

-Arne

> 
> This is what I did:
> 
> I create a subvolume and limit it to 4 MB, and create a 1000 KB file in
> the subvol:
> 
>     # btrfs subvol create s
>       Create subvolume './s'
>     # btrfs qgroup limit 4m s
>     # btrfs qgroup show ./ | grep 260
>       0/260 4096 4096
>     # dd if=/dev/zero of=s/file bs=1024 count=1000; sync
>     # ls -lah s/file
>       -rw-r--r--. 1 root root 1000K Apr  6 00:13 s/file
>     # btrfs qgroup show ./ | grep 260
>       0/260 1028096 1028096
> 
> Then I overwrite the last 900 KB of the file, and add 100 KB of data,
> resulting in a 1.1 MB file. The space usage numbers shows 2 MB however:
> 
>     # dd if=/dev/zero of=s/file bs=1024 count=1000 seek=100; sync
>     # ls -lah s/file
>       -rw-r--r--. 1 root root 1.1M Apr  6 00:13 s/file
>     # btrfs qgroup show ./ | grep 260
>       0/260 2052096 2052096
> 
> I repeat this twice, the file becomes 1.3 MB but the usage number goes
> to almost 4 MB:
> 
>     # dd if=/dev/zero of=s/file bs=1024 count=1000 seek=200; sync
>     # dd if=/dev/zero of=s/file bs=1024 count=1000 seek=300; sync
>     # ls -lah s/file
>       -rw-r--r--. 1 root root 1.3M Apr  6 00:14 s/file
>     # btrfs qgroup show ./ | grep 260
>       0/260 4100096 4100096
> 
> Doing the same again results in "quota exceeded" errors:
> 
>     # dd if=/dev/zero of=s/file bs=1024 count=1000 seek=400; sync
>       dd: writing `s/file': Disk quota exceeded
>       78+0 records in
>       77+0 records out
>       78848 bytes (79 kB) copied, 0.00138135 s, 57.1 MB/s
>     # ls -lah s/file
>       -rw-r--r--. 1 root root 477K Apr  6 00:15 s/file
>     # btrfs qgroup show ./ | grep 260
>       0/260 4182016 4182016
>     # touch s/emptyfile
>       touch: cannot touch `s/emptyfile': Disk quota exceeded
> 
> Koen.
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

