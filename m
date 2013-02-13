Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:55843 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759980Ab3BMRc7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Feb 2013 12:32:59 -0500
Received: from mailout-de.gmx.net ([10.1.76.29]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0LmQiS-1UeBjv2Vjm-00ZwRT for
 <linux-btrfs@vger.kernel.org>; Wed, 13 Feb 2013 18:32:57 +0100
Message-ID: <511BCE40.60003@gmx.li>
Date: Wed, 13 Feb 2013 18:32:48 +0100
From: Holger Bach <bach@gmx.li>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Bugreport: btrfsck breaks with Assertion `!(rec->is_root)' failed
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

after my filesystem is broken (I have no idea why, because last shut 
down was nomal) I tried to repair it with btrfsck (
Btrfs v0.20-rc1-56-g6cd836d). But unfortunately the process breaks with:

parent transid verify failed on 29896704 wanted 392661 found 395689
parent transid verify failed on 29896704 wanted 392661 found 395689
parent transid verify failed on 29896704 wanted 392661 found 395689
parent transid verify failed on 29896704 wanted 392661 found 395689
Ignoring transid failure
checking extents
parent transid verify failed on 34172928 wanted 392666 found 395689
parent transid verify failed on 34172928 wanted 392666 found 395689
parent transid verify failed on 34172928 wanted 392666 found 395689
parent transid verify failed on 34172928 wanted 392666 found 395689
Ignoring transid failure
leaf parent key incorrect 34172928
btrfsck: btrfsck.c:1935: check_owner_ref: Assertion `!(rec->is_root)' 
failed.

after that I tried to restore the data from disk unfortunately with an 
older Version of btrfs-restore. There are a lot of files I have restored 
but this process also breaks. (I can't remember the message). But after 
a second try (with old and the latest version) breaks now much earlier. 
Here is the output:

parent transid verify failed on 29896704 wanted 392661 found 395689
parent transid verify failed on 29896704 wanted 392661 found 395689
parent transid verify failed on 29896704 wanted 392661 found 395689
parent transid verify failed on 29896704 wanted 392661 found 395689
Ignoring transid failure
Root objectid is 5
We seem to be looping a lot on 
/mnt/var/cache/apt-xapian-index/index.1/postlist.DB, do you want to keep 
going on ? (y/N): y
parent transid verify failed on 32559104 wanted 392664 found 395689
parent transid verify failed on 32559104 wanted 392664 found 395689
parent transid verify failed on 32559104 wanted 392664 found 395689
parent transid verify failed on 32559104 wanted 392664 found 395689
Ignoring transid failure
parent transid verify failed on 32559104 wanted 392664 found 395689
Ignoring transid failure
leaf parent key incorrect 32559104
parent transid verify failed on 32559104 wanted 392664 found 395689
Ignoring transid failure
leaf parent key incorrect 32559104
Error searching -1
We seem to be looping a lot on 
/mnt/var/cache/apt-xapian-index/index.1/postlist.DB, do you want to keep 
going on ? (y/N):

But it is not possible to enter a choise because the process ends.

Hope this bugreport is useful for you.

Holger


