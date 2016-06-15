Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432AbcFOPdG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 11:33:06 -0400
Date: Wed, 15 Jun 2016 17:33:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Eryu Guan <guaneryu@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: BUG: unable to mount btrfs on ppc64 starting from v4.7-rc3 kernel
Message-ID: <20160615153335.GL6205@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160614111322.GN10350@eguan.usersys.redhat.com>
 <20160614182404.GA4398@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160614182404.GA4398@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 14, 2016 at 11:24:04AM -0700, Liu Bo wrote:
> > [ 1910.048650] BTRFS: device fsid 06813ff6-d585-4c54-b4df-b7d6920d27ba devid 1 transid 3 /dev/vda3
> > [ 1913.152085] BTRFS error (device vda3): invalid stripesize 4096
> > [ 1913.154349] BTRFS error (device vda3): superblock contains fatal errors
> > [ 1913.200300] BTRFS: open_ctree failed
> 
> Ah, that's right, we need to update btrfs-progs to set super_stripesize to
> sectorsize.
> 
> In mkfs.c we have,
> 
> {
> 	u32 sectorsize = 4096;
> 	u32 stripesize = 4096;
> 	...
> 	sectorsize = max(sectorsize, (u32)sysconf(_SC_PAGESIZE));
> 	...
> 	mkfs_cfg.sectorsize = sectorsize;
> 	mkfs_cfg.stripesize = stripesize;
> 
> 	ret = make_btrfs(fd, &mkfs_cfg, NULL);
> 	...
> }

Yeah we need to fix progs and allow the 4k value in kernel, Chandan will
send a patch.
