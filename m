Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:42810 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab3FQVVg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 17:21:36 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 8B70E9A069C
	for <linux-btrfs@vger.kernel.org>; Mon, 17 Jun 2013 15:21:35 -0600 (MDT)
Date: Mon, 17 Jun 2013 17:21:32 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Filesystem "somewhat" destroyed - need help for recovery/fixing
Message-ID: <20130617212132.GA19183@localhost.localdomain>
References: <loom.20130617T230152-537@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <loom.20130617T230152-537@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 17, 2013 at 09:08:26PM +0000, Alexander Skwar wrote:
> Hello
> 
> I think, I somewhat destroyed my btrfs filesystem on my Ubuntu 13.04 kernel 
> 3.8.0-25-lowlatency system. It got destroyed, because the system was hanging 
> for some other reason and I had to remove power...
> 
> When I try to mount my filesystem (there's only one, with a few 
> subfilesystems), the system crashes. Also btrfsck dies; always like this:
> 
> a@ask-home:~$ sudo /btrfs-progs.dev/bin/btrfsck /dev/ssd/Data 
> parent transid verify failed on 33327525888 wanted 53973 found 53972
> parent transid verify failed on 33327525888 wanted 53973 found 53972
> Ignoring transid failure
> Checking filesystem on /dev/ssd/Data
> UUID: 7d2eb10f-aced-4d41-bb7f-7badbf075b6a
> checking extents
> checking fs roots
> root 325 inode 31590 errors 400
> extent buffer leak: start 33327525888 len 4096
> *** Error in `btrfs check': corrupted double-linked list: 0x00000000007a2600 
> ***
> 
> a@ask-home:~$ /btrfs-progs.dev/bin/btrfs version
> Btrfs v0.20-rc1-253-g7854c8b-dirty
> 
> btrfsck always dies with a corrupted double-linked list.
> 
> When the system crashes when I try to mount the filesystem, I get a kernel 
> oop. Nothing in syslog, though - too fast :/ On 
> http://wir.myds.me/photo/photo_thumb.php?
> dir=53637265656e73686f74732f4372617368206d6f756e74206274726673 or 
> http://imgur.com/a/UA7fF I tried to capute a few photos of the crash 
> message. "Screenshots", of sorts...
> 
> I was able to recover most of the files with btrfs-recover. But not all of 
> it correctly - at least one VirtualBox image is now broken.
> 
> Well - what do I do now? Could someone help, please?
> 

Pull down my tree

git://github.com/josefbacik/btrfs-progs.git

and build and run the fsck in there and see if it's a bit more friendly.
Thanks,

Josef
