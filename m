Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:65070 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab3LPXUj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 18:20:39 -0500
Received: by mail-ob0-f178.google.com with SMTP id uz6so5545728obc.23
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Dec 2013 15:20:38 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 17 Dec 2013 00:20:38 +0100
Message-ID: <CAO5znau9bYtjLmcwSE9uD7tRo0uY_CLHhLNCoYW7cpRLJtve-g@mail.gmail.com>
Subject: Understanding subvolume hierarchy
From: Nicolas Michel <be.nicolas.michel@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello guys,

I'm just using btrfs for the first time. I tried to create subvolumes
before installing Ubuntu but the installer doesn't give the
opportunity to configure as we want. So it creates by default 2
subvolumes : @ for the root and @home for the home directories.

So now, I wanted to delete the old subvolumes I created. I ran into
problems: the Ubuntu installer set the default subvolume to @ (id=5).
So when I try to delete my previous subvolumes it tells me it doesn't
find it ... Here are some output to be more concrete:

root@my-tour:~# btrfs subv get-default /
ID 5 (FS_TREE)
root@my-tour:~# btrfs subv list /
ID 258 gen 6 top level 5 path home
ID 259 gen 7 top level 5 path tmp
ID 260 gen 8 top level 5 path home-root
ID 261 gen 9 top level 5 path logs
ID 262 gen 138 top level 5 path @
ID 263 gen 139 top level 5 path @home
root@my-tour:~# btrfs subv del tmp
ERROR: error accessing 'tmp'

The only way I found to circumvent the problem was to mount the root
volume (id=0) on /mnt with "-o subvolid=0" and then from there I'm
able to delete anything.

My questions are :
- can I directly delete a subvolume with its ID? (so I don't have to
mount the id 0 to do it)
- or is there a way to specify the path starting not from the default
volume but forcing to start from id 0? Something like "btrfs subv del
0/tmp" (I tried, it doesn't work ;)

Thank you,


-- 
Nicolas MICHEL
