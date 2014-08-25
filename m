Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34267 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350AbaHYPTY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Aug 2014 11:19:24 -0400
Date: Mon, 25 Aug 2014 23:19:15 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v3] Btrfs: fix task hang under heavy compressed write
Message-ID: <20140825151914.GF22848@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1407829499-21902-1-git-send-email-bo.li.liu@oracle.com>
 <1408117013-305-1-git-send-email-bo.li.liu@oracle.com>
 <53FB4F05.6050801@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53FB4F05.6050801@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 25, 2014 at 10:58:13AM -0400, Chris Mason wrote:
> On 08/15/2014 11:36 AM, Liu Bo wrote:
> > This has been reported and discussed for a long time, and this hang occurs in
> > both 3.15 and 3.16.
> 
> [ great description ]
> 
> I ran this through tests last week, and an overnight test over the
> weekend.  It's in my for-linus branch now, along with everything else I
> plan on sending for rc3.
> 
> Please double check my merge, I had to undo your rebase onto Miao's patches.

Just checked, looks good ;)

thanks,
-liubo
