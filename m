Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:35455 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756461AbcCUPVq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 21 Mar 2016 11:21:46 -0400
Received: by mail-io0-f171.google.com with SMTP id o5so128804517iod.2
        for <linux-btrfs@vger.kernel.org>; Mon, 21 Mar 2016 08:21:46 -0700 (PDT)
Date: Mon, 21 Mar 2016 09:21:44 -0600
From: Tycho Andersen <tycho.andersen@canonical.com>
To: linux-btrfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: confusing mountinfo output when bind-mounting files
Message-ID: <20160321152144.GL8544@smitten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I'm seeing some strange behavior when bind mounting files from a btrfs
subvolume. Consider the output below:

root@criu2:/tmp# mount -o loop /tmp/tester.btrfs /tmp/dir1
root@criu2:/tmp# touch dir1/file
root@criu2:/tmp# sudo mount --bind dir1/file dir2/file
root@criu2:/tmp# grep "/tmp/dir" /proc/self/mountinfo 
128 24 0:45 / /tmp/dir1 rw,relatime shared:107 - btrfs /dev/loop0 rw,space_cache,subvolid=5,subvol=/
129 24 0:45 /file /tmp/dir2/file rw,relatime shared:107 - btrfs /dev/loop0 rw,space_cache,subvolid=5,subvol=/file
root@criu2:/tmp# btrfs --version
btrfs-progs v4.4
root@criu2:/tmp# uname -a
Linux criu2 4.4.0-8-generic #23-Ubuntu SMP Wed Feb 24 20:45:30 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

The issue here is that the "subvol=" mount option for the target of the bind
mount is "/file" when no such subvolume actually exists. Is this
intended? It's confusing to say the least, but seems like a bug to me.

Tycho
