Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41973 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330Ab3AHP7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 10:59:52 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Tsbat-00040F-S7
	for linux-btrfs@vger.kernel.org; Tue, 08 Jan 2013 17:00:03 +0100
Received: from netkingxp.iwf.ing.tu-bs.de ([134.169.61.21])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2013 17:00:03 +0100
Received: from G.Gersdorf by netkingxp.iwf.ing.tu-bs.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2013 17:00:03 +0100
To: linux-btrfs@vger.kernel.org
From: =?ISO-8859-1?Q?G=FCnter_Gersdorf?= <G.Gersdorf@tu-bs.de>
Subject: Re: Btrfs: wipe all the superblock [redhat bugzilla 889888]
Date: Tue, 08 Jan 2013 16:48:44 +0100
Message-ID: <kchf4t$scf$1@ger.gmane.org>
References: <50E9C267.3050302@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
In-Reply-To: <50E9C267.3050302@inwind.it>
Cc: util-linux@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 06.01.2013 19:28, schrieb Goffredo Baroncelli:
>
> You can pull the change from:
> 	http://cassiopea.homelinux.net/git/util-linux.git
> from the branch
> 	btrfs-wipefs
>
After applying this patch, findfs and blkid didn't find filesystems 
smaller than 256GB, probably because there is no third superblock.

Günter


