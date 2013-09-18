Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from efeu.mur.at ([89.106.208.66]:38918 "EHLO efeu.mur.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753157Ab3IRSPI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 14:15:08 -0400
Message-ID: <5239EDC3.2060804@mur.at>
Date: Wed, 18 Sep 2013 20:15:31 +0200
From: =?UTF-8?B?Sm9naSBIb2Ztw7xsbGVy?= <jogi@mur.at>
MIME-Version: 1.0
To: Clemens Eisserer <linuxhippy@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: rootfs crash
References: <5236E1FF.4080900@mur.at> <5238343F.3020802@mur.at> <20130917111809.GA16032@panda> <52384A08.40404@mur.at> <523873FC.20504@mur.at> <CAFvQSYS7U6VdYeUa-BocBq2tgQuyg1Z_eqpO=6UkcER2a1_p-g@mail.gmail.com>
In-Reply-To: <CAFvQSYS7U6VdYeUa-BocBq2tgQuyg1Z_eqpO=6UkcER2a1_p-g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Clemens, all,
Am 2013-09-17 20:53, schrieb Clemens Eisserer:

> a. comment out the free()-calls which led to crashes

Uh, well, I did not want to go that far ;)  I'm certainly not the
greatest programmer around, but not freeing allocated memory seems kind
of drastic.

Anyway, I checked out a copy of btrfs-progs from git and took a look at
the code.  Then I remembered valgrind and instead of running btrfs
restore on the broken machine I tried it on my images (saved with dd on
an external hard drive).  Running the self-compiled program using sudo
resulted in the same errors.

Now the (at least for me) fun part.  Running it under my UID I managed
to retrieve 13GB worth of data so far before hitting the same error:

  Error in `./btrfs': free(): invalid next size (normal)

I would be glad for someone's opinion on this.

Regards!
-- 
j.hofmüller
