Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f50.google.com ([209.85.160.50]:39853 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab3G1FRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Jul 2013 01:17:36 -0400
Received: by mail-pb0-f50.google.com with SMTP id uo5so153614pbc.37
        for <linux-btrfs@vger.kernel.org>; Sat, 27 Jul 2013 22:17:35 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Recovering from btrfs error Couldn't read chunk root.
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CAA6RbirvdqOvCcWi1qGG1+USCmcc9J=ECXGJiUH3anHa5EaP7g@mail.gmail.com>
Date: Sun, 28 Jul 2013 13:17:29 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <8E1258E3-BCFC-406E-B8F6-2ABB3280C9F0@gmail.com>
References: <CAA6RbirvdqOvCcWi1qGG1+USCmcc9J=ECXGJiUH3anHa5EaP7g@mail.gmail.com>
To: Kyriakos <kyriakosbrastianos@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello, 

It seems Btrfs Chunk Tree is damaged, so you can not mount Btrfs filesystem any more.

However, you can try the latest Btrfs-progs, Miao Xie implements chunk tree recover function.

The url is:

	git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git


you can try it:
		btrfs chunk-recover  -v <dev>

This is Time-consuming, because it will scan the whole disk. And also,
please catch output of processing(this is helpful to us if the recovery fails, -v option
enable this).

Thanks,
Wang






