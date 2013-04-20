Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:60398 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932082Ab3DTMlM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Apr 2013 08:41:12 -0400
Received: by mail-we0-f181.google.com with SMTP id r6so4503573wey.26
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Apr 2013 05:41:11 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8af6:5340:7df1:1b4f:d273:622b? ([2a01:e35:8af6:5340:7df1:1b4f:d273:622b])
        by mx.google.com with ESMTPSA id t14sm9190856wib.0.2013.04.20.05.41.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 20 Apr 2013 05:41:10 -0700 (PDT)
Message-ID: <51728CE3.9040804@gmail.com>
Date: Sat, 20 Apr 2013 14:41:07 +0200
From: Chris Hoffmann <chrmhoffmann@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: stale NFS file handle and corrupted btrfs
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have experienced an error message about stale NFS files when looking 
into a directory.

ls -la manpages-dev.md5sums
ls: cannot access manpages-dev.md5sums: Stale NFS file handle
root@c3po:/media/revo/@/var/lib/dpkg/info# rm manpages-dev.md5sums
rm: cannot remove ‘manpages-dev.md5sums’: Stale NFS file handle

Running btrfsck I see:

btrfsck --repair /dev/revo/root
enabling repair mode
checking extents
checking fs roots
root 256 inode 117209 errors 2001
	unresolved ref dir 11094 index 2862 namelen 20 name 
manpages-dev.md5sums filetype 1 error 4
root 319 inode 117209 errors 2001
	unresolved ref dir 11094 index 2862 namelen 20 name 
manpages-dev.md5sums filetype 1 error 4
root 320 inode 117209 errors 2001
	unresolved ref dir 11094 index 2862 namelen 20 name 
manpages-dev.md5sums filetype 1 error 4
found 28530659328 bytes used err is 0
total csum bytes: 27246928
total tree bytes: 629264384
total fs tree bytes: 552144896
btree space waste bytes: 160285807
file data blocks allocated: 57135325184
  referenced 28486983680
Btrfs v0.20-rc1

Scrubbing and btrfsck do not fix the issue.

I tried with 3.9.0rc6 and otherwise with 3.8.8 (and 3.8.0-19-generic 
#29-Ubuntu)

I have uploaded the btrfs-image to
http://ubuntuone.com/3tIHcUdfGEdmrSY1oxGCL3

The drive is an 64GB crucial M4 SSD. Smartinfo can be found here:
http://pastebin.com/raw.php?i=BJvcB31H

Any help appreciated.

Rgds,
Chris
