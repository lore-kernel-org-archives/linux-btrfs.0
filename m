Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv1.host37.de ([176.28.54.59]:50807 "EHLO srv1.host37.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753480AbbBEPY5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Feb 2015 10:24:57 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: Deadlock on 3.18.5
From: Juergen Fitschen <me@jue.yt>
In-Reply-To: <54D3667C.8070803@gmail.com>
Date: Thu, 5 Feb 2015 16:24:54 +0100
Message-Id: <1FF537B3-F790-428B-A82B-E6B8BA6E4B4E@jue.yt>
References: <2BFED81A-1A34-4A4B-800A-A4B6286B74C7@jue.yt> <C90D8017-3361-4B95-99E8-859958AF5D28@jue.yt> <54D3667C.8070803@gmail.com>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> On 05 Feb 2015, at 13:47, Austin S Hemmelgarn <ahferroin7@gmail.com> wrote:
> 
> I've actually seen similar behavior without the virtualization when doing large filesystem intensive operations with compression enabled.
> I don't know if this is significant, but it seems to be worse with lzo compression than zlib, and also seems to be worse when compression is enabled at the filesystem level instead of through 'chattr +c’.
Zlib isn’t that performant compared to lzo. So zlib creates a bottleneck at the CPU and thereby limits the IO the volume is exposed to. So our problem might be related to intensive operations on the volume.

> I'm not certain, but I think it might have something to do with the somewhat brain-dead default parameters in the default I/O scheduler (the so-called 'completely fair queue', which as I've said before was obviously named by a mathematician and not based on it's actual behavior), although it seems to be much worse when using the Deadline and no-op I/O schedulers.
Good idea. I had a look to my configuration of the “stack” for the block devices and their queuing and caching. My setup looks like this (with default settings - I made no adjustments):

* 2 HDDs
* Hewlett-Packard Company Smart Array Gen8 Controllers (rev 01)
  [With 1GB write cache. Other black magic seems to be included. Combines both HDDs to a RAID1]
* Block device driver
* IO Scheduler: deadline
* LVM
* QEMU
  [With writeback cache. Should I change it to “none"? The storage controller has write cache included.]
* virtio-blk
* btrfs

As you can see, only one IO scheduler is involved. The VM by default seems not to use any IO schedulers. I checked this by executing “cat /sys/block/vd*/queue/scheduler” on the VM and it reported “none”.


Regards,
  Juergen

