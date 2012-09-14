Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:53550 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752329Ab2INMpT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 08:45:19 -0400
Date: Fri, 14 Sep 2012 08:45:16 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: kill obsolete arguments in
 btrfs_wait_ordered_extents
Message-ID: <20120914124516.GK12994@localhost.localdomain>
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
 <1347613087-3489-5-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1347613087-3489-5-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 02:58:07AM -0600, Liu Bo wrote:
> nocow_only is now an obsolete argument.
> 

Why is it obsolete, it looks like it's being used to me?  Thanks,

Josef
