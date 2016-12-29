Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34990 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751358AbcL2Coe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 28 Dec 2016 21:44:34 -0500
Received: by mail-oi0-f66.google.com with SMTP id v84so53017156oie.2
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Dec 2016 18:44:34 -0800 (PST)
Received: from crass-Ideapad-Z570 (50-24-109-189.bcstcmtk02.res.dyn.suddenlink.net. [50.24.109.189])
        by smtp.gmail.com with ESMTPSA id l2sm21286554otc.38.2016.12.28.18.44.33
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Dec 2016 18:44:33 -0800 (PST)
Date: Wed, 28 Dec 2016 20:44:30 -0600
From: Glenn Washburn <development@efficientek.com>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs send does not preserve reflinked files within subvolumes.
Message-ID: <20161228204430.348cb61f@crass-Ideapad-Z570>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/DR8nJq259U=O6ur5cGWUoOg"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

--MP_/DR8nJq259U=O6ur5cGWUoOg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I'm having a hard time getting btrfs receive to create reflinked files
and have a trivial example that I believe *should* work but doesn't.
I've attached a script that I used to perform this test, so others can
try to reproduce.  The text file is the output of the shell script
except the last command, which is a tool I wrote to print the extent
info from FIEMAP.  "btrfs fi du" would work just as well, but I'm on
Ubuntu 16.04, whose btrfs progs doesn't have that command yet.  I've
also tested on Ubuntu 16.10 with similar results, except that "btrfs fi
du" is on that version and confirms what my tool displays.

So, can send not do what I'm trying to get it to do? If it can now,
when did that feature get introduced (must have been after kernel
4.8)?  I'm very surprised that this feature wouldn't have already
been done and if not that no one seems to be complaining about it. I've
done a decent amount of searching on this and have come up with
nothing.  Any help would be greatly appreciated.

Thanks,
Glenn

--MP_/DR8nJq259U=O6ur5cGWUoOg
Content-Type: application/x-shellscript
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=sending-reflinked-files.sh

IyEvYmluL2Jhc2gKQlZPTDE9JDEKQlZPTDI9JDIKCnVuYW1lIC1hCmJ0cmZzIC0tdmVyc2lvbgoK
Y2QgIiRCVk9MMSIKYnRyZnMgc3ViIGNyZWF0ZSBDCmRkIGlmPS9kZXYvdXJhbmRvbSBvZj1DL3Rl
c3QgY291bnQ9MTAwCmNwIC0tcmVmbGluaz1hbHdheXMgLXZwIEMvdGVzdHssLnJlZn0KYnRyZnMg
cHJvcGVydHkgc2V0IEMgcm8gdHJ1ZQpidHJmcyBzZW5kIC12IEMgfCBidHJmcyByZWNlaXZlICIk
QlZPTDIiCmJ0cmZzIGZpIGR1IEMvKiAiJEJWT0wyIi9DLyoK

--MP_/DR8nJq259U=O6ur5cGWUoOg
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=sending-reflinked-files-16.04.txt

+ BVOL1=/media/tmp1
+ BVOL2=/media/tmp2
+ uname -a
Linux crass-Ideapad-Z570 4.4.0-53-generic #74-Ubuntu SMP Fri Dec 2 15:59:10 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux
+ btrfs --version
btrfs-progs v4.4
+ cd /media/tmp1
+ btrfs sub create C
Create subvolume './C'
+ dd if=/dev/urandom of=C/test count=100
100+0 records in
100+0 records out
51200 bytes (51 kB, 50 KiB) copied, 0.00485396 s, 10.5 MB/s
+ cp --reflink=always -vp C/test C/test.ref
'C/test' -> 'C/test.ref'
+ btrfs property set C ro true
+ btrfs send -v C
+ btrfs receive /media/tmp2
At subvol C
BTRFS_IOC_SEND returned 0
joining genl thread
At subvol C
+ ~/development/reflink_tools.git/fmaptool.py print -P C/test C/test.ref /media/tmp2/C/test /media/tmp2/C/test.ref
C/test
------
0+53248: 12845056
C/test.ref
----------
0+53248: 12845056
/media/tmp2/C/test
------------------
0+49152: NULL
49152+4096: 12845056
/media/tmp2/C/test.ref
----------------------
0+49152: NULL
49152+4096: 12849152

--MP_/DR8nJq259U=O6ur5cGWUoOg--
