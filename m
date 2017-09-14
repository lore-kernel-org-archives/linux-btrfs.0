Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp01.belwue.de ([129.143.71.86]:48014 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751738AbdINO5l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 10:57:41 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 4AEA88C93
        for <linux-btrfs@vger.kernel.org>; Thu, 14 Sep 2017 16:57:39 +0200 (MEST)
Date: Thu, 14 Sep 2017 16:57:39 +0200
From: Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To: linux-btrfs@vger.kernel.org
Subject: snapshots of encrypted directories?
Message-ID: <20170914145739.GA32347@rus.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I use encfs on top of btrfs.
I can create btrfs snapshots, but I have no suggestive access to the files
in these snaspshots, because they look like:

drwx------  framstag users        - 2017-09-08 11:47:18 uHjprldmxo3-nSfLmcH54HMW
drwxr-xr-x  framstag users        - 2017-09-08 11:47:18 wNEWaDCgyXTj0d-Myk8wXZfh
-rw-r--r--  framstag users      377 2015-06-12 14:02:53 -zDmc7xfobKDkbl8z7oKOHxv
-rw-r--r--  framstag users    2,367 2012-07-10 14:32:30 7pfKs27K9k5zANE4WOQEuFa2
-rw-------  framstag users      692 2009-10-20 13:45:41 8SQElYCph85kDdcFasUHybVr
-rw-------  framstag users    2,872 2017-08-31 16:21:52 bm,yNi1e4fsAClDv7lNxxSfJ
lrwxrwxrwx  framstag users        - 2017-06-01 15:53:00 GZxNYI0Gy96R18fz40f7k5rl -> wvuQKHYzdFbar18fW6jjOerXk2IsS4OAA2fnHalBZjMQ,7Kw0j-zE3IJqxhmmGBN8G9
-rw-r--r--  framstag users      182 2016-12-01 13:34:31 rqtNBbiYDym0hPMbBL-VLJZcFZu6nkNxlsjTX-sU88I4I1

I have to mount the snapshot with encfs, to have access to the (decrypted)
files. 

Any better ideas?

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20170914145739.GA32347@rus.uni-stuttgart.de>
