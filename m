Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f54.google.com ([209.85.216.54]:53500 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbaKXTer convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 14:34:47 -0500
Received: by mail-qa0-f54.google.com with SMTP id i13so6905892qae.13
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Nov 2014 11:34:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$e596a$cfc2cde2$6957e9d8$10a112b8@cox.net>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
	<pan.2014.11.24.08.23.25@googlemail.com>
	<pan$e596a$cfc2cde2$6957e9d8$10a112b8@cox.net>
Date: Mon, 24 Nov 2014 11:34:46 -0800
Message-ID: <CAJBj3veoV=QYF27+zFcJHf9OA0mXVzTU4gYrRz_9cAmVRxrF6Q@mail.gmail.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
From: John Williams <jwilliams4200@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 12:23 AM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:

> Would there be room for a compromise with e.g. 128 bits?

For example, Spooky V2 hash is 128 bits and is very fast. It is
noncryptographic, but it is more than adequate for data checksums.

http://burtleburtle.net/bob/hash/spooky.html

SnapRAID uses this hash, and it runs at about 15 GB/sec on my machine
(Xeon E3-1270 V2 @ 3.50Ghz)
