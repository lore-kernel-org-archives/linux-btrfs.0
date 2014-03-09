Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:60103 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbaCIHsX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 9 Mar 2014 03:48:23 -0400
Received: by mail-ea0-f176.google.com with SMTP id o10so3093176eaj.7
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Mar 2014 23:48:22 -0800 (PST)
Received: from [192.168.7.7] (a207.net131.okay.pl. [85.28.131.207])
        by mx.google.com with ESMTPSA id l42sm29047848eew.19.2014.03.08.23.48.21
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sat, 08 Mar 2014 23:48:21 -0800 (PST)
Message-ID: <531C1CC4.701@gmail.com>
Date: Sun, 09 Mar 2014 08:48:20 +0100
From: KC <impactoria@googlemail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Massive BTRFS performance degradation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am experiencing massive performance degradation on my BTRFS root 
partition on SSD. Except for regular daily updates, nothing changed in 
the system. The mount point remained the same:

/  btrfs rw,noatime,compress=lzo,ssd,space_cache,autodefrag 0 0

but the performance dropped to less than 8% of norm.


Before:

# dd if=tempfile of=/dev/null bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 1.57307 s, 683 MB/s

Now:

# dd if=tempfile of=/dev/null bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 26.4373 s, 40.6 MB/s


I created a new btrfs partition on the SSD with the same mount options 
and it is not being affected:

# dd if=/mnt/er/tempfile of=/dev/null bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB) copied, 1.57634 s, 681 MB/s


I also did
btrfs filesystem balance start /
wit no effect.

I tried changing mount options - still no effect.

I'd appreciate some suggestions.
