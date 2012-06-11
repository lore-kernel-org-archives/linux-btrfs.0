Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52172 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab2FKXxr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jun 2012 19:53:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1SeEQa-0003uk-Bw
	for linux-btrfs@vger.kernel.org; Tue, 12 Jun 2012 01:53:44 +0200
Received: from 78-32-127-104.static.enta.net ([78-32-127-104.static.enta.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 01:53:44 +0200
Received: from alex by 78-32-127-104.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Jun 2012 01:53:44 +0200
To: linux-btrfs@vger.kernel.org
From: Alex <alex@bpmit.com>
Subject: Re: KVM on top of BTRFS
Date: Mon, 11 Jun 2012 23:53:34 +0000 (UTC)
Message-ID: <loom.20120612T013031-188@post.gmane.org>
References: <1339456922.32583.YahooMailNeo@web160802.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Matthew Hawn <steamraven <at> yahoo.com> writes:

> 
> What are the recommendations for running KVM images on BTRFS systems using
kernel 3.4?  I saw older
> posts on the web complaining about poor performance, but I know a lot of work
has gone into btrfs since then.
>  There also seemed to be the nocow option, but I didn't find anything that
said it actualy helped.
> 

Running KVM image files on btrfs as of yesterday.
Used mkfs.btrfs -l 32k -n 32k to create and default options only (no mount
options bar defaults, so no compression (just asking for trouble!), or
autodefrag). 3.4.1 official Debian AMD64 kernel. Multi-subvol including root
with set-default enacted. 32k's adopted per Chris's post.

Install:
virt-install --connect qemu:///system -n china -r 256 --disk
path=/var/lib/libvirt/images/china.img,size=4 -c
/home/alex/debian-testing-amd64-CD-1.iso --vnc --noautoconsole --os-type linux
--os-variant debianwheezy --accelerate --network=bridge:br0 --hvm 

This runs much slower than expected - have done many debian bare minimum
installs like this before. Can't hear any disk thrashing. Doesn't appear to be
CPU or memory bound - will double check.

Want to add autodefrag option but saw a comment about it on the wiki gotchas
page or here (~ need to make sure it doesn't multi invoke or sommat?).

In contrast, VirtualBox 60GB WindowsXP guests quite happy running and very quick
on standard btrfs 3.3.7 kernel create in ArchLinux - with absolutely no flash
stuff. Didn't create them in btrfs though (XFS).

That may be the difference: level of churn in the file.
Saw a post about using filefrag program on btrfs and want to try that.

Questions?


