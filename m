Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.39.gs ([212.13.216.70]:41202 "EHLO mail.39.gs"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab3EKLhs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 11 May 2013 07:37:48 -0400
Received: from mail.39.gs (unknown [212.13.216.70])
	by mail.39.gs (Postfix) with ESMTPA id CB119813E2
	for <linux-btrfs@vger.kernel.org>; Sat, 11 May 2013 12:27:09 +0100 (BST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sat, 11 May 2013 12:27:09 +0100
From: Tim Eggleston <lists@timeggleston.co.uk>
To: linux-btrfs@vger.kernel.org
Subject: Defragmentation of large files
Message-ID: <7f41ae131c619b653da281429fcead79@mail.39.gs>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list,

I have a few large image files (VMware workstation VMDKs and TrueCrypt 
containers) which I routinely back up over the network to a btrfs raid10 
volume via bigsync (https://code.google.com/p/bigsync/).

The VM images in particular get really fragmented due to CoW, which is 
expected. I haven't yet switched off CoW on the backups directory mainly 
to experiment and see what would happen. So doing that would be an 
acceptable solution to my issue below, but I'm curious as to what's 
happening.

Filefrag reports that a VM image file has 4744 extents. If I run btrfs 
fi defrag -v /path/to/file.vmdk, it returns immediately with no messages 
but an exit status of 20, and running filefrag again shows that no 
defragmentation has taken place.

This is on Ubuntu 13.04, kernel 3.9.0-rc8 and v0.20-rc1 of the tools, 
and the file in the example is 34GB.

Any ideas what's happening here?

Cheers,

  ---tim
