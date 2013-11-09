Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56087 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab3KIK5b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 9 Nov 2013 05:57:31 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Vf6EH-0005OB-F3
	for linux-btrfs@vger.kernel.org; Sat, 09 Nov 2013 11:57:25 +0100
Received: from dyndsl-178-142-088-005.ewe-ip-backbone.de ([178.142.88.5])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Nov 2013 11:57:25 +0100
Received: from hurikhan77+btrfs by dyndsl-178-142-088-005.ewe-ip-backbone.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 09 Nov 2013 11:57:25 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Btrfs might be gradually slowing the boot process
Date: Sat, 09 Nov 2013 11:57:43 +0100
Message-ID: <72h1la-adf.ln1@hurikhan77.spdns.de>
References: <527d2ee689e077.81319728@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

yzb3@wp.pl <yzb3@wp.pl> schrieb:

> I recently noticed that my boot has become slower - it took around 29s,
> while at the beginning it was ~6s. I thought it was an issue with systemd,
> because it failed to properly indicate at which stage the slowdown
> occurred and how long it took. I rolled back to a pretty fresh root
> subvolume and the boot was fast again. However, after several reboots it
> started lagging again (10s? preposterous!). I decided to try the
> *clear_cache* mount option; it was only a guess, but it did speed the boot
> to the proper ~6s.
> 
> The question is - why? My filesystem is really small - I see no reason for
> a 5x boot slowdown. Is this a known issue? I will be glad to give any
> additional details about my fs.

I'm using a similar setup (although my btrfs rootfs is a 3 disk array and is 
more or less huge) and I didn't see such a vast boot slowdown. Did you check 
that systemd is actually using the readahead services which will relocate 
and defragment your boot files automatically?

HTH
Kai

