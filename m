Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:35185 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab3KRVnE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Nov 2013 16:43:04 -0500
Received: from out.poczta.wp.pl ([212.77.101.240])
          (envelope-sender <yzb3@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with SMTP
          for <linux-btrfs@vger.kernel.org>; 18 Nov 2013 22:43:00 +0100
Date: Mon, 18 Nov 2013 22:43:00 +0100
From: yzb3@wp.pl
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Subject: btrfs check prints a LOT of errors
Message-ID: <528a89e417f331.83591490@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

My cache adventures (slow boot, btrfs ERRORs in dmesg) continue; I went to the btrfs IRC and xaba suggested that I run btrfs check with the latest btrfs-progs from Chris. I was surprised to see such a multitude of errors, most of which are:

Extent back ref already exists for 951664640 parent 0 root 259
ref mismatch on [142340096 4096] extent item 1, found 2
Incorrect global backref count on 142340096 found 1 wanted 2
backpointer mismatch on [142340096 4096]
Errors found in extent allocation tree or chunk allocation
There is no free space entry for 2169298944-2176843776
cache appears valid but isnt 1103101952
free space inode generation (0) did not match free space cache generation (10978)

The output of btrfs check can be found on:
http://www33.zippyshare.com/v/18393891/file.html

The output of dmesg (less interesting, though):
http://www33.zippyshare.com/v/38517519/file.html

I am running Arch Linux, kernel 12.0. I am a typical desktop user and I can't say that I did anything out of the oridinary. When my boot has become slower, I cleared the cache and it helped, but the second time I did it I started seeing errors in dmesg.

I will be happy to provide additional information.

Thanks


