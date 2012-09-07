Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:36356 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751250Ab2IGWDw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Sep 2012 18:03:52 -0400
Message-ID: <504A6F67.3060506@gmx.net>
Date: Sat, 08 Sep 2012 00:04:23 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Andreas Philipp <philipp.andreas@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Cannot create subvolume with quota enabled
References: <504A4CBF.7000605@gmail.com>
In-Reply-To: <504A4CBF.7000605@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Andreas,

On 09/07/2012 09:36 PM, Andreas Philipp wrote:
> Hi,
> 
> The following steps reproduce the error. My kernel is 3.6-rc4 and 
> btrfs-progs are at commit 89fe5b5f666c247aa3173745fb87c710f3a71a4a
> from 
> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
>
> 
master.
> 
> thor ~ # mkfs.btrfs -L test /dev/vg1/test
> 
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL WARNING! - see
> http://btrfs.wiki.kernel.org before using
> 
> fs created label test on /dev/vg1/test nodesize 4096 leafsize 4096
> sectorsize 4096 size 20.00GB Btrfs Btrfs v0.19 thor ~ # mount
> /dev/vg1/test /mnt/tmp thor ~ # btrfs quota enable /mnt/tmp thor ~
> # btrfs subvolume create /mnt/tmp/test Create subvolume
> '/mnt/tmp/test' ERROR: cannot create subvolume - Invalid argument

Thanks for giving quota a try. I sent a fix separately with
the subject

[PATCH] Btrfs: btrfs_qgroup_inherit wrongly returns an error

Could you please see if it fixes the problem?

Thanks,
Arne
> 
> Please, do not hesitate to contact me for any further information
> etc.
> 
> Thanks, Andreas -- To unsubscribe from this list: send the line
> "unsubscribe linux-btrfs" in the body of a message to
> majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> 

