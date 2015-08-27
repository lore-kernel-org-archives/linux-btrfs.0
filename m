Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:35686 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751339AbbH0BOr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Aug 2015 21:14:47 -0400
Date: Thu, 27 Aug 2015 11:14:22 +1000
From: Dave Chinner <david@fromorbit.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5] fstests: btrfs: Add reserved space leak check for
 rewrite dirty page
Message-ID: <20150827011422.GH3902@dastard>
References: <1440119834-31504-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150826064146.GS17933@dhcp-13-216.nay.redhat.com>
 <55DD68E8.2020702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55DD68E8.2020702@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 26, 2015 at 03:21:12PM +0800, Qu Wenruo wrote:
> Eryu Guan wrote on 2015/08/26 14:41 +0800:
> >Just one minor issue here, please remove $seqres.full before test,
> >otherwise $seqres.full will keep growing.
>
> Oh, you're right.
> I did forgot to remove it.
> 
> BTW, is it better to add 'rm $seqres.full' to the template?

Yes, that's a good idea. Separate patch, though. ;)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
