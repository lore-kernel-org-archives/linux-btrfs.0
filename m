Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:44577 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbaD0Uko (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Apr 2014 16:40:44 -0400
Message-ID: <535D5B4E.3010508@arcor.de>
Date: Sun, 27 Apr 2014 21:32:30 +0200
From: Martin Wilck <mwilck@arcor.de>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Lost /home subvolume after btrfs crash
References: <534E8B6A.9060209@arcor.de> <7C3AD7C7-44A4-45F3-9634-3E92618DCD15@colorremedies.com> <53580794.3050001@arcor.de> <0B414713-868B-4BA0-8BDF-D731B8E44F5F@colorremedies.com>
In-Reply-To: <0B414713-868B-4BA0-8BDF-D731B8E44F5F@colorremedies.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/24/2014 05:15 AM, Chris Murphy wrote:

>>> Current stable is 3.14.1, I suggest giving 3.13 or 3.14 a shot at this with -o ro,recovery as a first step and see if it at least mounts.
>>
>> I will. Note that with 12.3, which was the most recent media I had at
>> hand at the time, the FS was actually mountable at first (-o
>> ro,recovery). But there was no /home and later attempts to actually
>> access data in other subvolumes failed with the messages in my debug
>> material.
> 
> I'd skip 3.13 and go straight to 3.14.1 or 3.15rc2, and use mount option -o ro,recovery straight away and see if you can extract all of /home.

I tried mount -o ro,recovery with 3.14.1 (3.14.1-vanilla from OpenSUSE
tumbleweed), but results weren't better than before. The kernel choked
on the FS. The attempt to mount the broken FS with -o ro,recovery ended
with a kernel Oops:

BTRFS error (device dm-18): unable to find ref byte nr 980791296 parent
0 root 2  owner 0 offset 0
BUG: unable to handle kernel paging request at ff000000
IP: [<c0324cab>] page_address+0xb/0xd0
[<f926deef>] btrfs_del_items+0xdf/0x390
[<f9275636>] __btrfs_free_extent+0x796/0xb30
[<f927a81c>] __btrfs_run_delayed_refs+0x8dc/0x10e0
[<f9276c21>] ? btrfs_delayed_refs_qgroup_accounting+0xa1/0xe0
[<f927ec96>] btrfs_run_delayed_refs.part.56+0x56/0x1f0
[<f92a963f>] ? btrfs_run_ordered_operations+0x19f/0x220
[<f927ee3f>] btrfs_run_delayed_refs+0xf/0x20
[<f928e0cc>] btrfs_commit_transaction+0x3c/0xbf0
...

After that, the system was basically dead, all IO would be blocked by
some deadlock in btrfs.

Full kernel log again under
https://www.dropbox.com/sh/utv8b3qd0do6a04/zTwGQCrN9x.

> You could then try btrfs-progs v3.14's btrfs restore to extract
> /home. 

btrfs restore from btrfs-progs 3.14.1 definitely looked more promising
than the version I tried previously. However, /home is still empty.

> If that doesn't work then I'd give up on this instance of the
> file system as it sounds damaged by something possibly even the
> btrfsck --repair.

I made the block-level copy before trying any write operation (IOW,
before copying, I tried only btrfs-restore and mount -ro,recovery).
So it should be a 1:1 copy of the broken FS.

I can't easily give up this data,

> I wouldn't use --repair until a dev recommends it (even with btrfs-progs v3.14 let alone the I'm guessing v0.19 or v0.20 you were using); or once all other reasonable options are exhausted.

Well it seems as if all "reasonable" options are indeed exhausted :-(
Still looking for ideas to recover the contents of /home.

Would it make sens to try to check out previous generations of the root
tree with btrfs recover?

Regards
Martin

> 
> 
> Chris Murphy

