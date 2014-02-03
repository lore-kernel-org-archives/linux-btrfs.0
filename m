Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.py-ro.de ([89.238.75.159]:50986 "EHLO mail.py-ro.de"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752382AbaBCQWN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 11:22:13 -0500
Received: from localhost (virt.py-ro.de [127.0.0.1])
	by mail.py-ro.de (Postfix) with ESMTP id 0311349613
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Feb 2014 17:12:24 +0100 (CET)
Received: from mail.py-ro.de ([127.0.0.1])
	by localhost (virt.py-ro.de [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jC0yWWING1du for <linux-btrfs@vger.kernel.org>;
	Mon,  3 Feb 2014 17:12:22 +0100 (CET)
Received: from trediske.ws.office.manitu.net (unknown [IPv6:2a00:1828:0:1::9])
	by mail.py-ro.de (Postfix) with ESMTPA
	for <linux-btrfs@vger.kernel.org>; Mon,  3 Feb 2014 17:12:22 +0100 (CET)
Date: Mon, 3 Feb 2014 17:12:24 +0100
From: Tetja Rediske <tetja@tetja.de>
To: linux-btrfs@vger.kernel.org
Subject: btrfs raid5 unmountable
Message-ID: <20140203171224.3835fea1@trediske.ws.office.manitu.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

since Freenode is doomed today, i ask the direct way.

Following Filesystem:

Label: 'data'  uuid: 3a6fd6d7-5943-4cad-b56f-2e6dcabff453
        Total devices 6 FS bytes used 7.02TiB
        devid    1 size 1.82TiB used 1.82TiB path /dev/sda3
        devid    2 size 2.73TiB used 2.48TiB path /dev/sdc3
        devid    3 size 931.38GiB used 931.38GiB path /dev/sdd3
        devid    5 size 931.51GiB used 931.51GiB path /dev/sde1
        devid    6 size 931.51GiB used 931.51GiB path /dev/sdf1
        devid    7 size 2.73TiB used 2.48TiB path /dev/sdb3

Btrfs v3.12-dirty

If I try to mount it from dmesg:

[30644.681210] parent transid verify failed on 32059176910848 wanted
259627 found 259431 
[30644.681307] parent transid verify failed on 32059176910848 wanted
259627 found 259431 
[30644.681399] btrfs bad tree block start 0 32059176910848 
[30644.681407] Failed to read block groups: -5 
[30644.776879] btrfs: open_ctree failed

btrfs check aborts with (many of the 1st lines)

[...] 
Ignoring transid failure parent transid verify failed on 32059196616704
wanted 259627 found 259432
parent transid verify failed on 32059196616704 wanted 259627 found
259432 Check tree block failed, want=32059196616704, have=32059196747776

parent transid verify failed on 32059196616704 wanted 259627 found259432
Ignoring transid failure
parent transid verify failed on 32059196616704 wanted 259627 found259432
Ignoring transid failure
parent transid verify failed on 32059177230336 wanted 259627 found259431
Ignoring transid failure
parent transid verify failed on 32059196620800 wanted 259627 found259432
parent transid verify failed on 32059196620800 wanted 259627 found259432
Check tree block failed, want=32059196620800, have=1983699371120445514
Check tree block failed, want=32059196620800, have=1983699371120445514
Check tree block failed, want=32059196620800, have=1983699371120445514
read block failed check_tree_block
btrfs: cmds-check.c:2212: check_owner_ref: Assertion `!(rec->is_root)'
failed.
Aborted

What happened before:

One disk was faulty, I added a new one and removed the old one,
followed by a balance.

So far so good.

Some days after this I accidently removed a SATA Power Connector from
another drive, without noticing it at first. Worked about an hour on
the system, building new Kernel on another Filesystem. Rebooted with my
new Kernel and the FS was not mountable. I noticed the "missing" disk
and reattached the power.

So far i tried:

mount -o recovery
btrfs check
(after google) btrfs-zero-log

Sadly no luck. Whoever I can get my Files with btrfs restore. The
Filesystem contains mainly Mediafiles, so it is not so bad, if they
were lost, but restoring them from backups and sources will need
atleast about a week. (Most of the Files are mirrored on a private
Server, but even with 100MBit this takes a lot of time ; )

Some Idea who to recover this FS?

Kind Regards
Tetja Rediske




