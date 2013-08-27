Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58503 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab3H0Syz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 14:54:55 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 828477C06AA
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 12:54:55 -0600 (MDT)
Received: from CAS1.int.fusionio.com (cas1.int.fusionio.com [10.101.1.40]) by mx1.fusionio.com with ESMTP id 9F4oQSHSpegCWktw (version=TLSv1 cipher=AES128-SHA bits=128 verify=NO) for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 12:54:54 -0600 (MDT)
Date: Tue, 27 Aug 2013 14:54:53 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Josef Bacik <jbacik@fusionio.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: do not complete ordered extents that are truncated
Message-ID: <20130827185453.GL29654@localhost.localdomain>
References: <1377624014-6426-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1377624014-6426-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 27, 2013 at 01:20:14PM -0400, Josef Bacik wrote:
> Currently we will do the normal btrfs_finish_ordered_io if we invalidate a dirty
> page that is part of an ordered extent but hasn't yet been submitted for IO.
> The side effect of this is that when the rest of the ordered extent is completed
> it will still add its extent to the file and it's csums to the tree.  This
> usually isn't a problem since this occurs right before a truncate, so these
> csums and extents are going to be cleaned up.  However if there is an error
> doing the truncate we can leave extents that point to invalid data, and as such
> you'll get csum errors trying to read back this extent.  So to handle this just
> set a flag on the ordered extent if we are going to invalidate one of its dirty
> pages, and then once we go to do the completion stuff we skip updating the file
> extents and adding our csums, we just free everything up and exit.  This is
> preliminary work we need to have better orphan entry error handling.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>
> ---

Ignore this, it is wrong.

Josef
