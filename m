Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42739 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757659Ab3DDAVc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 3 Apr 2013 20:21:32 -0400
Received: from m3.gw.fujitsu.co.jp (unknown [10.0.50.73])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id 0FDBD3EE0AE
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2013 09:21:31 +0900 (JST)
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id EC29745DEB5
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2013 09:21:30 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id D7A1F45DEB6
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2013 09:21:30 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id CC2231DB8040
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2013 09:21:30 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 81C68E08001
	for <linux-btrfs@vger.kernel.org>; Thu,  4 Apr 2013 09:21:30 +0900 (JST)
Message-ID: <515CC77D.9040502@jp.fujitsu.com>
Date: Thu, 04 Apr 2013 09:21:17 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Chris Mason <chris.mason@fusionio.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: (3.9-rc5) WARNING: at fs/btrfs/super.c:255 __btrfs_abort_transaction
References: <515B838A.7020000@jp.fujitsu.com> <20130403130541.27335.23925@localhost.localdomain>
In-Reply-To: <20130403130541.27335.23925@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/04/03 22:05, Chris Mason wrote:
> Quoting Tsutomu Itoh (2013-04-02 21:19:06)
>> Hi,
>>
>> When inode_cache was specified for the mount option, I encountered the
>> following messages at umount.
>>
>> Step to reproduce:
>>
>>   mkfs.btrfs -f /dev/sdc4
>>   mount -o compress=lzo,autodefrag,inode_cache /dev/sdc4 /test1
>>   dd if=/dev/zero of=/test1/file1 bs=1M count=8192
>>   dd if=/test1/file1 of=/dev/null bs=1M
>>   rm -f /test1/file1
>>   umount /test1
>> Apr  3 09:43:12 luna kernel: [  554.639149] BTRFS error (device sdc4) in btrfs_save_ino_cache:471: error 28
>
> We're running out of space while saving the inode cache.  Strictly
> speaking this should not abort the FS.  I'll take a look.

Umm, 8GB was only written in the filesystem of 20GB...

When only inode_cache was specified for the mount option
('mount -o inode_cache /dev/sdc4 /test1'), the error message was not output.
Is this information useful for any investigations?

Thanks,
Tsutomu


