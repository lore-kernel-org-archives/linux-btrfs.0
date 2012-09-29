Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62237 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab2I2W0l (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Sep 2012 18:26:41 -0400
Received: by weyt9 with SMTP id t9so2154007wey.19
        for <linux-btrfs@vger.kernel.org>; Sat, 29 Sep 2012 15:26:39 -0700 (PDT)
Message-ID: <5067759C.4090302@statystyka.net>
Date: Sun, 30 Sep 2012 00:26:36 +0200
From: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Btrfsck: "root 256 inode 581419 errors 100". Can I heal this file
 system?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Welcome.

I was using this btrfs file system on kernel 3.6 rc4 and rc5 and 3.5.4 
on Mint 13 (which is based on Ubuntu 12.04). Now, I found the following 
output of btrfsck /dev/sda8 (which was of course off-line at that time):
> checking extents
> checking fs roots
> root 256 inode 581419 errors 100
> found 97398079488 bytes used err is 1
> total csum bytes: 94539548
> total tree bytes: 589582336
> total fs tree bytes: 412663808
> btree space waste bytes: 128744572
> file data blocks allocated: 870320693248
>  referenced 102221803520
> Btrfs Btrfs v0.19
I understand, that the line "root 256 inode 581419 errors 100" tries to 
tell me, that there is a problem with inode 581419. (Which happen to be 
mountpoint/@/var/cache/hald/fdi-cache; I use btrfs as a root file system 
for Linux mint 13). I pulled the recent btrfs-tools from Ubuntu 12.10 
(https://launchpad.net/ubuntu/quantal/+package/btrfs-tools; version 
0.19+20120328-7ubuntu1 
<https://launchpad.net/ubuntu/quantal/+source/btrfs-tools/0.19+20120328-7ubuntu1>). 
The btrfsck doesn't make the error disapear. I don't experience any 
problems with the file system, but maybe I am only lucky.

What exactly does this error mean?

Is there any way to heal the file system?

I can read the file just fine. But I can't confirm if the contents are 
valid though; they definitely don't look random. Would deleting the file 
help? Or re-writing it?

Is there any way of recovering from this error, or should I rebuild the 
file system from scratch?

I will gladly assist you with providing any debugging information you 
need. Just give me clear instructions, what to do. The file system is 
not in production.

Adam Ryczkowski

