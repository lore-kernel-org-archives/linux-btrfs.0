Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout08.t-online.de ([194.25.134.20]:41261 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab2FFQTZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2012 12:19:25 -0400
Date: 06 Jun 2012 18:18:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CAMmnG49CXB@helmut.hullen.de>
In-Reply-To: <20120606160454.GP15986@carfax.org.uk>
Subject: Re: New btrfs-progs integration branch
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 06.06.12:

>> git checkout integration-20120605

[...]
>    Can you compare your Makefile with the one at [1] -- in particular
> the progs variable at line 21-23, the "all" target on line 37, and
> the "btrfs-convert" target on line 97. There definitely should not be
> a plain "convert" target in there, but that seems to be what your
> system was failing on.

Makefile with 3888 Bytes.

"md5sum Makefile" shows

(my file)
deef961e3ecd560ad8710cf0b58f5570  Makefile

(the file from your link)
deef961e3ecd560ad8710cf0b58f5570  Makefile

The problem is somewhere on another place ...

Viele Gruesse!
Helmut
