Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtpauth.rollernet.us ([208.79.240.5]:56042 "EHLO
        smtpauth.rollernet.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbeHQGsx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Aug 2018 02:48:53 -0400
Received: from smtpauth.rollernet.us (localhost [127.0.0.1])
        by smtpauth.rollernet.us (Postfix) with ESMTP id 9C9A12808412
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 20:47:09 -0700 (PDT)
Received: from hosea.tallye.com (hosea.tallye.com [IPv6:2001:470:e9d7::7])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        by smtpauth.rollernet.us (Postfix) with ESMTPSA
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 20:47:09 -0700 (PDT)
Received: from alzatex.com (moses.tallye.com [IPv6:2001:470:e9d7::5])
        by hosea.tallye.com (8.14.2/8.14.2/Debian-2build1) with ESMTP id w7H3l7mx017361
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Aug 2018 20:47:08 -0700
Date: Thu, 16 Aug 2018 20:47:07 -0700
From: "Loren M. Lang" <lorenl@north-winds.org>
To: linux-btrfs@vger.kernel.org
Subject: BTRFS w/ quotas hangs on read-write mount using all available RAM
Message-ID: <20180817034707.GB11938@alzatex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I am unable to mount my btrfs in read-write mode after enabling quotas 
and running a full balance on it. My service is running Ubuntu 17.10 
with Linux kernel 4.13.0-17-generic and btrfs-progs 4.12. I am trying to 
recover with a live CD of Ubuntu 18.04.1 running Linux 4.15.0-29-generic 
with btrfs-progs 4.15.1. My system has two ~3 TB drives in the btrfs 
array with RAID1 for data and metadata and two sub volumes, / and /home.

I was attempting to track down where my free space was going when I 
discovered apt-btrfs-snapshot which was creating a snapshot for every 
package install I had done, some quite old. I had at least 20 snapshots 
created when I found it and told apt-btrfs-snapshot to delete all of 
them. Still not getting back the free space I was expecting, I found a 
script called btrfs-size.sh which can produce a report, but requires 
quotas to be enabled so I ran “sudo btrfs quota enable /“. After loosing 
some patience trying to figure it out, I decided to try and just run a 
full balance across everything, something like “sudo btrfs balance start 
-d -m -v /“, but I can’t remember the exact command. I then went to bed 
only to find my server was completely hung the next day. I couldn’t get 
the screen to wake or and other response so I was force to power cycle 
it. However, on repeated attempts to get it to boot, it hangs at the 
point that it tries to mount read-write and starts slowly consuming more 
and more RAM until it the system starts to hang. Switching to my 18.04.1 
recovery disk, I find I can mount it read only and look around, but I 
can’t disable quotas in read-only mode. If I run "mount -o remount,rw 
/mnt” to enable read-write, mount hangs in the D state forever and I can 
slowly see the RAM usage increasing. I added a massive 32 GB of swap 
partitions, but eventually the system hangs due to out of memory.

Lastly, I’ve tried unmounting it and running btrfs check on the drive. I 
see errors such as the following:

$ sudo btrfs check -p /dev/sda4
...
ref mismatch on [3994222952448 16384] extent item 0, found 1
tree backref 3994222952448 parent 9688891392 root 9688891392 not found
in extent tree
backpointer mismatch on [3994222952448 16384]
owner ref check failed [3994222952448 16384]
ref mismatch on [3994223329280 16384] extent item 0, found 1
tree backref 3994223329280 parent 9688891392 root 9688891392 not found
in extent tree
backpointer mismatch on [3994223329280 16384]
owner ref check failed [3994223329280 16384]
ref mismatch on [3994271203328 16384] extent item 0, found 1
tree backref 3994271203328 parent 9688891392 root 9688891392 not found
in extent tree
backpointer mismatch on [3994271203328 16384]
owner ref check failed [3994271203328 16384]
ref mismatch on [3994276593664 16384] extent item 0, found 1
tree backref 3994276593664 parent 9688891392 root 9688891392 not found
in extent tree
backpointer mismatch on [3994276593664 16384]
owner ref check failed [3994276593664 16384]
ref mismatch on [3994278756352 16384] extent item 0, found 1
tree backref 3994278756352 parent 9688891392 root 9688891392 not found
in extent tree
backpointer mismatch on [3994278756352 16384]
owner ref check failed [3994278756352 16384]

ERROR: errors found in extent allocation tree or chunk allocation
block group 3520760643584 has wrong amount of free space
failed to load free space cache for block group 3520760643584
checking free space cache [O]
checking fs roots [.][o].][o]
checking csums
checking root refs
checking quota groups
^C
ubuntu@ubuntu:~$ 

It hung at checking quota groups for 12 hours before I killed it. The 
errors above are only a small snippet, but seem to keep repeating the 
same basic thing. I have not tried a repair yet.

What’s the next step?

-- 
Loren M. Lang
lorenl@north-winds.org
http://www.north-winds.org/


Public Key: ftp://ftp.north-winds.org/pub/lorenl_pubkey.asc
Fingerprint: 10A0 7AE2 DAF5 4780 888A  3FA4 DCEE BB39 7654 DE5B
