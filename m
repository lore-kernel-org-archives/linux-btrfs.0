Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:46102 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbaKJTIB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Nov 2014 14:08:01 -0500
Received: by mail-vc0-f176.google.com with SMTP id hq11so2259483vcb.35
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Nov 2014 11:08:00 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?=
	<mikhail.v.gavrilov@gmail.com>
Date: Tue, 11 Nov 2014 01:07:45 +0600
Message-ID: <CABXGCsMQMmPGa4sFGfeTUpiGeJUZ=6yN=J3Ueh4x-e3cwktc3A@mail.gmail.com>
Subject: btrfs check --repair couldn't solve problem with btrfs partition
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

Several times I try repair my btrfs partition with follow commands:
[root@localhost ~]# umount /home

root@localhost ~]# btrfs check --repair /dev/sdb1
enabling repair mode
Fixed 0 roots.
Checking filesystem on /dev/sdb1
UUID: 82df2d84-bf54-46cb-84ba-c88e93677948
checking extents
checking free space cache
cache and super generation don't match, space cache will be invalidated
checking fs roots
root 5 inode 14121739 errors 2000, link count wrong
unresolved ref dir 12843363 index 36917 namelen 11 name Preferences
filetype 0 errors 3, no dir item, no dir index
root 5 inode 14121759 errors 2000, link count wrong
unresolved ref dir 139955 index 340700 namelen 18 name
session_state.xspf filetype 0 errors 3, no dir item, no dir index
found 2897923331138 bytes used err is 1
total csum bytes: 3100962412
total tree bytes: 4638130176
total fs tree bytes: 950992896
total extent tree bytes: 142475264
btree space waste bytes: 608962027
file data blocks allocated: 33183423946752
 referenced 3177308782592

Btrfs v3.17


# rpm -q btrfs-progs
btrfs-progs-3.17-1.fc21.x86_64


And every time I see this messages.



--
Best Regards,
Mike Gavrilov.
