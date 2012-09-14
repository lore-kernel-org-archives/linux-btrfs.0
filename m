Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:48299 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab2INNBZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 09:01:25 -0400
Date: Fri, 14 Sep 2012 09:01:16 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 5/5] Btrfs: kill obsolete arguments in
 btrfs_wait_ordered_extents
Message-ID: <20120914130116.GL12994@localhost.localdomain>
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
 <1347613087-3489-5-git-send-email-bo.li.liu@oracle.com>
 <20120914124516.GK12994@localhost.localdomain>
 <5053293B.6010400@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5053293B.6010400@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 06:55:23AM -0600, Liu Bo wrote:
> On 09/14/2012 08:45 PM, Josef Bacik wrote:
> > On Fri, Sep 14, 2012 at 02:58:07AM -0600, Liu Bo wrote:
> >> nocow_only is now an obsolete argument.
> >>
> > 
> > Why is it obsolete, it looks like it's being used to me?  Thanks,
> > 
> 
> All of its callers use 0 as nocow_only now.
> 

Ooooh I saw that wrong, thought the last argument was nocowonly.  Thanks,

Josef
