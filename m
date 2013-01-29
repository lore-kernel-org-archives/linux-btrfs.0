Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36683 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626Ab3A2Qnf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 11:43:35 -0500
Date: Tue, 29 Jan 2013 17:43:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, Jim Schutt <jaschut@sandia.gov>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
Message-ID: <20130129164331.GA30535@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
 <50E5D19E.3060406@sandia.gov>
 <20130128212331.GG3257@localhost.localdomain>
 <20130129023007.GB15654@liubo.jp.oracle.com>
 <20130129134730.GB3660@localhost.localdomain>
 <20130129135034.GC3660@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130129135034.GC3660@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 29, 2013 at 08:50:34AM -0500, Josef Bacik wrote:
> On Tue, Jan 29, 2013 at 08:47:30AM -0500, Josef Bacik wrote:
> > 251      [not run] FSTRIM is not supported
> > 
> > Are you sure its 251?  Thanks,
> 
> Sorry it's early, I need a device that does trim.  /me waits for his fusion card
> to get back from the shop,

You can use scsi_debug device with

parm:           lbpu:enable LBP, support UNMAP command (def=0) (int)

david
