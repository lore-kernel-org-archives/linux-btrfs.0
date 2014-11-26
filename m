Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54002 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaKZBge (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 20:36:34 -0500
Received: by mail-pd0-f181.google.com with SMTP id z10so1722293pdj.12
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 17:36:34 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: [PATCH v2] Btrfs: deal with all 'subvol=xxx' options once
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20141125173646.GL26471@twin.jikos.cz>
Date: Wed, 26 Nov 2014 09:36:24 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <70E281AF-F94A-404D-B4D4-16487822D9A7@gmail.com>
References: <1416903611-29812-1-git-send-email-wangshilong1991@gmail.com> <20141125173646.GL26471@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> 
> On Tue, Nov 25, 2014 at 04:20:11PM +0800, Wang Shilong wrote:
>> Steps to reproduce:
>> # mkfs.btrfs -f /dev/sdb
>> # mount -t btrfs /dev/sdb /mnt
>> # btrfs sub create /mnt/dir
>> # mount -t btrfs /dev/sdb /mnt -o subvol=dir,subvol=dir
>> 
>> It fails with:
>> mount: mount(2) failed: No such file or directory
> 
> The bug is real, but I don't like the fix. The mount path is hard to
> read already, and I'm afraid your fix adds another unobvious step to the
> whole processing.
> 
> setup_root_args replaces subvol= with subvolid=0 once. I suggest to
> replace all occurences of subvol= here and not rely on the recursive
> behaviour of the mount callbacks.

ok, if you like this way, i will do it.


> 
> The (buggy) way how it works now is that the first occurence of subvol
> will get parsed and passed as
> 
> newroot = vfs_kern_mount(",subvol=second,...,subvolid=0")
> 
> and this will call back again to btrfs_mount and will try to mount the
> subvol 'second' but now relative to 'newroot'.
> 
> Try this:
> 
> # mkfs.btrfs -f /dev/sdb
> # mount -t btrfs /dev/sdb /mnt
> # btrfs sub create /mnt/dir
> # btrfs sub create /mnt/dir/dir2
> # mount -t btrfs /dev/sdb /mnt -o subvol=dir,subvol=dir2
> 
> mount succeeds and the mounted subvolume is dir2.

Best Regards,
Wang Shilong

