Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56494 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967Ab3EVWbj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 May 2013 18:31:39 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UfHZJ-000459-Ra
	for linux-btrfs@vger.kernel.org; Thu, 23 May 2013 00:31:37 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 May 2013 00:31:37 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 23 May 2013 00:31:37 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs pseudo-drbd
Date: Wed, 22 May 2013 23:31:27 +0100
Message-ID: <knjgvq$r91$1@ger.gmane.org>
References: <knb2ak$p9p$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <knb2ak$p9p$2@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/05/13 18:32, Martin wrote:
> Dear Devs,
> 
> Would there be any problem to use nbd (/dev/ndX) devices to gain
> btrfs-raid across multiple physical hosts across a network? (For a sort
> of btrfs-drbd! :-) )
> 
> 
> Regards,
> Martin
> 
> 
> http://en.wikipedia.org/wiki/Network_block_device
> 
> http://www.drbd.org/


As a follow-up, both nbd and AoE look to be active.

nbd uses tcp/ip (layer 3) and is network routable;

AoE operates on layer 2 (no IP addressing) and so looks to enjoy a lower
overhead for the performance. Ideal for putting together your own low
cost SAN!


Network Block Device (TCP version)
http://nbd.sourceforge.net/

ATA Over Ethernet: As an Alternative
http://www.rfxn.com/ata-over-ethernet-as-an-alternative/

EtherDrive® storage and Linux 2.6
http://support.coraid.com/support/linux/EtherDrive-2.6-HOWTO.html




Hope of interest,

Regards,
Martin

