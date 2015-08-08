Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:36741 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992578AbbHHTdP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 8 Aug 2015 15:33:15 -0400
Received: by lbbpu9 with SMTP id pu9so49126461lbb.3
        for <linux-btrfs@vger.kernel.org>; Sat, 08 Aug 2015 12:33:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150808190525.GM14352@carfax.org.uk>
References: <CABL_Pd-Z6-raB3ngEDbj=-d+QVMohGQ9DHXqv0fVvVNy-HVxUA@mail.gmail.com>
 <20150808190525.GM14352@carfax.org.uk>
From: Martin Tippmann <martin.tippmann@gmail.com>
Date: Sat, 8 Aug 2015 21:32:55 +0200
Message-ID: <CABL_Pd-Sgq-P-aknsGJkVCcN-9tG2j0rFy1SQv7iKJ2QrSEo8A@mail.gmail.com>
Subject: Re: fs unreadable after powercycle: BTRFS (device sda): parent
 transid verify failed on 427084513280 wanted 390924 found 390922
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-08-08 21:05 GMT+02:00 Hugo Mills <hugo@carfax.org.uk>:
>> Maybe someone can give some clues why does this happen in the first
>> place? Is it unfortunate timing due to the abrupt power cycle?
>> Shouldn't CoW protect against this somewhat?
>
>    Not "somewhat": it should protect it completely. There are two ways
> that this can happen: it's a bug in btrfs, or there's something
> stopping barriers from working. That latter case can be either a bug
> in the kernel's block layer (pretty unlikely), or the hardware is
> behaving badly and ignoring the barriers (more likely, particularly if
> it's on a USB/SATA converter).

Thanks for the information. The setup is nothing out of the ordinary.
The disks are HGST HUS724040ALA640 running on a Dell H310 SATA
controller and configured as JBOD. It's all running on defaults on a
Dell PowerEdge R720. SMART says the disk write cache is enabled -
maybe that's part of the problem?

>    I don't think there's a good solution to transid failures, I'm
> afraid. The best that I'm aware of is to use btrfs restore to grab the
> pieces of your FS that aren't up to date in your backups, and then
> restore from them.

Okay, fortunately can I dismiss the data - or is the broken Image of
any use for anyone? It's a 4TB disk but I guess I could create a
compressed (partial) image if it's of interest to anyone.

regards
Martin
