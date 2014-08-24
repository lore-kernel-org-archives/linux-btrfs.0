Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from forward1m.mail.yandex.net ([37.140.138.1]:46789 "EHLO
	forward1m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaHXR5R (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 Aug 2014 13:57:17 -0400
Received: from web23m.yandex.ru (web23m.yandex.ru [37.140.138.114])
	by forward1m.mail.yandex.net (Yandex) with ESMTP id E1B3C1220F6D
	for <linux-btrfs@vger.kernel.org>; Sun, 24 Aug 2014 21:46:41 +0400 (MSK)
From: Flash ROM <flashromguru@yandex.com>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
In-Reply-To: <CAGQ70euehc2=Q9rRJ1zk7HzobDsbBg8QnVi=-2t3Zhn35xLRzA@mail.gmail.com>
References: <CAGQ70evg4N0dU1-hycjQYbUDUwfnH_akTEcNTtAf=2rjtDU7NA@mail.gmail.com>
	<pan$36b2f$b7fa7666$7edd97f3$7ace6746@cox.net> <CAGQ70euehc2=Q9rRJ1zk7HzobDsbBg8QnVi=-2t3Zhn35xLRzA@mail.gmail.com>
Subject: Re: 6+ MiB/s constant usage on a btrfs volume with kernel 3.16
MIME-Version: 1.0
Message-Id: <441201408902401@web23m.yandex.ru>
Date: Sun, 24 Aug 2014 19:46:41 +0200
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Happens a 100% of the time here, annoyingly. As mentioned, 3.15 was
> working for me, and still does. Multiple reboots and it happens
> immediately on boot even before gdm comes up.
Would be logical to do block-level I/O tracing to get idea WHAT is this IO, right? 

Try something like echo 1 > /proc/sys/vm/block_dump and see dmesg.

Beware: it can flood your logs and then dumping logs to HDD can also cause I/O ( which is in turn logged). 

So take care and do not forget to disable it by doing echo 0 > /proc/sys/vm/block_dump
