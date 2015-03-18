Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50188 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933518AbbCRTAE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Mar 2015 15:00:04 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1YYJCD-0003Mg-NC
	for linux-btrfs@vger.kernel.org; Wed, 18 Mar 2015 20:00:01 +0100
Received: from pd953ef24.dip0.t-ipconnect.de ([217.83.239.36])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 20:00:01 +0100
Received: from holger.hoffstaette by pd953ef24.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Mar 2015 20:00:01 +0100
To: linux-btrfs@vger.kernel.org
From: Holger =?iso-8859-1?q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Subject: Re: [PATCH 0/4] Accounting fixes
Date: Wed, 18 Mar 2015 18:59:39 +0000 (UTC)
Message-ID: <pan.2015.03.18.18.59.39@googlemail.com>
References: <1426624683-3085-1-git-send-email-jbacik@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 17 Mar 2015 16:37:59 -0400, Josef Bacik wrote:

> I've changed all of these a whole bunch recently, I think I've gotten all the
> issues worked out, please review/test to make sure there's not some other
> fucking corner I've missed.  Thanks,

So at least for me these seem to fix the problems that happened since the
"account for large extents" patch. Large fallocate/rm cycles no longer trip
over each other with the block group collector, and balance no longer goes
into la-la land waiting for extent bit changes that never show up.

Thanks!

-h


