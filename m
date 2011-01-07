From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: "open_ctree failed", unable to mount the fs
Date: Fri, 07 Jan 2011 20:01:47 +0100
Message-ID: <4D27631B.9020700@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I got a "power cycle", after which I'm no longer able to mount btrfs 
filesystem:


device fsid xxxxx-yyyyy devid 1 transid 169686 /dev/vda3
device fsid xxxxx-yyyyy devid 1 transid 169686 /dev/vda3
parent transid verify failed on 3260289024 wanted 169686 found 169685
parent transid verify failed on 3260289024 wanted 169686 found 169685
parent transid verify failed on 3260289024 wanted 169686 found 169685
btrfs: open_ctree failed


Tried to get that mounted with 2.6.35 and 2.6.37, without success.

Is there a way to fix it?


-- 
Tomasz Chmielewski
http://wpkg.org
