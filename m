Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39256 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753326Ab3ELQGZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 May 2013 12:06:25 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UbYn1-00084W-KR
	for linux-btrfs@vger.kernel.org; Sun, 12 May 2013 18:06:23 +0200
Received: from dyndsl-080-228-181-166.ewe-ip-backbone.de ([80.228.181.166])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 12 May 2013 18:06:23 +0200
Received: from hurikhan77+btrfs by dyndsl-080-228-181-166.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 12 May 2013 18:06:23 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Is my btrfs filesystem definitely dead?
Date: Sun, 12 May 2013 18:02:30 +0200
Message-ID: <h1r46a-vsn.ln1@hurikhan.ath.cx>
References: <kgbgvv$qvr$1@ger.gmane.org> <loom.20130512T115912-723@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ross <Ross.Richardson.aus@gmail.com> schrieb:

> Sébastien Luttringer <seblu <at> seblu.net> writes:
> 
>> 
>> Hello, after a crash with linux 3.8.0, I'm unable to
> mount my btrfs root
>> filesystem. I tried with a archlinux rescue cd with a
> linux 3.7.5, but I
>> got the following errors:
>> 
>> First trying to fix the fs:
>> 
>> # btrfsck
>> usage: btrfsck dev
>> Btrfs v0.20-rc1
>> # btrfsck /dev/sdd2
>> checking extents
>> checking fs roots
>> checking root refs
>> [1]    1051 segmentation fault (core dumped)  btrfsck
> /dev/sdd2
>> # dmesg|grep 1051
>> [  956.804097] btrfsck[1051]: segfault at 7f563c319410
> ip
>> 00007f56307c4c25 sp 00007ffffa7fbdf0 error 4 in
>> libc-2.17.so[7f563074a000+1a4000]
>> 
>> Trying to mount the FS i got a OOPS.
>> # mount /dev/sdd2 /new_root
>> [   60.602232] device label bitumefs devid 1 transid
> 40042 /dev/sdd2
>> [   60.603629] btrfs: disk space caching is enabled
>> [   60.615642] Btrfs detected SSD devices, enabling
> SSD mode
>> [   60.769651] ------------[ cut here ]------------
>> [   60.769709] kernel BUG at fs/btrfs/free-space-
> cache.c:1553!
[snip]

Tried to clear the space cache during mounting? There's a mount option for 
it but currently do not remember it.

HTH,
Kai

