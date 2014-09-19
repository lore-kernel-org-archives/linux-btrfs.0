Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39714 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbaISQX6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Sep 2014 12:23:58 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XV0yN-0003fL-O2
	for linux-btrfs@vger.kernel.org; Fri, 19 Sep 2014 18:23:51 +0200
Received: from pd953ea7c.dip0.t-ipconnect.de ([217.83.234.124])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 18:23:51 +0200
Received: from holger.hoffstaette by pd953ea7c.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Sep 2014 18:23:51 +0200
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: Performance Issues
Date: Fri, 19 Sep 2014 16:23:37 +0000 (UTC)
Message-ID: <pan.2014.09.19.16.23.37@googlemail.com>
References: <1411129114.1811.7.camel@zarniwoop.blob>
	<pan.2014.09.19.13.51.22@googlemail.com> <541C434F.4060500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 19 Sep 2014 10:53:03 -0400, Austin S Hemmelgarn wrote:

> I find that kind of funny, because regardless of filesystem, stat() is 
> one of the *slowest* syscalls on almost every *nix system in existence.

Sure. I didn't mean to imply that stat() in its various incarnations is
fast by itself, just that git relies a lot on it since it necessarily needs
to look at every file.

-h

