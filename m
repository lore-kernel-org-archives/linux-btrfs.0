Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:33536 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965102Ab3FTMrg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Jun 2013 08:47:36 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 574C07C068B
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Jun 2013 06:47:36 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>, Liu Bo <bo.li.liu@oracle.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130620122432.GA4288@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>
References: <1371729930-22497-1-git-send-email-bo.li.liu@oracle.com>
 <1371729930-22497-5-git-send-email-bo.li.liu@oracle.com>
 <20130620122432.GA4288@localhost.localdomain>
Message-ID: <20130620124734.5430.58917@localhost.localdomain>
Subject: Re: [PATCH 4/4] Btrfs-progs: exhance btrfs-image to restore image onto
 multiple disks
Date: Thu, 20 Jun 2013 08:47:34 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Josef Bacik (2013-06-20 08:24:32)
> On Thu, Jun 20, 2013 at 08:05:30PM +0800, Liu Bo wrote:
> > This adds a 'btrfs-image -m' option, which let us restore an image that
> > is built from a btrfs of multiple disks onto several disks altogether.
> > 
> > This aims to address the following case,
> > $ mkfs.btrfs -m raid0 sda sdb
> > $ btrfs-image sda image.file
> > $ btrfs-image -r image.file sdc
> > ---------
> > so we can only restore metadata onto sdc, and another thing is we can
> > only mount sdc with degraded mode as we don't provide informations of
> > another disk.  And, it's built as RAID0 and we have only one disk,
> > so after mount sdc we'll get into readonly mode.
> > 
> 
> Um that shouldn't be happening, the restore will mask out the RAID parts of the
> chunk tree and it should work just fine.  Are you using the most recent version
> of btrfs-image?  If this is happening it's a bug and we need to fix it, but I've
> restored several file systems from users with raid0/10 file systems onto a
> single disk and it's worked just fine.  Thanks,

I just pushed my current merge of Josef's patches into my master branch.
Please base on that.

Josef, this should only be missing the enospc log, please go ahead and
rebase/double check.

-chris

