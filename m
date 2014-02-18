Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:63466 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbaBRSQv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 13:16:51 -0500
Received: from frosties.localnet ([149.172.224.32]) by smtp.web.de (mrweb102)
 with ESMTPSA (Nemesis) id 0Lrruc-1XI4w328r8-013cMs for
 <linux-btrfs@vger.kernel.org>; Tue, 18 Feb 2014 19:16:49 +0100
Date: Tue, 18 Feb 2014 19:16:48 +0100
From: Goswin von Brederlow <goswin-v-b@web.de>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC with 270GiB free
Message-ID: <20140218181648.GA26848@frosties>
References: <20140216135808.GA1491@frosties>
 <530366F2.2010009@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <530366F2.2010009@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 18, 2014 at 08:58:10AM -0500, Josef Bacik wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 02/16/2014 08:58 AM, Goswin von Brederlow wrote:
> > Hi,
> > 
> > I'm getting a ENOSPC error from btrfs despite there still being
> > plenty of space left:
> > 
> > % df -m /mnt/nas3 Filesystem         1M-blocks     Used Available
> > Use% Mounted on /dev/mapper/nas3-a  19077220 18805132    270773
> > 99% /mnt/nas3
> > 
> > % btrfs fi show Label: none  uuid:
> > 4b18f84e-2499-41ca-81ff-fe1783c11491 Total devices 1 FS bytes used
> > 17.91TiB devid    1 size 18.19TiB used 17.94TiB path
> > /dev/mapper/nas3-a
> > 
> > Btrfs v3.12
> > 
> > % btrfs fi df Data, single: total=17.89TiB, used=17.88TiB System,
> > DUP: total=32.00MiB, used=1.92MiB Metadata, DUP: total=25.50GiB,
> > used=24.89GiB
> > 
> > As you can see there are still 270GiB free and plenty of block
> > groups free on the device too.
> > 
> > So why isn't btrfs allocating a new block group to store more
> > data?
> > 
> > 
> 
> What kernel?  Can you give btrfs-next a try?  Mount with -o
> enospc_debug and when you get enospc send the dmesg.  Thanks,
> 
> Josef

Standard Debian linux kernel:

Linux nas3 3.12-1-amd64 #1 SMP Debian 3.12.9-1 (2014-02-01) x86_64 GNU/Linux

Compiling new kernel and rebooting will take some time. But it looks
like I can remount with enospc_debug. I will try if that outputs
anything usefull first. So far I got:

[258988.006643] btrfs: disk space caching is enabled

MfG
	Goswin
