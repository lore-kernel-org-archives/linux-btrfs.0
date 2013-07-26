Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62217 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754465Ab3GZUbS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Jul 2013 16:31:18 -0400
Received: by mail-wi0-f181.google.com with SMTP id en1so1214785wid.2
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Jul 2013 13:31:17 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 26 Jul 2013 16:31:17 -0400
Message-ID: <CAPs0BijizOo0c566U6-uAe1voCr-W2SVHkMeT1sirTfi4jgeSg@mail.gmail.com>
Subject: Recovery advice
From: Sandy McArthur <sandymac@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I have a 4 disk RAID1 setup that fails to {mount,btrfsck} when disk 4
is connected.

With disk 4 attached btrfsck errors with:
btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion
`!(path->slots[0] == 0)' failed
(I'd have to reboot in a non-functioning state to get the full output.)

I can mount the filesystem in a degraded state with the 4th drive
removed. I believe there is some data corruption as I see lines in
/var/log/messages from the degraded,ro filesystem like this:

BTRFS info (device sdd1): csum failed ino 4433 off 3254538240 csum
1033749897 private 2248083221

I'm at the point where all I can think to do is wipe disk 4 and then
add it back in. Is there anything else I should try first. I have
booted btrfs-next with the latest btrfs-progs.

Thanks.
--
Sandy McArthur

"He who dares not offend cannot be honest."
- Thomas Paine
