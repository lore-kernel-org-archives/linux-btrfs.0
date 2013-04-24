Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:60792 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949Ab3DXNHF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Apr 2013 09:07:05 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 112C89A0689
	for <linux-btrfs@vger.kernel.org>; Wed, 24 Apr 2013 07:07:04 -0600 (MDT)
Date: Wed, 24 Apr 2013 09:07:01 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix all callers of read_tree_block
Message-ID: <20130424130701.GG2631@localhost.localdomain>
References: <1366741222-1825-1-git-send-email-jbacik@fusionio.com>
 <20130424081747.GF19283@liubo.jp.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130424081747.GF19283@liubo.jp.oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 24, 2013 at 02:17:48AM -0600, Liu Bo wrote:
> On Tue, Apr 23, 2013 at 02:20:22PM -0400, Josef Bacik wrote:
> > We kept leaking extent buffers when mounting a broken file system and it turns
> > out it's because not everybody uses read_tree_block properly.  You need to check
> > and make sure the extent_buffer is uptodate before you use it.  This patch fixes
> > everybody who calls read_tree_block directly to make sure they check that it is
> > uptodate and free it and return an error if it is not.  With this we no longer
> > leak EB's when things go horribly wrong.  Thanks,
> 
> What about hook the check into read_tree_block()?
> 
> That way we can save much efforts.

Because other people do other things when it gets back from read_tree_block(),
the readahead code and the search ahead code to name a few.  Thanks,

Josef
