Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:53059 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab3EVOXf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 May 2013 10:23:35 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id A97799A068F
	for <linux-btrfs@vger.kernel.org>; Wed, 22 May 2013 08:23:34 -0600 (MDT)
Date: Wed, 22 May 2013 10:23:32 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Laurent Humblet <laurent.humblet@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Top shows brtfs-cache-1 and brtfs-endio-met while the hard
 drives seem busy
Message-ID: <20130522142332.GA10043@localhost.localdomain>
References: <CAFirYm_LZh74n=x7_Jp_M_t3FHsuPfvWsiNRNmJY1H5gvXg8hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAFirYm_LZh74n=x7_Jp_M_t3FHsuPfvWsiNRNmJY1H5gvXg8hQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 22, 2013 at 07:22:42AM -0600, Laurent Humblet wrote:
> Hi,
> 
> I have setup about a year ago a BTRFS RAID 1 filesystem on two 2TB
> Western Digital WD20EARS hard drives and I have created subvolumes
> that I mount regularly as I need them.  I put mostly music, videos and
> various files on them as well as some Git bare repositories for my
> work files but for the last couple of weeks, there seems to be some
> activity happening on the drives for a few minutes and the following
> processes are showing up while this happens: brtfs-cache-1 and
> brtfs-endio-met.  It seems that brtfs-cache-1 is more 'busy' than
> brtfs-endio-met but after a while everything seems fine again.
> 
> Is there anything I should worry about?  I will soon do a full backup
> on ext4 just to make sure I don't loose anything but is there any
> checks I can run on the drives to make sure everything is fine both on
> a hardware standpoint and on a data integrity standoint?
> 

Can you mount -o space_cache,inode_cache, that will get rid of the btrfs-cache-1
stuff (after the cache's have all been built up).  Thanks,

Josef
