Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from v002983.home.net.pl ([212.85.107.189]:42341 "HELO
	v002983.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752372Ab2FLOsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 10:48:15 -0400
From: Hubert Kario <hka@qbs.com.pl>
To: Alex <alex@bpmit.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: KVM on top of BTRFS
Date: Tue, 12 Jun 2012 16:48:12 +0200
Message-ID: <5750408.cQYfZEkS7F@k85hala03>
In-Reply-To: <loom.20120612T013031-188@post.gmane.org>
References: <1339456922.32583.YahooMailNeo@web160802.mail.bf1.yahoo.com> <loom.20120612T013031-188@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 11 of June 2012 23:53:34 Alex wrote:
> Matthew Hawn <steamraven <at> yahoo.com> writes:
> > What are the recommendations for running KVM images on BTRFS systems using
> 
> Install:
> virt-install --connect qemu:///system -n china -r 256 --disk
> path=/var/lib/libvirt/images/china.img,size=4 -c
> /home/alex/debian-testing-amd64-CD-1.iso --vnc --noautoconsole --os-type
> linux --os-variant debianwheezy --accelerate --network=bridge:br0 --hvm
> 
> This runs much slower than expected - have done many debian bare minimum
> installs like this before. Can't hear any disk thrashing. Doesn't appear to
> be CPU or memory bound - will double check.

>From what I heard, this is caused by slow KVM CD virtualisation.

Try to install it and do some tests then.

Regards,
--
Hubert Kario
QBS - Quality Business Software
02-656 Warszawa, ul. Ksawerów 30/85
tel. +48 (22) 646-61-51, 646-74-24
www.qbs.com.pl
