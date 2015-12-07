Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:41121 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbbLGQwz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Dec 2015 11:52:55 -0500
Received: from localhost
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-btrfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
	Mon, 7 Dec 2015 22:22:53 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 5CD073940019
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Dec 2015 22:22:50 +0530 (IST)
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay02.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tB7Gqm4M10158444
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Dec 2015 22:22:49 +0530
Received: from d28av03.in.ibm.com (localhost [127.0.0.1])
	by d28av03.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tB7Gqm31024604
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Dec 2015 22:22:48 +0530
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Introduce new mount option to disable tree log replay
Date: Mon, 07 Dec 2015 22:22:46 +0530
Message-ID: <2856934.1tulUexfpA@localhost.localdomain>
In-Reply-To: <5665B359.2050906@redhat.com>
References: <1449468402-27914-1-git-send-email-quwenruo@cn.fujitsu.com> <5665B359.2050906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 07 Dec 2015 10:27:05 Eric Sandeen wrote:
> On 12/7/15 12:06 AM, Qu Wenruo wrote:
> > Introduce a new mount option "nologreplay" to co-operate with "ro" mount
> > option to get real readonly mount, like "norecovery" in ext* and xfs.
> > 
> > Since the new parse_options() need to check new flags at remount time,
> > so add a new parameter for parse_options().
> > 
> > Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> > ---
> > 
> >  Documentation/filesystems/btrfs.txt |  5 +++++
> >  fs/btrfs/ctree.h                    |  4 +++-
> >  fs/btrfs/disk-io.c                  |  7 ++++---
> >  fs/btrfs/super.c                    | 20 +++++++++++++++++---
> >  4 files changed, 29 insertions(+), 7 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/btrfs.txt
> > b/Documentation/filesystems/btrfs.txt index c772b47..ac4ed68 100644
> > --- a/Documentation/filesystems/btrfs.txt
> > +++ b/Documentation/filesystems/btrfs.txt
> > @@ -168,6 +168,11 @@ Options with (*) are default options and will not
> > show in the mount options.> 
> >    notreelog
> >  	
> >  	Enable/disable the tree logging used for fsync and O_SYNC writes.
> > 
> > +  nologreplay
> > +	Disable the log tree replay at mount time for real read-only mount.
> > +	Must be use with "ro" mount option and can't be disabled by mount
> > +	option.
> 
> This documentation is not clear to me - "can't be disabled by mount option?"
> 
> I think you mean to talk about remount here?  Perhaps something like:
> 
> "... Must be used with 'ro' mount option.  A filesystem mounted with the
> 'nologreplay' option cannot transition to a read-write mount via
> remount,rw - the filesystem must be unmounted and remounted if read-write
> access is desired."
> 
Eric, I had assumed the same logic with respect to the transition from 'ro' to
'rw' via remount. But when doing so, btrfs_remount() flags an error only when
a valid 'tree log' tree is present in the filesystem
i.e. btrfs_super_block->log_root has a non-zero value. Otherwise,
btrfs_remount() does not seem to have any problem with the transition from
'ro' to 'rw'.

-- 
chandan

