Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:50461 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965602Ab3FUBK1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 21:10:27 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 3B5E69A0406
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 19:10:27 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: Chris Mason <chris.mason@fusionio.com>
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
 <1371729930-22497-5-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1371729930-22497-5-git-send-email-bo.li.liu@oracle.com>
Message-ID: <20130621011024.4477.64844@localhost.localdomain>
Subject: Re: [PATCH 4/4] Btrfs-progs: exhance btrfs-image to restore image onto
 multiple disks
Date: Thu, 20 Jun 2013 21:10:24 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Liu Bo (2013-06-20 08:05:30)
> This adds a 'btrfs-image -m' option, which let us restore an image that
> is built from a btrfs of multiple disks onto several disks altogether.

I'd like to pull this in, could you please rebase it against my current
master?

Thanks!

-chris
