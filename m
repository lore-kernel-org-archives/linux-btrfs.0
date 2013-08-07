Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:46004 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757164Ab3HGS5H (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 14:57:07 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id D0F0E7C067E
	for <linux-btrfs@vger.kernel.org>; Wed,  7 Aug 2013 12:57:06 -0600 (MDT)
Date: Wed, 7 Aug 2013 14:57:04 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Tomasz Chmielewski <tch@virtall.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs filesystem "hang" after page allocation failure: order:0 +
 kernel BUG at fs/btrfs/extent_io.c:4151
Message-ID: <20130807185704.GC2397@localhost.localdomain>
References: <20130808021705.1dcb139e@virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130808021705.1dcb139e@virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 08, 2013 at 02:17:05AM +0800, Tomasz Chmielewski wrote:
> One of btrfs filesystems hanged on my server.
> 
> By "hang", I mean it's not possible to finish any write operation, i.e.:
> 
> # cd /mnt/btrfs
> 
> # ls
> some-file
> 
> # touch 1
> [it never returns to shell here]
> 

I've just posted a patch to get rid of the panic on oom, could you please apply
it and verify you no longer see the panic?  The OOM is another issue, but we
should at the very least not panic.  Thanks,

Josef
