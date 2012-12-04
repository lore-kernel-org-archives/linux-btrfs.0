Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([85.222.100.130]:47090 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab2LDKWl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Dec 2012 05:22:41 -0500
Received: from lampka.siedziba.pl (localhost.graciarnia [127.0.0.1])
	by zlom.siedziba.pl (Postfix) with ESMTPA id 2073585FC83
	for <linux-btrfs@vger.kernel.org>; Tue,  4 Dec 2012 11:22:35 +0100 (CET)
Message-ID: <aff2e235b83e5c2c9fbcedda2ad21b8a.squirrel@lampka.siedziba.pl>
In-Reply-To: <50BDB967.9070400@siedziba.pl>
References: <50BDB967.9070400@siedziba.pl>
Date: Tue, 4 Dec 2012 11:22:35 +0100
Subject: Re: various problems converting to RAID1
From: =?utf-8?B?IlBpb3RyIFBhd8WCb3ci?= <pp@siedziba.pl>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

As I was in a hurry, I forgot about some things:

> I rebooted my computer and the balance started continuing its work

Of course I deleted around 15GB of data to free some space after noticing
there is no space left, then tried to restart balance, it didn't work,
checked logs, noticed problems and rebooted.

> I unmounted the FS and run btrfsck.

I also run scrub before, it haven't found any errors.

My kernel is from
http://kernel.ubuntu.com/~kernel-ppa/mainline/v3.7-rc7-raring/

The file system may have been corrupted few weeks earlier, as I enabled
qgroups to test how they work, but soon started getting strange memory
allocation failures from google-chrome, from btrfs itself, while trying to
hibernate, while using virtualbox, and some hard lock-ups too. I disabled
qgroups and everything went back to normal. I can dig up some kernel logs
when I get back home.

Regards

