Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f181.google.com ([209.85.216.181]:36176 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbF2QXw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Jun 2015 12:23:52 -0400
Received: by qczu9 with SMTP id u9so17782333qcz.3
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Jun 2015 09:23:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABL_Pd-vt977x_bnkOdC==Wc6iL9gzgfdamypa7k-qcV-ADqyQ@mail.gmail.com>
References: <CABL_Pd-vt977x_bnkOdC==Wc6iL9gzgfdamypa7k-qcV-ADqyQ@mail.gmail.com>
From: Martin Tippmann <martin.tippmann@gmail.com>
Date: Mon, 29 Jun 2015 18:23:31 +0200
Message-ID: <CABL_Pd_Nx7PDpVgHpjfroGVdJoXyQ5peRvjcuBFLQ93pGxJsQA@mail.gmail.com>
Subject: Re: Linux 4.1.0: BTRFS: error (device sdb) in btrfs_run_delayed_refs:2821:
 errno=-17 Object already exists
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some more data:

After unmounting the read-only mounted partition, this notice appears
in the kernel log:

VFS: Busy inodes after unmount of sdb. Self-destruct in 5 seconds.
Have a nice day...


Here is a the btrfs check output.. btrfs check --repair seems to fix the issues:

# btrfs check /dev/sdb
Checking filesystem on /dev/sdb
UUID: 4b0fdfb4-8d9e-43e4-b51c-15446a792d9b
checking extents
checking free space cache
block group 414527258624 has wrong amount of free spacefailed to load
free space cache for block group 414527258624
checking fs roots
root 5 inode 444968 errors 400, nbytes wrong
root 5 inode 446183 errors 400, nbytes wrong
root 5 inode 455719 errors 400, nbytes wrong
root 5 inode 466667 errors 400, nbytes wrong
root 5 inode 468041 errors 400, nbytes wrong
root 5 inode 489381 errors 400, nbytes wrong
root 5 inode 512320 errors 400, nbytes wrong
root 5 inode 521936 errors 400, nbytes wrong
root 5 inode 522017 errors 400, nbytes wrong
root 5 inode 527486 errors 400, nbytes wrong
root 5 inode 528830 errors 400, nbytes wrong
root 5 inode 548638 errors 400, nbytes wrong
root 5 inode 555329 errors 400, nbytes wrong
root 5 inode 571448 errors 400, nbytes wrong
root 5 inode 573600 errors 400, nbytes wrong
root 5 inode 589105 errors 400, nbytes wrong
root 5 inode 590616 errors 400, nbytes wrong
root 5 inode 595230 errors 400, nbytes wrong
root 5 inode 610324 errors 400, nbytes wrong
root 5 inode 611844 errors 400, nbytes wrong
root 5 inode 611972 errors 400, nbytes wrong
root 5 inode 612313 errors 400, nbytes wrong
root 5 inode 613156 errors 400, nbytes wrong
root 5 inode 614017 errors 400, nbytes wrong
root 5 inode 616045 errors 400, nbytes wrong
root 5 inode 619160 errors 400, nbytes wrong
root 5 inode 626453 errors 400, nbytes wrong
root 5 inode 626648 errors 400, nbytes wrong
root 5 inode 629338 errors 400, nbytes wrong
root 5 inode 633583 errors 400, nbytes wrong
root 5 inode 638616 errors 400, nbytes wrong
root 5 inode 639023 errors 400, nbytes wrong
root 5 inode 640373 errors 400, nbytes wrong
root 5 inode 641524 errors 400, nbytes wrong
root 5 inode 641586 errors 400, nbytes wrong
root 5 inode 645090 errors 400, nbytes wrong
root 5 inode 655241 errors 400, nbytes wrong
root 5 inode 674139 errors 400, nbytes wrong
found 726034010941 bytes used err is 1
total csum bytes: 707524756
total tree bytes: 1528659968
total fs tree bytes: 453296128
total extent tree bytes: 243171328
btree space waste bytes: 253506582
file data blocks allocated: 724722012160
 referenced 848544292864
btrfs-progs v4.0


regards
Martin
