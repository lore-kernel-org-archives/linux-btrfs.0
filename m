Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f48.google.com ([209.85.214.48]:39524 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3LCL2t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Dec 2013 06:28:49 -0500
Received: by mail-bk0-f48.google.com with SMTP id v10so5901554bkz.21
        for <linux-btrfs@vger.kernel.org>; Tue, 03 Dec 2013 03:28:48 -0800 (PST)
Received: from linux-suse.hu (BC06518D.dsl.pool.telekom.hu. [188.6.81.141])
        by mx.google.com with ESMTPSA id o5sm25824752bkz.4.2013.12.03.03.28.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Dec 2013 03:28:46 -0800 (PST)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: btrfs-ino-cache runs on every boot for 6 minutes
Date: Tue, 03 Dec 2013 12:28:26 +0100
Message-ID: <1531404.tFNCiHaLVH@linux-suse.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear list members,

I'm not sure if this a bug or an intended behaviour, since I've yet to find a 
reliable source with Google search.

My problem is the following: with the 3.12 kernel on every single boot (even 
when the computer was shut down clear) the process [btrfs-ino-cache] is 
preventing the successful startup of X because it's running for 6 minutes.

I can see this in "iotop" and while that program runs the whole system is 
being blocked. After 6 minutes I restart X and everyting goes normal from that 
point on.

My question is: is that necessary to regenerate the inode cache on every boot 
or is this a bug? Of course if I remove the "inode_cache" option from fstab, 
this phenomenon disappears.

Versions:
- OS: openSUSE 13.1
- Kernel: 3.12.0-6.ge7c00d8-desktop #1 SMP PREEMPT Tue Nov 12 13:09:24 UTC 
2013 (e7c00d8)
- Mount options: compress=lzo,space_cache,inode_cache,noatime

Best regards,

Ákos
