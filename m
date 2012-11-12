Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57824 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab2KLNj4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 12 Nov 2012 08:39:56 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TXuFA-0008Ge-9f
	for linux-btrfs@vger.kernel.org; Mon, 12 Nov 2012 14:40:04 +0100
Received: from 83.244.169.150 ([83.244.169.150])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2012 14:40:04 +0100
Received: from smith_it2000 by 83.244.169.150 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Nov 2012 14:40:04 +0100
To: linux-btrfs@vger.kernel.org
From: Sem <smith_it2000@yahoo.com>
Subject: Btrfsck repair, strange df numbers and cannot write
Date: Mon, 12 Nov 2012 13:34:09 +0000 (UTC)
Message-ID: <loom.20121112T142903-705@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

After doing a btrfsck --repair on my file system, it now has very strange
numbers in df:

[root ~]# df -h | grep sdc
/dev/sdc         15T  -64Z   16E 101% /usr/data

Prior to this it was 81% used.

I can read the files, but i cannot write a file.

Does anyone have a clue as to what is going on?

Any idea how to fix?

Thanks.

---

Details:

[root ~]# uname -a
Linux t1.localdomain 3.6.6-1.fc16.x86_64 #1 SMP Mon Nov 5 16:56:43 UTC 2012
x86_64 x86_64 x86_64 GNU/Linux

[root ~]# btrfs --version
Btrfs v0.20-rc1-37-g91d9eec


