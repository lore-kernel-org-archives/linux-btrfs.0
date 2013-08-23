Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:56391 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968Ab3HWSed (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 23 Aug 2013 14:34:33 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id B61757C0431
	for <linux-btrfs@vger.kernel.org>; Fri, 23 Aug 2013 12:34:33 -0600 (MDT)
Date: Fri, 23 Aug 2013 14:34:31 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: <xfs@oss.sgi.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] xfstests: update _filter_size() for Btrfs
Message-ID: <20130823183431.GG29654@localhost.localdomain>
References: <1377263233-8903-1-git-send-email-sbehrens@giantdisaster.de>
 <1377263233-8903-3-git-send-email-sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1377263233-8903-3-git-send-email-sbehrens@giantdisaster.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 23, 2013 at 03:07:12PM +0200, Stefan Behrens wrote:
> From: root <root@qvarne.iata>
> 
> The btrfs-progs tools changed the output:
> - 100GiB instead of 100GB
> 
> xfstest btrfs/006 is one that failed due to this change.
> 
> Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>

Thank you for this, it was super annoying with the new btrfs-progs breaking
this.

Reviewed-by: Josef Bacik <jbacik@fusionio.com>

Thanks,

Josef
