Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40572 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab3FQVIs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 17:08:48 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UogfK-0004sM-3a
	for linux-btrfs@vger.kernel.org; Mon, 17 Jun 2013 23:08:46 +0200
Received: from 84-72-179-110.dclient.hispeed.ch ([84.72.179.110])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 23:08:42 +0200
Received: from alexanders.mailinglists+nospam by 84-72-179-110.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 23:08:42 +0200
To: linux-btrfs@vger.kernel.org
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Subject: Filesystem "somewhat" destroyed - need help for recovery/fixing
Date: Mon, 17 Jun 2013 21:08:26 +0000 (UTC)
Message-ID: <loom.20130617T230152-537@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello

I think, I somewhat destroyed my btrfs filesystem on my Ubuntu 13.04 kernel 
3.8.0-25-lowlatency system. It got destroyed, because the system was hanging 
for some other reason and I had to remove power...

When I try to mount my filesystem (there's only one, with a few 
subfilesystems), the system crashes. Also btrfsck dies; always like this:

a@ask-home:~$ sudo /btrfs-progs.dev/bin/btrfsck /dev/ssd/Data 
parent transid verify failed on 33327525888 wanted 53973 found 53972
parent transid verify failed on 33327525888 wanted 53973 found 53972
Ignoring transid failure
Checking filesystem on /dev/ssd/Data
UUID: 7d2eb10f-aced-4d41-bb7f-7badbf075b6a
checking extents
checking fs roots
root 325 inode 31590 errors 400
extent buffer leak: start 33327525888 len 4096
*** Error in `btrfs check': corrupted double-linked list: 0x00000000007a2600 
***

a@ask-home:~$ /btrfs-progs.dev/bin/btrfs version
Btrfs v0.20-rc1-253-g7854c8b-dirty

btrfsck always dies with a corrupted double-linked list.

When the system crashes when I try to mount the filesystem, I get a kernel 
oop. Nothing in syslog, though - too fast :/ On 
http://wir.myds.me/photo/photo_thumb.php?
dir=53637265656e73686f74732f4372617368206d6f756e74206274726673 or 
http://imgur.com/a/UA7fF I tried to capute a few photos of the crash 
message. "Screenshots", of sorts...

I was able to recover most of the files with btrfs-recover. But not all of 
it correctly - at least one VirtualBox image is now broken.

Well - what do I do now? Could someone help, please?


Thanks a lot,
Alexander

