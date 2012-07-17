Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39592 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146Ab2GQLNR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 07:13:17 -0400
Received: by pbbrp8 with SMTP id rp8so649121pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Jul 2012 04:13:17 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 17 Jul 2012 07:13:17 -0400
Message-ID: <CAHzCyiQ57DU2O+jog2oc65sfQStL3WCdsxZcZbCFHG1Ygi8dBg@mail.gmail.com>
Subject: Unmountable btrfs filesystem
From: "Providence M. SALUMU" <providence.salumu@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi devs,

I can't mount my btrfs-based external disk. I don't know what happened
to the disk, but usually it gets disconnected (usb cable pulled out)
buy my 8 months old daughter.

Here's the output from dmesg:

[  299.699543] parent transid verify failed on 528952573952 wanted
22726 found 22728
[  299.700947] btrfs read error corrected: ino 1 off 528952573952 (dev
/dev/sdb6 sector 585319392)
[  299.701224] btrfs: open_ctree failed

I then run "btrfsck /dev/sdb6" with not much more success at all. The
output is as follows:

  Ignoring transid failure
  leaf parent key incorrect 528969142272
  parent transid verify failed on 528969142272 wanted 22728 found 22726
  Ignoring transid failure
  leaf parent key incorrect 528969142272
  btrfsck: btrfsck.c:1933: check_owner_ref: Assertion `!(rec->is_root)' failed.
  Aborted

 My btrfs-progs comes from
   repository:
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
   at the commit:            8935d8436147f86dfbda3d8b8175a77b654b8abc
   branch:                   master
and I'm running linux-3.5_rc7 kernel. (Linux-3.5_rc6 has got the same
mount issue as well)

I tried the btrfs-find-root hint (from
https://btrfs.wiki.kernel.org/index.php/Restore), but since I don't
have the lines starting with "Well block n seems great...", I'm
doubtful about which block id to run btrfs-restore -t n with.

Can you help in guys?

Many thanks in advance,

- Providence.
