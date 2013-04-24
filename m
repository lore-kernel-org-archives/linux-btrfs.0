Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f54.google.com ([209.85.219.54]:43512 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab3DXMEj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 08:04:39 -0400
Received: by mail-oa0-f54.google.com with SMTP id l20so1556558oag.27
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 05:04:38 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Apr 2013 08:04:38 -0400
Message-ID: <CAD2cAXzECvNBNC_3gqLExiE4tnZ33VzDdP7v6O_mS0cOqNz8bg@mail.gmail.com>
Subject: Logical/i-nodes lookups give "path resolving failed with ret=-2"
From: Adrien Dessemond <adessemond@funtoo.org>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


I scrubbed a BTRFS volume (mounted as a VFS root) and got several
errors. However I am not able to make btrfs print the path of the
corrupted files...

E.g. kernel log gives :


[51078.682876] btrfs: unable to fixup (regular) error at logical
51241746432 on dev /dev/root
[51078.683013] btrfs: checksum error at logical 51242385408 on dev
/dev/root, sector 102196320, root 684, inode 60676040, offset
352583680: path resolving failed with ret=-2
[51078.683016] btrfs: bdev /dev/root errs: wr 0, rd 0, flush 0,
corrupt 35782, gen 0

Manual lookup  :

# btrfs  inspect-internal logical-resolve -v  51241746432 /
ioctl ret=0, bytes_left=4080, bytes_missing=0, cnt=0, missed=0
# ./btrfs  inspect-internal inode-resolve 60676040 /
ioctl ret=-1, error: No such file or directory

Kernel is Linux 3.9-rc8, latest btrfs-progs from Chris Mason's Git repository.

I am sure I am missing something but I am unable to figure out
what.... Any idea? Thanks!!

Adrien
