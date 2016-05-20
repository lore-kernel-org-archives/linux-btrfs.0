Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from st11p09im-asmtp001.me.com ([17.164.24.103]:37176 "EHLO
	st11p09im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbcETSkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 May 2016 14:40:16 -0400
Received: from process-dkim-sign-daemon.st11p09im-asmtp001.me.com by
 st11p09im-asmtp001.me.com
 (Oracle Communications Messaging Server 7.0.5.36.0 64bit (built Sep  8 2015))
 id <0O7H01A00KMQH300@st11p09im-asmtp001.me.com> for
 linux-btrfs@vger.kernel.org; Fri, 20 May 2016 17:39:00 +0000 (GMT)
Received: from [192.168.0.108]
 (aftr-37-201-192-190.unity-media.net [37.201.192.190])
 by st11p09im-asmtp001.me.com
 (Oracle Communications Messaging Server 7.0.5.36.0 64bit (built Sep  8 2015))
 with ESMTPSA id <0O7H01ATDL0WF200@st11p09im-asmtp001.me.com> for
 linux-btrfs@vger.kernel.org; Fri, 20 May 2016 17:38:58 +0000 (GMT)
From: Wolf Bublitz <wolf.bublitz@me.com>
Content-type: text/plain; charset=utf-8
Subject: btrfs restore fails because of NO SPACE
Message-id: <6BBAAABC-616F-48A6-BDF2-70B23B8E0D72@me.com>
Date: Fri, 20 May 2016 19:38:55 +0200
To: linux-btrfs@vger.kernel.org
MIME-version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

I have a confusing problem with my btrfs raid. Currently I am using the following setup:

btrfs fi show
Label: none  uuid: 93000933-e46d-403b-80d7-60475855e3f3
	Total devices 2 FS bytes used 2.56TiB
	devid    1 size 2.73TiB used 2.71TiB path /dev/sda
	devid    4 size 2.73TiB used 2.71TiB path /dev/sdb

As you can see both disks are full.

Actually I cannot mount my raid, even with recovery options enabled:

mount /dev/sda /mnt/Data -t btrfs -onospace_cache,clear_cache,enospc_debug,nodatacow
mount: wrong fs type, bad option, bad superblock on /dev/sda,
       missing codepage or helper program, or other error

       In some cases useful info is found in syslog - try
       dmesg | tail or so.

dmesg shows:

[ 1066.221696] BTRFS info (device sda): disabling disk space caching
[ 1066.227990] BTRFS info (device sda): force clearing of disk cache
[ 1066.234331] BTRFS info (device sda): setting nodatacow, compression disabled
[ 1066.243813] BTRFS error (device sda): parent transid verify failed on 9676657786880 wanted 242139 found 0
[ 1066.253672] BTRFS error (device sda): parent transid verify failed on 9676657786880 wanted 242139 found 0
[ 1066.263450] BTRFS error (device sda): parent transid verify failed on 9676657786880 wanted 242139 found 0
[ 1066.273234] BTRFS: failed to read chunk root on sda
[ 1066.279675] BTRFS warning (device sda): page private not zero on page 9676657786880
[ 1066.287482] BTRFS warning (device sda): page private not zero on page 9676657790976
[ 1066.295361] BTRFS warning (device sda): page private not zero on page 9676657795072
[ 1066.303204] BTRFS warning (device sda): page private not zero on page 9676657799168
[ 1066.369266] BTRFS: open_ctree failed

After spending some time with Google I found a possible solution for my problem by running:

btrfs restore -v /dev/sda /mnt/Data

Actually this operation fails silently (computer freezes). After examine the kernel logs I have found out that the operations fails because of „NO SPACE LEFT ON DEVICE“. Can anybody please give me a solution for this problem?

Greetings

Wolf Bublitz