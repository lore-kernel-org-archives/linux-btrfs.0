Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57387 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3EKQrx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 May 2013 12:47:53 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Tim Eggleston <lists@timeggleston.co.uk>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Defragmentation of large files
Date: Sat, 11 May 2013 18:47:48 +0200
Message-ID: <2041896.zZaOgtZsWg@merkaba>
In-Reply-To: <7f41ae131c619b653da281429fcead79@mail.39.gs>
References: <7f41ae131c619b653da281429fcead79@mail.39.gs>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 11. Mai 2013, 12:27:09 schrieb Tim Eggleston:
> Hi list,
> 
> I have a few large image files (VMware workstation VMDKs and TrueCrypt
> containers) which I routinely back up over the network to a btrfs raid10
> volume via bigsync (https://code.google.com/p/bigsync/).
> 
> The VM images in particular get really fragmented due to CoW, which is
> expected. I haven't yet switched off CoW on the backups directory mainly
> to experiment and see what would happen. So doing that would be an
> acceptable solution to my issue below, but I'm curious as to what's
> happening.
> 
> Filefrag reports that a VM image file has 4744 extents. If I run btrfs
> fi defrag -v /path/to/file.vmdk, it returns immediately with no messages
> but an exit status of 20, and running filefrag again shows that no
> defragmentation has taken place.
> 
> This is on Ubuntu 13.04, kernel 3.9.0-rc8 and v0.20-rc1 of the tools,
> and the file in the example is 34GB.
> 
> Any ideas what's happening here?

Yes. The command just triggers the defragmentation which takes place in the 
background. Try a "sync" afterwards :)

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
