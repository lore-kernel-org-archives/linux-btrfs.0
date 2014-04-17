Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:61258 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaDQPjt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 17 Apr 2014 11:39:49 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so822460eek.32
        for <linux-btrfs@vger.kernel.org>; Thu, 17 Apr 2014 08:39:48 -0700 (PDT)
Received: from [192.168.178.21] (p549C5CB6.dip0.t-ipconnect.de. [84.156.92.182])
        by mx.google.com with ESMTPSA id o7sm68352178eew.25.2014.04.17.08.39.46
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 17 Apr 2014 08:39:47 -0700 (PDT)
Message-ID: <534FF5C1.8070404@gmail.com>
Date: Thu, 17 Apr 2014 17:39:45 +0200
From: "Oliver O." <oliver.o456i@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: File changing in snapshot
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I seem to have observed a file on a (writable) snapshot changing 
although there were no writes occuring on the snapshot itself. This is 
not supposed to happen, right?

Sequence of events:

1. A (writable) snapshot @home-2014-04-16 is taken on a @home subvolume 
mounted at /home.

2. The current subvolume (@home) is used (via /home) for continued write 
access, no writes are supposed to occur on the snapshot.

3. The snapshot @home-2014-04-16 is backed up (using rdiff-backup) to a 
different disk.

4. As the backup is compared to the snapshot @home-2014-04-16, one file 
differs.

Further analysis:

The file in @home-2014-04-16 changed its contents (but not mtime or 
other metadata) after being backup up from that snapshot. 5 bytes differ.

The previous snapshot @home-2014-04-10 contains the file in its original 
form, which is identical to the backup just taken from @home-2014-04-16.

The file change appears identically
- on the last snapshot @home-2014-04-16 and
- on the current subvolume used for writing (@home).

btrfs scrub reports 0 errors.

At the time the snapshot @home-2014-04-16 was taken, the file (an Excel 
file) was probably accessed through Samba, which supposedly uses kernel 
oplocks (if that makes a difference).

Versions:
- Kernel 3.11.0-19-generic (Ubuntu 13.10)
- btrfs-tools 0.19+20130705-1
- Samba 3.6.18

Any ideas?

