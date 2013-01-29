Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056Ab3A2Qww (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Jan 2013 11:52:52 -0500
Date: Tue, 29 Jan 2013 17:52:51 +0100
From: David Sterba <dsterba@suse.cz>
To: David Sterba <dsterba@suse.cz>
Cc: Josef Bacik <jbacik@fusionio.com>, Liu Bo <bo.li.liu@oracle.com>,
        Jim Schutt <jaschut@sandia.gov>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix a deadlock on chunk mutex
Message-ID: <20130129165250.GB30535@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1355363557-2962-1-git-send-email-bo.li.liu@oracle.com>
 <20121218135242.GC2403@localhost.localdomain>
 <50E5D19E.3060406@sandia.gov>
 <20130128212331.GG3257@localhost.localdomain>
 <20130129023007.GB15654@liubo.jp.oracle.com>
 <20130129134730.GB3660@localhost.localdomain>
 <20130129135034.GC3660@localhost.localdomain>
 <20130129164331.GA30535@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130129164331.GA30535@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 29, 2013 at 05:43:31PM +0100, David Sterba wrote:
> On Tue, Jan 29, 2013 at 08:50:34AM -0500, Josef Bacik wrote:
> You can use scsi_debug device with
> 
> parm:           lbpu:enable LBP, support UNMAP command (def=0) (int)

Also, loop device with a file backed by a filesystem with hole punch
support also understands TRIM.

david
