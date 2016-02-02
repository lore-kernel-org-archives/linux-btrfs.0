Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtprelay06.ispgateway.de ([80.67.31.101]:40139 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbcBBWBn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Feb 2016 17:01:43 -0500
Subject: Re: booting from BTRFS works only with one device in the pool
To: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <56AFCEC3.9050803@friedels.name>
 <20160201221120.GD8313@carfax.org.uk>
From: Hendrik Friedel <hendrik@friedels.name>
Message-ID: <56B12742.9090101@friedels.name>
Date: Tue, 2 Feb 2016 23:01:38 +0100
MIME-Version: 1.0
In-Reply-To: <20160201221120.GD8313@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Hugo,

 >> Here I am stuck in a recovery prompt.
>     By far the simplest and most reliable method of doing this is to
> use an initramfs with the command "btrfs dev scan" in it somewhere
> before mounting. Most of the major distributions already have an
> initramfs set up (as does yours, I see), and will install the correct
> commands in the initramfs if you install the btrfs-progs package
> (btrfs-tools in Debian derivatives).
>
I would like to go the sensible way :-)
But can you hint me how and where to add the btrfs device scan option to 
the initramfs?

Regards,
Hendrik

---
Diese E-Mail wurde von Avast Antivirus-Software auf Viren geprüft.
https://www.avast.com/antivirus

