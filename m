Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:50840 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752130Ab2JNPsb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Oct 2012 11:48:31 -0400
Message-ID: <507ADECB.8090309@zastrow4u.de>
Date: Sun, 14 Oct 2012 17:48:27 +0200
From: Alfred Zastrow <ml@zastrow4u.de>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: BTRFS filesystem is not mountable after crash
References: <k0ub0m$pvp$1@ger.gmane.org> <k1cc36$tj$1@ger.gmane.org> <5039BF90.7070509@oracle.com> <5079AA18.6010103@zastrow4u.de> <CAE5mzvg4j5w+-rrGXKZi+6fJrpPDvCbPdvbAKyJ=RtHTa9Vdag@mail.gmail.com>
In-Reply-To: <CAE5mzvg4j5w+-rrGXKZi+6fJrpPDvCbPdvbAKyJ=RtHTa9Vdag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 14.10.2012 00:56, schrieb cwillu:
> Chris's for-linus is currently all the btrfs changes that will be 
> going into 3.7. 3.6.1 won't likely have any of them.

Hi,

same thing, no success  :-(


I've checked out this tree:

git clone 
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git

The version show me "3.6.0+"

I took my  original Fedora Kernel-config to compile (btrfs as module)

[root@z2 alfred]# modinfo btrfs
filename:       /lib/modules/3.6.0+/kernel/fs/btrfs/btrfs.ko
license:        GPL
alias:          devname:btrfs-control
alias:          char-major-10-234
depends:        libcrc32c,zlib_deflate
intree:         Y
vermagic:       3.6.0+ SMP mod_unload


Result:
[  281.637120] Btrfs loaded
[  305.059449] device fsid 4d00f0e6-e9d7-42d9-8514-827d8f01f7d3 devid 1 
transid 192347 /dev/sdc1
[  305.060341] btrfs: enabling auto recovery
[  305.062283] btrfs: mismatching generation and generation_v2 found in 
root item. This root was probably mounted with an older kernel. 
Resetting all new fields.
[  305.062496] btrfs: mismatching generation and generation_v2 found in 
root item. This root was probably mounted with an older kernel. 
Resetting all new fields.
[  305.063114] btrfs: bdev /dev/sdc1 errs: wr 0, rd 0, flush 0, corrupt 
20, gen 0
[  305.107040] Btrfs detected SSD devices, enabling SSD mode
[  305.107497] btrfs bad tree block start 0 29450240
[  305.107557] btrfs bad tree block start 0 29450240


Do you have an other hint for me?

best regards
Alfred

