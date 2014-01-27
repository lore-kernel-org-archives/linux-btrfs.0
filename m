Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:48634 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbaA0JOG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jan 2014 04:14:06 -0500
Received: by mail-ee0-f41.google.com with SMTP id e49so2129698eek.28
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Jan 2014 01:14:05 -0800 (PST)
Received: from [192.168.0.29] (ppp-2-85-89-247.home.otenet.gr. [2.85.89.247])
        by mx.google.com with ESMTPSA id b41sm39875612eef.16.2014.01.27.01.14.03
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Jan 2014 01:14:04 -0800 (PST)
Message-ID: <52E62358.8030406@gmail.com>
Date: Mon, 27 Jan 2014 11:14:00 +0200
From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Btrfs send 4-5 times slower than rsync on local
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, i am using btrfs send to copy a snapshot to another btrfs 
filesystem on the same machine, and it has a maximum speed of 
30-35MByte/sec.
Incredibly rsync is much faster, at 120-140MB/sec. Source btrfs is a 
5x2TB raid 0 and target is 1x4TB.

mount options: rw,noatime,compress-force=zlib,space_cache
kernel is linux-3.13.0-rc6-git and btrfs tools is built from git at 
about the same time linux-3.13.0-rc6 was released

Finally, is there a way to resume an interrupted send?

