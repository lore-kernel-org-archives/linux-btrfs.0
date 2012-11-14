Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61621 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422887Ab2KNS0O (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Nov 2012 13:26:14 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so769750oag.19
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Nov 2012 10:26:13 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 14 Nov 2012 13:26:13 -0500
Message-ID: <CALJXSJosaiU+pGHaUhh9OokdgOpPgDf385x2Q9BH7qhVKnZowg@mail.gmail.com>
Subject: Cannot list subvolumes with latest git
From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Using Debian experimental kernel, 3.6.4-1~experimental.1, and latest
btrfs tools from git master, I am not able to execute btrfs subvolume
list.

# ./btrfs sub li /mnt/data0/
ERROR: Failed to lookup path for root 0 - No such file or directory

After bisecting with git, I was able to confirm that commit
162df1e30c7c0492ae9fb551d74452e643f5fea2 breaks btrfs subvolume list
on my current kernel.
