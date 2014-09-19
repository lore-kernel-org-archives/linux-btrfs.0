Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44331 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682AbaISNgi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 09:36:38 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XUyKp-0006sT-Fv
	for linux-btrfs@vger.kernel.org; Fri, 19 Sep 2014 15:34:51 +0200
Received: from pd953ea7c.dip0.t-ipconnect.de ([217.83.234.124])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 15:34:51 +0200
Received: from holger.hoffstaette by pd953ea7c.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 15:34:51 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Performance Issues
Date: Fri, 19 Sep 2014 13:34:38 +0000 (UTC)
Message-ID: <pan.2014.09.19.13.34.38@googlemail.com>
References: <1411129114.1811.7.camel@zarniwoop.blob>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 19 Sep 2014 13:18:34 +0100, Rob Spanton wrote:

> I have a particularly uncomplicated setup (a desktop PC with a hard
> disk) and I'm seeing particularly slow performance from btrfs.  A `git
> status` in the linux source tree takes about 46 seconds after dropping
> caches, whereas on other machines using ext4 this takes about 13s.  My

This is - unfortunately - a particular btrfs oddity/characteristic/flaw,
whatever you want to call it. git relies a lot on fast stat() calls,
and those seem to be particularly slow with btrfs esp. on rotational
media. I have the same problem with rsync on a freshly mounted volume;
it gets fast (quite so!) after the first run.

The simplest thing to fix this is a "du -s >/dev/null" to pre-cache all
file inodes.

I'd also love a technical explanation why this happens and how it could
be fixed. Maybe it's just a consequence of how the metadata tree(s)
are laid out on disk.

> I've tried mounting with noatime, and this has had no effect.  Anyone
> got any ideas?  

Don't drop the caches :-)

-h

