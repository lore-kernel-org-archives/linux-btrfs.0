Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:51664 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab3FJNAu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 09:00:50 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 0839B7C067E
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Jun 2013 07:00:50 -0600 (MDT)
Date: Mon, 10 Jun 2013 09:00:47 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Thomas Koch <thomas@koch.ro>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Stale NFS file handle after power loss
Message-ID: <20130610130047.GA10307@localhost.localdomain>
References: <65278856.dWSg6uQ8zb@x121e>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <65278856.dWSg6uQ8zb@x121e>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 08, 2013 at 01:14:35PM -0600, Thomas Koch wrote:
> Hi,
> 
> I had a power loss on my btrfs file system during package installation and now 
> I found this:
> 
> <code>
> % ls -l /var/lib/dpkg/tmp.ci
> ls: cannot access /var/lib/dpkg/tmp.ci/conffiles: Stale NFS file handle
> ls: cannot access /var/lib/dpkg/tmp.ci/md5sums: Stale NFS file handle
> total 0
> -????????? ? ? ? ?            ? conffiles
> -????????? ? ? ? ?            ? md5sums
> % sudo rm -rf /var/lib/dpkg/tmp.ci/conffiles
> rm: cannot remove ‘/var/lib/dpkg/tmp.ci/conffiles’: Stale NFS file handle
> </code>
> 
> I booted with a live system and ran btrfsck (without --repair!) but this did 
> not change the situation. Unfortunately I wasn't clever enough to save the 
> output of btrfsck somehow. Do you need it?
> 
> Could you help me to get rid of these bogus files, please?

Don't run with --repair, but please capture the output so I can see what's going
wrong.  Thanks,

Josef
