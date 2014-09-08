Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43019 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbaIHM3O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 8 Sep 2014 08:29:14 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XQy4G-0000p7-6k
	for linux-btrfs@vger.kernel.org; Mon, 08 Sep 2014 14:29:12 +0200
Received: from pd953ec5f.dip0.t-ipconnect.de ([217.83.236.95])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Sep 2014 14:29:12 +0200
Received: from holger.hoffstaette by pd953ec5f.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Sep 2014 14:29:12 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Linux 3.14.18 : kernel BUG at fs/btrfs/file.c:890!
Date: Mon, 8 Sep 2014 12:29:00 +0000 (UTC)
Message-ID: <pan.2014.09.08.12.29.00@googlemail.com>
References: <1410107980.2832.41.camel@localhost>
	<pan.2014.09.07.17.48.53@googlemail.com>
	<1410169197.2383.3.camel@daevel.fr>
	<pan.2014.09.08.09.59.46@googlemail.com>
	<1410173300.2383.10.camel@daevel.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 08 Sep 2014 12:48:20 +0200, Olivier Bonvalet wrote:

> Le lundi 08 septembre 2014 à 09:59 +0000, Holger Hoffstätte a écrit :
>> By default btrfsck doesn't do anything. What happens when you run it
>> without --repair, just to see what it finds?
> 
> In fact I haven't enough memory to run it (8GB of RAM only, with a 2*3TB
> FS in mirroring, btrfs mirroring).

Sigh..sorry to hear that. If you have another non-btrfs partition with
plenty free space, you could try:

fallocate -l 32GiB /path/swapfile (more/less depending on disk space)
mkswap /path/swapfile
swapon /path/swapfile

and try the btrfsck again. It really should not use that much RAM.. :(

If that's not an option either I'f afraid I don't know anything else
to try.

-h

