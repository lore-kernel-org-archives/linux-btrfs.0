Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37976 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbcAWXs1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 18:48:27 -0500
Received: by mail-ig0-f180.google.com with SMTP id mw1so12459987igb.1
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jan 2016 15:48:26 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 23 Jan 2016 16:48:26 -0700
Message-ID: <CAJCQCtRyyu3rdyyykEjf8neLh3R+12to_gcCpU2ss51dU-_7PA@mail.gmail.com>
Subject: [bug] btrfs send -e option always fails ERROR: unexpected EOF in stream.
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=111221

4.4.0-1.fc24.x86_64
btrfs-progs-4.3.1-1.fc23.x86_64



[...snip...]
BTRFS_IOC_SEND returned 0
joining genl thread
At subvol testsub.1
ERROR: parent determination failed for 0
chown temp/cockpit-shell-0.91-1.fc23.noarch.rpm - uid=0, gid=0
chmod temp/cockpit-shell-0.91-1.fc23.noarch.rpm - mode=0644
utimes temp/cockpit-shell-0.91-1.fc23.noarch.rpm
mkfile o270-134474-0
rename o270-134474-0 -> temp/cockpit-networkmanager-0.91-1.fc23.noarch.rpm
utimes temp
set_xattr temp/cockpit-networkmanager-0.91-1.fc23.noarch.rpm -
name=security.selinux data_len=38
data=unconfined_u:object_r:admin_home_t:s0
truncate temp/cockpit-networkmanager-0.91-1.fc23.noarch.rpm size=37322
chown temp/cockpit-networkmanager-0.91-1.fc23.noarch.rpm - uid=0, gid=0
chmod temp/cockpit-networkmanager-0.91-1.fc23.noarch.rpm - mode=0644
utimes temp/cockpit-networkmanager-0.91-1.fc23.noarch.rpm
ERROR: unexpected EOF in stream.

The same ERROR messages happens even if I use -p to specify the parent.

Sending conventionally one at a time with -p works OK.


-- 
Chris Murphy
