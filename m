Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60562 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaIIWXv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Sep 2014 18:23:51 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XRTpE-0007E2-At
	for linux-btrfs@vger.kernel.org; Wed, 10 Sep 2014 00:23:48 +0200
Received: from pd953e39c.dip0.t-ipconnect.de ([217.83.227.156])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 00:23:48 +0200
Received: from holger.hoffstaette by pd953e39c.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Sep 2014 00:23:48 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: ENOSPC on mostly empty file system
Date: Tue, 9 Sep 2014 22:23:33 +0000 (UTC)
Message-ID: <pan.2014.09.09.22.23.33@googlemail.com>
References: <3150960.nnNb4J6vhp@wuerfel> <4255785.FLXNWijYCD@wuerfel>
	<CAFvQSYQX9e__9vUedcqN2onUA4v2yyt2wz7wGdzAkTHzLL+ggw@mail.gmail.com>
	<10095560.XRujO0W0CE@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 09 Sep 2014 23:49:10 +0200, Arnd Bergmann wrote:

> Label: none  uuid: 1d88cccb-3d0e-42d9-8252-a226dc5c2e47
>         Total devices 1 FS bytes used 8.79GB
>         devid    1 size 67.14GB used 67.14GB path /dev/sdc6
                          ^^^^^^^^^^^^^^^^^^^^ *ding ding ding*

The term "used" is confusing here and really should be called
"allocated", since it's more than the number of actually used
bytes. Note that df shows that you "have" ~66GB data and ~1GB
metadata (giving approx. ~67GB), despite the fact that of those
65GB data allocated only ~8GB are actually used.

However all these reserved data chunks are preventing the metadata
space from expanding, which is pretty full:
Metadata, DUP: total=1.00GB, used=799.54MB

Here "total" also should be "allocated/reserved" and is 1GB, but
btrfs feels it's necessary to allocate a new metadata chunk
(which would also increase "total") and fails.

Running balance with -dusage=x will garbage-collect the reserved but
mostly-empty data chunks with "up to x" percent actual usage.

-h

