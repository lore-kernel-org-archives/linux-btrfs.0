Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59503 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbbDHTWi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 8 Apr 2015 15:22:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YfvYa-0001C0-KN
	for linux-btrfs@vger.kernel.org; Wed, 08 Apr 2015 21:22:36 +0200
Received: from ip18864262.dynamic.kabel-deutschland.de ([24.134.66.98])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2015 21:22:36 +0200
Received: from hurikhan77 by ip18864262.dynamic.kabel-deutschland.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Apr 2015 21:22:36 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: Recovering BTRFS from bcache failure.
Date: Wed, 08 Apr 2015 21:22:22 +0200
Message-ID: <eobgvb-j7s.ln1@hurikhan77.spdns.de>
References: <CAPL5yKeARUyaM3YiQRmEPvE=4LX2-7gsyyUJDULRnD388vNhxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dan Merillat <dan.merillat@gmail.com> schrieb:

> Bcache failures are nasty, because they leave a mix of old and new
> data on the disk.  In this case, there was very little dirty data, but
> of course the tree roots were dirty and out-of-sync.
> 
> fileserver:/usr/src/btrfs-progs# ./btrfs --version
> Btrfs v3.18.2
> 
> kernel version 3.18
> 
> [  572.573566] BTRFS info (device bcache0): enabling auto recovery
> [  572.573619] BTRFS info (device bcache0): disk space caching is enabled
> [  574.266055] BTRFS (device bcache0): parent transid verify failed on
> 7567956930560 wanted 613690 found 613681
> [  574.276952] BTRFS (device bcache0): parent transid verify failed on
> 7567956930560 wanted 613690 found 613681
> [  574.277008] BTRFS: failed to read tree root on bcache0
> [  574.277187] BTRFS (device bcache0): parent transid verify failed on
> 7567956930560 wanted 613690 found 613681
> [  574.277356] BTRFS (device bcache0): parent transid verify failed on
> 7567956930560 wanted 613690 found 613681
> [  574.277398] BTRFS: failed to read tree root on bcache0
> [  574.285955] BTRFS (device bcache0): parent transid verify failed on
> 7567965720576 wanted 613689 found 613694
> [  574.298741] BTRFS (device bcache0): parent transid verify failed on
> 7567965720576 wanted 613689 found 610499
> [  574.298804] BTRFS: failed to read tree root on bcache0
> [  575.047079] BTRFS (device bcache0): bad tree block start 0
> [  7567954464768 575.111495] BTRFS (device bcache0): parent transid verify
> [  failed on
> 7567954464768 wanted 613688 found 613685
> [  575.111559] BTRFS: failed to read tree root on bcache0
> [  575.121749] BTRFS (device bcache0): bad tree block start 0
> [  7567954214912 575.131803] BTRFS (device bcache0): parent transid verify
> [  failed on
> 7567954214912 wanted 613687 found 613680
> [  575.131866] BTRFS: failed to read tree root on bcache0
> [  575.180101] BTRFS: open_ctree failed
> 
> all the btrfs tools throw up their hands with similar errors:
> ileserver:/usr/src/btrfs-progs# btrfs restore /dev/bcache0 -l
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't setup device tree
> Could not open root, trying backup super
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't setup device tree
> Could not open root, trying backup super
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't setup device tree
> Could not open root, trying backup super
> 
> 
> fileserver:/usr/src/btrfs-progs# ./btrfsck --repair /dev/bcache0
> --init-extent-tree
> enabling repair mode
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> Ignoring transid failure
> Couldn't setup extent tree
> Couldn't setup device tree
> Couldn't open file system
> 
> Annoyingly:
> # ./btrfs-image -c9 -t4 -s -w /dev/bcache0 /tmp/test.out
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> parent transid verify failed on 7567956930560 wanted 613690 found 613681
> Ignoring transid failure
> Couldn't setup extent tree
> Open ctree failed
> create failed (Success)
> 
> So I can't even send an image for people to look at.

There's always last resort (LAST RESORT!) btrfs-zero-log. It may destroy 
some of your data, however, and can make things even worse if other repairs 
could've helped before. So here's some pointers:

  * btrfs-find-root: find a working tree-root (no idea how to set it, tho)
  * mount -o recovery: mount in recovery mode (tries to mount with a working
    superblock backup)
  * btrfs restore: command to get files off a broken fs (at least what is
    readable, no guarantees for sane file contents, tho, I guess)

Its a bit hard to follow the discussion here because posts from Cameron are 
missing in my NNTP reader (I'm using the gmane gateway to read here). So I'm 
answering on the first post. Not sure, what you tried until now (except 
"btrfs restore").

If you don't have time, this is all you can try now. If your data is 
valuable - well, you have to wait for the experts here. But general opinion 
here is: If you don't have backups, your data is not valuable by definition, 
especially if using an unmature fs, or an even more experimental setup like 
bcache. ;-)

PS: btrfs-zero-log is usually my personal first-resort in case of problems 
not fixable within a few tries. I got nightly backups to restore from and 
compare data after zero-log. Thus why I started my answer with it.

-- 
Replies to list only preferred.

