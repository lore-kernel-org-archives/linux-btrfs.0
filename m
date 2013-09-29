Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55350 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754899Ab3I2Vz5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Sep 2013 17:55:57 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VQOy4-0005Mu-9b
	for linux-btrfs@vger.kernel.org; Sun, 29 Sep 2013 23:55:56 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 23:55:56 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 23:55:56 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Corrupt btrfs filesystem recovery... What best instructions?
Date: Sun, 29 Sep 2013 22:55:43 +0100
Message-ID: <l2a7km$gi8$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org> <l2826k$1uc$1@ger.gmane.org> <pan$69794$b0c00066$a4aa3035$c87a3c3d@cox.net> <l2a635$37m$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <l2a635$37m$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29/09/13 22:29, Martin wrote:

> Looking up what's available for Gentoo, the maintainers there look to be
> nicely sharp with multiple versions available all the way up to kernel
> 3.11.2...

That is being pulled in now as expected:

sys-kernel/gentoo-sources-3.11.2


> There's also the latest available from btrfs tools with
> sys-fs/btrfs-progs "9999"...

Oddly, that caused emerge to report:

[ebuild     UD ] sys-fs/btrfs-progs-0.19.11 [0.20_rc1_p358] 0 kB

which is a *downgrade*. Hence, I'm keeping with the 0.20_rc1_p358.


> OK, so onto the cutting edge to compile them in...

Interesting times as is said in a certain part of the world...
Martin



