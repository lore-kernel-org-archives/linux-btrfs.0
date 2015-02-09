Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from asuka.romanrm.net ([128.199.122.184]:45283 "EHLO
	asuka.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933357AbbBIPnF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 9 Feb 2015 10:43:05 -0500
Date: Mon, 9 Feb 2015 20:42:56 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Devon B." <devon.b@virtualcomplete.com>, linux-btrfs@vger.kernel.org
Subject: Re: Accepting discard to free space from disk images
Message-ID: <20150209204256.51278106@natsu>
In-Reply-To: <54D8D1A9.1070006@virtualcomplete.com>
References: <54D842FD.1010806@virtualcomplete.com>
	<20150209114023.137402bf@natsu>
	<54D8D1A9.1070006@virtualcomplete.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 09 Feb 2015 10:26:33 -0500
"Devon B." <devon.b@virtualcomplete.com> wrote:

> If you don't mind me asking, what version kernel are you running and are 
> you using any special mount options?

Well actually I did not claim I have working discard through 'loop', but your
post made me curious.

$ sudo dd if=/dev/zero of=100g bs=1M seek=100000 count=1
1+0 records in
1+0 records out
1048576 bytes (1.0 MB) copied, 0.00221052 s, 474 MB/s

$ sudo mkfs.ext4 100g
[...]

$ du -hsc 100g 
133M	100g
133M	total

$ sudo mount -o loop 100g /mnt/tmp1/

(then in a new terminal window):
$ cd /mnt/tmp1/
$ df -h .
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0       96G   60M   92G   1% /mnt/tmp1
$ sudo dd if=/dev/zero of=zerofile bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 0.944377 s, 1.1 GB/s
$ sync

(back to the original one):
$ du -hsc 100g 
1.2G	100g
1.2G	total

(2nd window):
$ sudo fstrim .

(back to the original one):
$ du -hsc 100g 
133M	100g
133M	total

So it does work for me just fine even with 'loop'.
Kernel version 3.14.32, mount options
rw,noatime,nodiratime,compress=zlib,space_cache,inode_cache.

-- 
With respect,
Roman
