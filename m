Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:46347 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbaIHKsX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Sep 2014 06:48:23 -0400
Message-ID: <1410173300.2383.10.camel@daevel.fr>
Subject: Re: Linux 3.14.18 : kernel BUG at fs/btrfs/file.c:890!
From: Olivier Bonvalet <btrfs.list@daevel.fr>
To: Holger =?ISO-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Date: Mon, 08 Sep 2014 12:48:20 +0200
In-Reply-To: <pan.2014.09.08.09.59.46@googlemail.com>
References: <1410107980.2832.41.camel@localhost>
	 <pan.2014.09.07.17.48.53@googlemail.com>
	 <1410169197.2383.3.camel@daevel.fr>
	 <pan.2014.09.08.09.59.46@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Le lundi 08 septembre 2014 à 09:59 +0000, Holger Hoffstätte a écrit :
> By default btrfsck doesn't do anything. What happens when you run it
> without --repair, just to see what it finds?

In fact I haven't enough memory to run it (8GB of RAM only, with a 2*3TB
FS in mirroring, btrfs mirroring).

